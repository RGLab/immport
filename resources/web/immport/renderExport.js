function renderExport()
{

    var studies = [];
    var datasets = {};
    var queryPrefix = "ds_";
    var filesMap = {
        'fcs_control_files': 'control_file',
        'fcs_sample_files': 'file_info_name',
        'gene_expression_files': 'file_info_name'
    };

    var excludedTables = {'HM_InputSamplesQuerySnapshot':true};

    // Only include "SDY" studies in the StudyProperties query
    var studyPropertyFilters = [
        LABKEY.Filter.create( 'Label', 'SDY', LABKEY.Filter.Types.STARTS_WITH ),
        LABKEY.Filter.create( 'Label', 'SDY_template', LABKEY.Filter.Types.NEQ )
    ];

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

        dataStore.add({
            id: -1,
            name: 'StudyProperties',
            label: 'Studies',
            type: -1,
            numRows: -1,
            fileSize: -1,
            final: false
        });
        getNumOfRows( 'StudyProperties', -1 );
    };

    function getNumOfRows( queryName, datasetId ){
        var filters = [];
        if ( queryName == 'StudyProperties' ){
            filters = studyPropertyFilters;
        }

        LABKEY.Query.selectRows({
            schemaName : 'study',
            queryName : queryName,
            includeTotalCount : true,
            showRows : 0,
            filterArray: filters,
            success : function ( details ){
                var record = dataStore.getById( datasetId );
                var qn = details.queryName;

                if ( details.rowCount > 0 ){
                    record.set( 'include', true );
                    record.set( 'type', 'Dataset (TSV)' );
                    record.set( 'numRows', details.rowCount );
                    record.set( 'fileSize', -2 );
                    record.set( 'final', true );

                    // Gets studies
                    if ( qn === 'StudyProperties' ){
                        Ext4.each( details.rows, function( row ){ studies.push(row.Label); }, this );
                    }

                    // Right now these are hard coded
                        if ( filesMap[ qn ] ){
                            datasets[ qn ] = details;
                            datasets[ qn ].datasetId = datasetId;
                            getFileData( qn );
                        }
                }
                else {  // Remove records with zero rows
                    dataStore.remove( record );
                }

                updateSummary();
                enableDownloadButton();
            }, scope : this
        });
    };

    // Get file data for file datasets
    function getFileData( ds ){
        if ( datasets[ ds ] ){
            var multi = new LABKEY.MultiRequest();

            for ( var i = 0; i < studies.length; i ++ ){

                var fileCol = filesMap[ ds ];

                multi.add( LABKEY.Query.executeSql, {
                    schemaName: 'study',
                    sql: 'SELECT DISTINCT i.filesize, s.' + fileCol + ' as filename FROM study.' + ds + ' s ' +
                    'JOIN immport.' + queryPrefix + ds + ' i ON i.' + fileCol + ' = s.' + fileCol,
                    sort: "filesize",
                    parameters: {
                        $STUDY: studies[ i ]
                    },
                    success: function( details ){ fileHandler.call( this, details, ds); },
                    failure : function(){/*swallow failure*/},
                    scope: this
                });
            }

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

            multi.send( function(){ afterFiles(ds); }, this );
        }
    };

    function fileHandler( details, ds ){
        var dataset = datasets[ ds ];
        if ( typeof dataset.fileSize == 'undefined' )
            dataset.fileSize = 0;

        if ( typeof dataset.files == 'undefined' )
            dataset.files = 0;

        for ( var i = 0; i < details.rowCount; i++ ){
            dataset.fileSize += Math.round( details.rows[i].filesize );
            dataset.files++;
        }
    };

    // Now that we have all the file data, add it up and add records for it
    function afterFiles( ds ){
        if ( datasets[ds].fileSize ){
            var record = dataStore.getById( datasets[ ds ].datasetId + 'f' );
            record.set( 'include', false );
            record.set( 'type', 'File' );
            record.set( 'numRows', '' );
            record.set( 'fileSize', datasets[ds].fileSize );
            record.set( 'files', datasets[ds].files );
            record.set( 'final', true );
        }

        if ( ds == 'gene_expression_files' ){
            getGeneExpMatrices();
        } else {
            updateSummary();
            enableDownloadButton();
        }
    };

    function getGeneExpMatrices(){
        LABKEY.Query.selectRows({
            schemaName : 'assay.ExpressionMatrix.matrix',
            queryName : 'SelectedRuns',
            includeTotalCount : true,
            success : function(details) {
                var record = dataStore.getById( datasets[ 'gene_expression_files' ].datasetId );
                var newRecord = record.copy(datasets[ 'gene_expression_files' ].datasetId + 'm' );
                newRecord.set( 'include', false );
                newRecord.set( 'label', 'Gene expression microarray matrices' );
                newRecord.set( 'type', -1 );
                newRecord.set( 'numRows', -1 );
                newRecord.set( 'fileSize', -1 );
                newRecord.set( 'files', details.rowCount );
                dataStore.add( newRecord );

                var matrices = [];
                for ( var i = 0; i < details.rowCount; i ++ ){
                    matrices.push( details.rows[ i ][ 'download_link' ]);
                }
                getGeneExpMatricesSizes( matrices );
            },
            failure : function(){/*swallow failure*/},
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
                for ( var i = 0; i < details.rowCount; i ++ ){
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
                record.set( 'final', true );

                updateSummary();
                enableDownloadButton();
            }, scope : this
        });
    }

    // Update file and dataset summary in panel on right hand side
    function updateSummary(){
        if ( dataStore && document.getElementById( 'summaryData' ) ){
            var totalFiles = 0, filesize = 0, record;
            for ( var i = 0; i < dataStore.getCount(); i ++ ){
                record = dataStore.getAt( i );
                if ( record.getData().include ){
                    if ( isFileRecord( record ) ){
                        totalFiles += record.getData( false ).files;
                        filesize += Number( record.getData( false ).fileSize );
                    }
                    if ( isMatrixRecord( record ) ){
                        totalFiles += record.getData( false ).files;
                        filesize += Number( record.getData( false ).fileSize );
                    }
                }
            }
            document.getElementById( 'summaryData' ).innerHTML =
                '<div>Files number: ' + totalFiles + '</div> ' +
                '<div>Files size: ' + Ext4.util.Format.fileSize( filesize ) + '</div>';
        }
    };

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
    };

    function isFileRecord( record ){
        return ( record.id.indexOf( 'f', record.id.length - 1) != -1 );
    };

    function isMatrixRecord( record ){
        return ( record.id.indexOf( 'm', record.id.length - 1 ) != -1 );
    };

    Ext4.define('Ext.ux.CheckColumnPatch', {
        override: 'Ext.ux.CheckColumn',

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
            var allChecked,
                image;

            if (!this.updatingAll) {
                allChecked = this.getStoreIsAllChecked();
                if (allChecked !== this.allChecked) {
                    this.allChecked = allChecked;
                    image = this.getHeaderCheckboxImage(allChecked);
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
            return '<img class="x4-grid-checkcolumn ' + ( allChecked ? 'x4-grid-checkcolumn-checked' : '' ) + '">';
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
                    listeners: { checkchange: updateSummary },
                    menuDisabled: true,
                    resizable: false,
                    sortable: false,
                    width: 30,
                    xtype: 'checkcolumn'
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
                            var record, downloadFiles = [], matrices = [];
                            for ( var i = 0; i < dataStore.getCount(); i ++ ){
                                record = dataStore.getAt( i );
                                if ( record.getData().include || record.get( 'name' ) === 'StudyProperties' ){
                                    if ( isFileRecord( record ) ){
                                        downloadFiles.push( record.get('name') );
                                    }
                                    else if ( isMatrixRecord( record ) ){
                                        matrices.push( record.get( 'name' ) );
                                    }
                                    else {
                                        var o = { queryName : record.get( 'name' ) };

                                        if ( o.queryName == 'StudyProperties' ){
                                            var jsonFilters = {};
                                            for ( var f = 0; f < studyPropertyFilters.length; f ++ ){
                                                jsonFilters[ studyPropertyFilters[f].getURLParameterName() ] = studyPropertyFilters[ f ].getURLParameterValue();
                                            }
                                            o.filters = jsonFilters;
                                        }

                                        schemaQueries.study.push( o );
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
                        handler : function(btn) {window.history.back()}
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
            width: 850,
        });

    };

    renderListOfDatasetsTable();
    getListOfDatasets();
};

