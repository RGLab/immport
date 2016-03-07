<%
    /*
     * Copyright (c) 2014 LabKey Corporation
     *
     * Licensed under the Apache License, Version 2.0 (the "License");
     * you may not use this file except in compliance with the License.
     * You may obtain a copy of the License at
     *
     *     http://www.apache.org/licenses/LICENSE-2.0
     *
     * Unless required by applicable law or agreed to in writing, software
     * distributed under the License is distributed on an "AS IS" BASIS,
     * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
     * See the License for the specific language governing permissions and
     * limitations under the License.
     */
%>
<%@ taglib prefix="labkey" uri="http://www.labkey.org/taglib" %>
<%@ page import="org.labkey.api.data.Container" %>
<%@ page import="org.labkey.api.view.HttpView" %>
<%@ page import="org.labkey.api.view.ViewContext" %>
<%@ page import="org.labkey.api.view.template.ClientDependency" %>
<%@ page import="java.util.LinkedHashSet" %>
<%@ page extends="org.labkey.api.jsp.JspBase"%>
<%!
    public LinkedHashSet<ClientDependency> getClientDependencies()
    {
        LinkedHashSet<ClientDependency> resources = new LinkedHashSet<>();
        resources.add(ClientDependency.fromFilePath("clientapi/ext4"));
        return resources;
    }
%>
<%
    ViewContext context = HttpView.currentContext();
    Container c = context.getContainer();
%>

<table>
    <tr>
        <td valign="top">
            <div id="datasetsPanel"></div>
        </td>
        <td valign="top">
            <div id="studyFilter"></div>
        </td>
    </tr>
</table>

