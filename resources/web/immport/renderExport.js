function renderExport(){

    var datasets = {};
    var filesMap = {
        'fcs_control_files':        'control_file',
        'fcs_sample_files':         'file_info_name',
        'gene_expression_files':    'file_info_name'
    };

    var excludedTables = { 'HM_InputSamplesQuerySnapshot': true };

    var studyFilterWebPart = LABKEY.WebPart({
        partName: 'Shared Study Filter',
        renderTo: 'studyFilter',
        frame: 'none'
    });
    studyFilterWebPart.render();

    var dataStore = Ext4.create('Ext.data.Store', {
        storeId:'dataSets',
        fields:[ 'id', 'name', 'include', 'label', 'type', 'numRows', 'fileSize', 'files', 'final' ],
        data: { 'items': [] },
        sorters: [{
            sorterFn: function(o1, o2){

                var type1 = o1.get('type');
                var type2 = o2.get('type');
                var sortOrder = 0;

                if (type1 !== type2) {
                    if(type1 === 'Dataset (TSV)') {
                        sortOrder = -1;
                    }
                    else {
                        sortOrder = 1;
                    }
                }
                else {
                    var label1 = o1.get('label');
                    var label2 = o2.get('label');

                    if (label1 < label2) {
                        sortOrder = -1;
                    }
                    else if (label1 > label2) {
                        sortOrder = 1;
                    }
                }
                return sortOrder;
            }
        }],
        proxy: {
            type: 'memory',
            reader: {
                type: 'json',
                root: 'items'
            }
        }
    });

    function getListOfDatasets(){
        LABKEY.Query.selectRows({
            schemaName : 'study',
            queryName : 'Datasets',
            containerPath : LABKEY.container.path,
            success : function (details) {
                var rows = details.rows;

                for ( var i = 0; i < rows.length; i ++ ){
                    if ( ! excludedTables.hasOwnProperty( rows[i].Name ) ){
                        dataStore.add({
                            id: rows[i].DataSetId,
                            name: rows[i].Name,
                            label: rows[i].Label,
                            type: -1,
                            numRows: -1,
                            fileSize: -1,
                            final: false
                        });

                        getNumOfRows( rows[i].Name, rows[i].DataSetId );
                    }
                }
            }, scope : this
        });
    }

    function getNumOfRows( queryName, datasetId )
    {
        var sql = "SELECT COUNT(*) as rowcount FROM " + queryName + "\n";

        LABKEY.Query.executeSql({
            schemaName : 'study',
            sql : sql,
            success : function ( details )
            {
                var record = dataStore.getById( datasetId );

                if ( details.rows.length > 0 && details.rows[0].rowcount > 0)
                {
                    record.set( 'include', true );
                    record.set( 'type', 'Dataset (TSV)' );
                    record.set( 'numRows', details.rows[0].rowcount );
                    record.set( 'fileSize', -2 );
                    record.set( 'final', true );

                    // Right now these are hard coded
                    if ( filesMap[ queryName ] ){
                        datasets[ queryName ] = details;
                        datasets[ queryName ].datasetId = datasetId;
                        getFileData( queryName );
                    }
                }
                else {  // Remove records with zero rows
                    dataStore.remove( record );
                }

                updateSummary();
                enableDownloadButton();
            },
            failure : function (response, opts)
            {
                LABKEY.Utils.displayAjaxErrorResponse(response, opts);
            },
            scope : this
        });
    }

    // Get file data for file datasets
    function getFileData( ds ){
        if ( datasets[ ds ] )
        {

            var fileCol = filesMap[ ds ];

            var sql =
                    'SELECT COUNT(filename) AS filecount, SUM(filesize) AS filesize ' +
                    ' FROM (' +
                        'SELECT ' + fileCol + ' as filename, CAST(MAX(IFDEFINED(filesize)) AS INTEGER) as filesize' +
                        ' FROM study.' + ds +
                        ' GROUP BY ' + fileCol +
                    ') as _';

            LABKEY.Query.executeSql(
            {
                schemaName: 'study',
                sql: sql,
                success: function( details ){ fileHandler.call( this, details, ds); },
                failure : function(){/*swallow failure*/},
                scope: this
            });

            var record = dataStore.getById( datasets[ ds ].datasetId );
            dataStore.add({
                id: record.get( 'id' ) + 'f',
                name: record.get( 'name' ),
                label: record.get( 'label' ),
                type: -1,
                numRows: -1,
                fileSize: -1,
                final: false
            });
        }
    }

    function fileHandler( details, ds )
    {
        var dataset = datasets[ ds ];
        if ( typeof dataset.fileSize == 'undefined' )
            dataset.fileSize = 0;

        if ( typeof dataset.files == 'undefined' )
            dataset.files = 0;

        for ( var i = 0; i < details.rows.length ; i ++ )
        {
            if ( details.rows[i].filesize )
                dataset.fileSize += Math.round( details.rows[i].filesize );
            if ( details.rows[i].filecount )
                dataset.files += details.rows[i].filecount;
        }

        var record = dataStore.getById( datasets[ ds ].datasetId + 'f' );
        record.set( 'include', false );
        record.set( 'type', 'File' );
        record.set( 'numRows', '' );
        record.set( 'fileSize', datasets[ds].fileSize );
        record.set( 'files', datasets[ds].files );
        record.set( 'final', true );

        if ( ds == 'gene_expression_files' ){
            getGeneExpMatrices();
        } else {
            updateSummary();
            enableDownloadButton();
        }
    }

    function getGeneExpMatrices(){
        var record = dataStore.getById( datasets[ 'gene_expression_files' ].datasetId );
        dataStore.add({
            include: true,
            id: record.get( 'id' ) + 'm',
            name: record.get( 'name' ),
            label: 'Gene expression matrices',
            type: -1,
            numRows: -1,
            fileSize: -1,
            final: false
        });

        LABKEY.Query.selectRows({
            schemaName : 'assay.ExpressionMatrix.matrix',
            queryName : 'SelectedRuns',
            includeTotalCount : true,
            success : function( details ){
                var matrices = [];
                for ( var i = 0; i < details.rowCount; i ++ ){
                    matrices.push( details.rows[ i ][ 'download_link' ]);
                }
                getGeneExpMatricesSizes( matrices );
            },
            failure : function(){
                var recordF = dataStore.getById( datasets[ 'gene_expression_files' ].datasetId + 'f' );
                var recordM = dataStore.getById( datasets[ 'gene_expression_files' ].datasetId + 'm' );
                dataStore.remove([ recordF, recordM ]);
            },
            scope : this
        });
    }

    function getGeneExpMatricesSizes( matrices ){
        LABKEY.Query.selectRows({
            schemaName : 'assay.ExpressionMatrix.matrix',
            queryName : 'OutputDatas',
            filters : [ LABKEY.Filter.create('data', matrices.join(';'), LABKEY.Filter.Types.IN) ],
            includeTotalCount : true,
            columns : 'Data, Data/FileSize',
            success : function( details ){
                var record = dataStore.getById( datasets[ 'gene_expression_files' ].datasetId + 'm' );

                var size, totalSize = 0;
                for ( var i = 0; i < details.rows.length; i ++ ){
                    size = details.rows[ i ][ 'Data/FileSize' ];
                    if ( size.slice( -2 ) === 'kB' ){
                        totalSize += Number( size.substring( 0, size.indexOf(' ') ) ) * 1000;
                    } else if ( size.slice( -2 ) === 'MB' ){
                        totalSize += Number( size.substring( 0, size.indexOf(' ') ) ) * 1000000;
                    } else if ( size.slice( -2 ) === 'GB' ){
                        totalSize += Number( size.substring( 0, size.indexOf(' ') ) ) * 1000000000;
                    }
                }

                record.set( 'type', 'File' );
                record.set( 'numRows', '' );
                record.set( 'fileSize', totalSize );  // bytes
                record.set( 'files', details.rows.length );
                record.set( 'final', true );

                updateSummary();
                enableDownloadButton();
            }, scope : this
        });
    }

    var taskUpdateSummary = new Ext4.util.DelayedTask(_updateSummary);

    function updateSummary()
    {
        taskUpdateSummary.delay(100);
    }

    // Update file and dataset summary in panel on right hand side
    function _updateSummary(){
        if ( dataStore && document.getElementById( 'summaryData' ) ){
            var totalFiles = 0, filesize = 0, data;
            for ( var i = 0; i < dataStore.getCount(); i ++ ){
                data = dataStore.getAt( i ).getData();
                if ( data.include && data.final ){
                    if (
                        (   identifyDataType( data, 'f' ) ||
                            identifyDataType( data, 'm' )
                        ) &&
                        data.fileSize >= 0
                    ){
                        totalFiles += data.files;
                        filesize += Number( data.fileSize );
                    }
                }
            }
            document.getElementById( 'summaryData' ).innerHTML =
                '<div>Files number: ' + totalFiles + '</div> ' +
                '<div>Files size: ' + Ext4.util.Format.fileSize( filesize ) + '</div>';
        }
    }

    // Enable the download button once all requests have returned
    function enableDownloadButton(){
        var store = Ext4.data.StoreManager.lookup('dataSets');

        // Check that we've added the datasets to the store before checking the min numRows
        var count = store.getCount();
        if ( count <= 1 )
            return;

        // Check that all numRows have been returned
        var min = store.min( 'final' );
        if ( min == false )
            return;

        var btn = Ext4.getCmp( 'downloadBtn' );
        btn.setDisabled( false );
    }

    function identifyDataType( data, idChar ){
        var id = data.id.toString();
        return ( id.indexOf( idChar, id.length - 1 ) != -1 );
    }

    /* This is an extension to allow the "Select All" checkbox in the header */
    Ext4.define('Ext.ux.CheckColumnPatch', {
        extend: 'Ext.ux.CheckColumn',
        alias: 'widget.checkcolumnpatch',

        /**
        * @cfg {Boolean} [columnHeaderCheckbox=false]
        * True to enable check/uncheck all rows
        */
        columnHeaderCheckbox: false,

        constructor: function (config) {
            var me = this;
            me.callParent(arguments);

            me.addEvents('beforecheckallchange', 'checkallchange');

            if (me.columnHeaderCheckbox) {
                me.on('headerclick', function () {
                    this.updateAllRecords();
                }, me);

                me.on('render', function (comp) {
                    var grid = comp.up('grid');
                    this.mon(grid, 'reconfigure', function () {
                        if (this.isVisible()) {
                            this.bindStore();
                        }
                    }, this);

                    if (this.isVisible()) {
                        this.bindStore();
                    }

                    this.on('show', function () {
                        this.bindStore();
                    });
                    this.on('hide', function () {
                        this.unbindStore();
                    });
                }, me);
            }
        },

        onStoreDataUpdate: function () {
            updateSummary();

            if (!this.updatingAll) {
                var allChecked = this.getStoreIsAllChecked();
                if (allChecked !== this.allChecked) {
                    this.allChecked = allChecked;
                    var image = this.getHeaderCheckboxImage(allChecked);
                    this.setText(image);
                }
            }
        },

        getStoreIsAllChecked: function () {
            var me = this,
                allChecked = true;
            me.store.each(function (record) {
                if (!record.get(this.dataIndex)) {
                    allChecked = false;
                    return false;
                }
            }, me);
            return allChecked;
        },

        bindStore: function () {
            var me = this,
                grid = me.up('grid'),
                store = grid.getStore();

            me.store = store;

            me.mon(store, 'datachanged', function () {
                this.onStoreDataUpdate();
            }, me);
            me.mon(store, 'update', function () {
                this.onStoreDataUpdate();
            }, me);

            me.onStoreDataUpdate();
        },

        unbindStore: function () {
            var me = this,
                store = me.store;

            me.mun(store, 'datachanged');
            me.mun(store, 'update');
        },

        updateAllRecords: function () {
            var me = this,
                allChecked = !me.allChecked;

            if (me.fireEvent('beforecheckallchange', me, allChecked) !== false) {
                this.updatingAll = true;
                me.store.suspendEvents();
                me.store.each(function (record) {
                    record.set(this.dataIndex, allChecked);
                }, me);
                me.store.resumeEvents();
                me.up('grid').getView().refresh();
                this.updatingAll = false;
                this.onStoreDataUpdate();
                me.fireEvent('checkallchange', me, allChecked);
            }
        },

        getHeaderCheckboxImage: function (allChecked) {
            return this.renderer(allChecked);
        }
    });

    function renderListOfDatasetsTable(){
        this.grid = Ext4.create('Ext.grid.Panel', {
            columnLines: true,
            columns: [
                {
                    columnHeaderCheckbox: true,
                    dataIndex: 'include',
                    hideable: false,
                    menuDisabled: true,
                    resizable: false,
                    sortable: false,
                    width: 30,
                    xtype: 'checkcolumnpatch'
                },{
                    dataIndex: 'label',
                    flex: 1,
                    header: 'Name',
                    hideable: false
                },{
                    dataIndex: 'type',
                    header: 'Type',
                    renderer: function ( v ){ return v == -1 ? '<span class=loading-indicator></span>' : v; },
                    width: 150
                },{
                    align: 'right',
                    dataIndex: 'numRows',
                    header: 'Rows',
                    renderer: function ( v ){ return v == -1 ? '<span class=loading-indicator></span>' : v; },
                    width: 100
                },{
                    align: 'right',
                    dataIndex: 'fileSize',
                    header: 'File Size',
                    renderer: function ( v ){
                        return v == -1 ? '<span class=loading-indicator></span>' : v == -2 ? '' : Ext4.util.Format.fileSize( v );
                    },
                    width: 100
                }
            ],
            dockedItems: [{
                xtype: 'toolbar',
                dock: 'bottom',
                cls: 'labkey-main',
                ui: 'footer',
                defaults: { minWidth: 20 },
                items: [
                    {   xtype: 'component', flex: 1 },
                    {   xtype: 'button',
                        id: 'downloadBtn',
                        text: 'Download',
                        margin: '5 5 5 20',
                        disabled: true,
                        handler: function (){
                            var schemaQueries = { 'study' : [] };
                            var record, data, downloadFiles = [], matrices = [];
                            for ( var i = 0; i < dataStore.getCount(); i ++ ){
                                record = dataStore.getAt( i );
                                data = record.getData();
                                if ( data.include ){
                                    if ( identifyDataType( data, 'f' ) ){
                                        downloadFiles.push( record.get('name') );
                                    }
                                    else if ( identifyDataType( data, 'm' ) ){
                                        matrices.push( record.get( 'name' ) );
                                    }
                                    else {
                                        schemaQueries.study.push( { queryName : record.get( 'name' ) } );
                                    }
                                }
                            }

                            window.location = LABKEY.ActionURL.buildURL(
                                'immport',
                                'exportTables',
                                LABKEY.container.path,
                                {
                                    'schemas': JSON.stringify( schemaQueries ),
                                    'files': downloadFiles,
                                    'matrices': matrices,
                                    'headerType': 'Caption'
                                }
                            );

                        }
                    },{
                        xtype: 'button',
                        text: 'Back',
                        handler : function() {window.history.back()}
                    }
                ]
            }],
            id: 'datasets',
            loadMask: true,
            margin: '0px 20px 0px 20px',
            renderTo: 'datasetsPanel',
            store: Ext4.data.StoreManager.lookup( 'dataSets' ),
            stripeRows: true,
            title: 'Datasets',
            viewConfig: {
                markDirty: false
            },
            width: 850
        });

    }

    renderListOfDatasetsTable();
    getListOfDatasets();
}