<script type="text/javascript">

    Ext4.onReady(function () {

        this.test = false;
        this.studies = [];
        this.datasets = {};
        this.queryPrefix = "ds_";
        this.files = [
            {dataset : "fcs_control_files", fileCol : "control_file"},
            {dataset : "fcs_sample_files", fileCol : "file_info_name"},
            {dataset : "gene_expression_files", fileCol : "file_info_name"}];

        // Only include "SDY" studies in the StudyProperties query
        var studyPropertyFilters = [
            LABKEY.Filter.create("Label", "SDY", LABKEY.Filter.Types.STARTS_WITH),
            LABKEY.Filter.create("Label", "SDY_template", LABKEY.Filter.Types.NEQ)
        ];

        var studyFilterWebPart = LABKEY.WebPart({
            partName: 'Shared Study Filter',
            renderTo: 'studyFilter',
            frame: 'none'
        });
        studyFilterWebPart.render();

        var dataStore = Ext4.create('Ext.data.Store', {
            storeId:'dataSets',
            fields:['id', 'name', 'include', 'label', 'numRows', 'type', 'fileSize', 'fileSizeDisplay', 'files'],
            data: {'items': []},
            proxy: {
                type: 'memory',
                reader: {
                    type: 'json',
                    root: 'items'
                }
            }
        });

        function getListOfDatasets()
        {
            LABKEY.Query.selectRows({
                schemaName : 'study',
                queryName : 'Datasets',
                containerPath : '<%=text(c.getPath())%>',
                success : function (details) {
                    var rows = details.rows;

                    for (var i = 0; i < rows.length; i++)
                    {
                        dataStore.add({
                            id: rows[i].DataSetId,
                            name: rows[i].Name,
                            label: rows[i].Label,
                            numRows: -1
                        });

                        getNumOfRows(rows[i].Name, rows[i].DataSetId);
                    }
                }, scope : this
            });

            dataStore.add({
                id: -1,
                name: "StudyProperties",
                label: "Studies",
                numRows: -1
            });
            getNumOfRows('StudyProperties', -1);
        }

        function getNumOfRows(queryName, datasetId)
        {
            var filters = [];
            if (queryName == "StudyProperties") {
                filters = studyPropertyFilters;
            }

            LABKEY.Query.selectRows({
                schemaName : 'study',
                queryName : queryName,
                includeTotalCount : true,
                showRows : 0,
                filterArray: filters,
                success : function(details) {
                    var record = dataStore.getById(datasetId);
                    record.set('numRows', details.rowCount);
                    record.set('type', 'Dataset (TSV)');
                    if(details.rowCount > 0)
                        record.set('include', true);
                    else
                        record.set('include', false);

                    // Gets studies
                    if(details.queryName === "StudyProperties") {
                        Ext4.each(details.rows, function(row){
                            this.studies.push(row.Label);
                        }, this);
                    }

                    // Right now these are hard coded
                    for(var i = 0; i<this.files.length; i++) {
                        if (this.files[i].dataset == details.queryName) {
                            this.datasets[details.queryName] = details;
                            this.datasets[details.queryName].datasetId = datasetId;
                            getFileData(details.queryName);
                        }
                    }

                    enableDownloadButton();
                    updateSummary();
                }, scope : this
            });
        }

        // Get file data for file datasets
        function getFileData(ds) {
            if(this.datasets[ds]) {
                var multi = new LABKEY.MultiRequest();

                for (var i = 0; i < this.studies.length; i++) {

                    var fileCol = "file_info_name";
                    for(var t=0; t < this.files.length; t++) {
                        if (this.files[t].dataset == ds) {
                            fileCol = this.files[t].fileCol;
                        }
                    }
                    multi.add(LABKEY.Query.executeSql, {
                        schemaName: 'immport',
                        sql: 'SELECT ds.filesize as filesize, ds.' + fileCol + ' as filename FROM ' + this.queryPrefix + ds + ' as ds GROUP BY ds.' + fileCol + ', ds.filesize',
                        sort: "ds.filesize",
                        parameters: {
                            $STUDY: this.studies[i]
                        },
                        success: function (details) {fileHandler.call(this, details, ds)},
                        scope: this
                    });
                }

                multi.send(function() {afterFiles(ds);}, this);
            }
        }

        function fileHandler(details, ds) {
            var dataset = this.datasets[ds];
            if(typeof dataset.fileSize == "undefined")
                dataset.fileSize = 0;

            if(typeof dataset.fileSizeDisplay == "undefined")
                dataset.fileSizeDisplay = "";

            if(typeof dataset.files == "undefined")
                dataset.files = 0;

            for (var i = 0; i < details.rowCount; i++) {
                dataset.fileSize += Math.round(details.rows[i].filesize / 1000);
                dataset.files++;
            }
        }

        // Now that we have all the file data, add it up and add records for it
        function afterFiles(ds) {
            if(this.datasets[ds].fileSize) {
                var record = dataStore.getById(this.datasets[ds].datasetId);
                var newRecord = record.copy(record.id + 'f');
                newRecord.set('type', 'File');
                newRecord.set('numRows', '');
                newRecord.set('files', datasets[ds].files);
                newRecord.set('fileSize', datasets[ds].fileSize); //kB
                newRecord.set('include', false);
                var displaySize = "< 1 kB";
                if(this.datasets[ds].fileSize.toString().length > 6)
                    displaySize = Math.round(datasets[ds].fileSize/10000)/100 + ' GB';
                else if(this.datasets[ds].fileSize.toString().length > 3)
                    displaySize = Math.round(datasets[ds].fileSize/10)/100 + ' MB';
                else
                    displaySize = Math.round(datasets[ds].fileSize * 100)/100 + ' kB';

                newRecord.set('fileSizeDisplay', displaySize);
                dataStore.add(newRecord);
            }

            if(ds == "gene_expression_files") {
                getGeneExpMatrices();
            } else {
                updateSummary();
            }
        }

        function getGeneExpMatrices() {
            LABKEY.Query.selectRows({
                schemaName : 'assay.ExpressionMatrix.matrix',
                queryName : this.test?'SelectedRuns2':'SelectedRuns',
                includeTotalCount : true,
                success : function(details) {
                    var record = dataStore.getById(this.datasets["gene_expression_files"].datasetId);
                    var newRecord = record.copy(this.datasets["gene_expression_files"].datasetId + 'm');
                    newRecord.set('label', 'Gene expression microarray matrices');
                    newRecord.set('type', 'File');
                    newRecord.set('numRows', '');
                    newRecord.set('files', details.rowCount);
                    newRecord.set('fileSize', '');
                    newRecord.set('include', false);
                    dataStore.add(newRecord);

                    var matrices = [];
                    for(var i=0; i<details.rowCount; i++) {
                        matrices.push(details.rows[i]['download_link'])
                    }
                    getGeneExpMatriceSizes(matrices);

                }, scope : this
            });
        }

        function getGeneExpMatriceSizes(matrices) {
            LABKEY.Query.selectRows({
                schemaName : 'assay.ExpressionMatrix.matrix',
                queryName : this.test?'OutputDatas2':'OutputDatas',
                filters : [LABKEY.Filter.create('data', matrices.join(';'), LABKEY.Filter.Types.IN)],
                includeTotalCount : true,
                columns : this.test?"*":"Data, Data/FileSize",
                success : function(details) {
                    var record = dataStore.getById(this.datasets["gene_expression_files"].datasetId + 'm');
                    var size, totalSize = 0;
                    for(var i=0; i<details.rowCount; i++) {
                        size = details.rows[i]["Data/FileSize"];
                        if(size.slice(-2) === "kB") {
                            totalSize += Number(size.substring(0, size.indexOf(" ")));
                        } else if(size.slice(-2) === "MB") {
                            totalSize += Number(size.substring(0, size.indexOf(" "))) * 1000;
                        } else if(size.slice(-2) === "GB") {
                            totalSize += Number(size.substring(0, size.indexOf(" "))) * 1000000;
                        }
                    }

                    record.set('fileSize', totalSize);  //kB
                    var displaySize = "< 1 kB";
                    if(totalSize.toString().length > 6)
                        displaySize = Math.round(totalSize/10000)/100 + ' GB';
                    else if(totalSize.toString().length > 3)
                        displaySize = Math.round(totalSize/10)/100 + ' MB';
                    else
                        displaySize = Math.round(totalSize * 100)/100 + ' kB';

                    record.set('fileSizeDisplay', displaySize);
                    updateSummary();
                }, scope : this
            });
        }

        // Update file and dataset summary in panel on right hand side
        function updateSummary() {
            if(dataStore) {
                var datasets = 0, rows = 0, files = 0, filesize = 0, record;
                for (var i = 0; i < dataStore.getCount(); i++) {
                    record = dataStore.getAt(i);
                    if(record.getData().include) {
                        if (isFileRecord(record)) {
                            files += record.getData(false).files;
                            filesize += Number(record.getData(false).fileSize);
                        }
                        if (isMatrixRecord(record)) {
                            files += record.getData(false).files;
                            filesize += Number(record.getData(false).fileSize);
                        }
                        else {
                            datasets++;
                            rows += record.getData().numRows;
                        }
                    }
                }

                if(filesize.toString().length > 6)
                    filesize = Math.round(filesize/10000)/100 + ' GB';
                else if(filesize.toString().length > 3)
                    filesize = Math.round(filesize/10)/100 + ' MB';
                else
                    filesize = Math.round(filesize * 100)/100 + ' kB';

                document.getElementById('summaryData').innerHTML =
                        '<div style="margin-top:4px;">Datasets: ' + datasets + '</div> ' +
                        '<div style="list-style-type:none;padding-left:1em;margin:4px;">Rows: ' + rows + '</div> ' +
                        '<div>Files: ' + files + '</div> ' +
                        '<div style="list-style-type:none;padding-left:1em;margin:4px;">Size: ' + filesize + '</div>';
            }
        }

        // Enable the download button once all requests have returned
        function enableDownloadButton()
        {
            var store = Ext4.data.StoreManager.lookup('dataSets');

            // Check that we've added the datasets to the store before checking the min numRows
            var count = store.getCount();
            if (count <= 1)
                return;

            // Check that all numRows have been returned
            var min = store.min("numRows");
            if (min == -1)
                return;

            console.debug("all data loaded");
            var btn = Ext4.getCmp("downloadBtn");
            btn.setDisabled(false);
        }

        function isFileRecord(record) {
            return (record.id.indexOf('f', record.id.length - 1) != -1);
        }

        function isMatrixRecord(record) {
            return (record.id.indexOf('m', record.id.length - 1) != -1);
        }

        function renderListOfDatasetsTable()
        {
            this.grid = Ext4.create('Ext.grid.Panel', {
                id: 'datasets',
                title: 'Datasets',
                margin: '0px 20px 0px 20px',
                store: Ext4.data.StoreManager.lookup('dataSets'),
                viewConfig: {
                    markDirty: false
                },
                columns: [
                    { xtype: 'checkcolumn', dataIndex: 'include', width: 30, showHeaderCheckbox: true, listeners: {
                        checkchange: updateSummary
                    }},
                    { header: 'Name',  dataIndex: 'label', flex: 1},
                    { header: 'Type',  dataIndex: 'type', width: 150},
                    { header: 'Rows', dataIndex: 'numRows', width:100,
                        renderer: function (v) { return v == -1 ? "<span class=loading-indicator></span>" : v; }},
                    { header: 'File Size',  dataIndex: 'fileSizeDisplay', width: 100}
                ],
                width: 850,
                loadMask: true,
                renderTo: 'datasetsPanel',
                dockedItems: [{
                    xtype: 'toolbar',
                    dock: 'bottom',
                    cls: 'labkey-main',
                    ui: 'footer',
                    defaults: {minWidth: 20},
                    items: [
                        {   xtype: 'component', flex: 1 },
                        {   xtype: 'button',
                            id: 'downloadBtn',
                            text: 'Download',
                            margin: '5 5 5 20',
                            disabled: true,
                            handler: function() {
                                var schemaQueries = {"study" : []};
                                var record, files = [], matrices = [];
                                for (var i = 0; i < dataStore.getCount(); i++) {
                                    record = dataStore.getAt(i);
                                    if(record.getData().include || record.get('name') === "StudyProperties") {
                                        if (isFileRecord(record)) {
                                            files.push(record.get('name'));
                                        }
                                        else if (isMatrixRecord(record)) {
                                            matrices.push(record.get('name'));
                                        }
                                        else {
                                            var o = { queryName : record.get('name')};

                                            if (o.queryName == "StudyProperties") {
                                                var jsonFilters = {};
                                                for(var f = 0; f<studyPropertyFilters.length; f++) {
                                                    jsonFilters[studyPropertyFilters[f].getURLParameterName()] = studyPropertyFilters[f].getURLParameterValue();
                                                }
                                                o.filters = jsonFilters;
                                            }

                                            schemaQueries.study.push(o);
                                        }
                                    }
                                }

                                window.location = LABKEY.ActionURL.buildURL('immport', 'exportTables', '<%=text(c.getPath())%>',
                                        {'schemas': JSON.stringify(schemaQueries), 'files': files, 'matrices': matrices,
                                            'headerType': 'Caption'});

                            }
                        },{
                            xtype: 'button',
                            text: 'Back',
                            handler : function(btn) {window.history.back()}
                        }
                    ]
                }]
            });

        }

        renderListOfDatasetsTable();
        getListOfDatasets();
    });

</script>
