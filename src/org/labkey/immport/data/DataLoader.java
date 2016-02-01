/* * Copyright (c) 2013-2014 LabKey Corporation
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

package org.labkey.immport.data;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.vfs2.FileObject;
import org.apache.commons.vfs2.FileSystemException;
import org.apache.commons.vfs2.FileSystemManager;
import org.apache.commons.vfs2.FileType;
import org.apache.commons.vfs2.VFS;
import org.apache.log4j.Logger;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;
import org.labkey.api.collections.CaseInsensitiveHashMap;
import org.labkey.api.collections.CaseInsensitiveTreeSet;
import org.labkey.api.data.ColumnInfo;
import org.labkey.api.data.Container;
import org.labkey.api.data.CoreSchema;
import org.labkey.api.data.DbSchema;
import org.labkey.api.data.DbScope;
import org.labkey.api.data.JdbcType;
import org.labkey.api.data.Parameter;
import org.labkey.api.data.SQLFragment;
import org.labkey.api.data.SqlExecutor;
import org.labkey.api.data.SqlSelector;
import org.labkey.api.data.TableInfo;
import org.labkey.api.data.TableSelector;
import org.labkey.api.data.UpdateableTableInfo;
import org.labkey.api.etl.DataIterator;
import org.labkey.api.etl.DataIteratorBuilder;
import org.labkey.api.etl.DataIteratorContext;
import org.labkey.api.etl.FilterDataIterator;
import org.labkey.api.etl.Pump;
import org.labkey.api.etl.ResultSetDataIterator;
import org.labkey.api.etl.SimpleTranslator;
import org.labkey.api.etl.StandardETL;
import org.labkey.api.etl.StatementDataIterator;
import org.labkey.api.etl.WrapperDataIterator;
import org.labkey.api.exp.list.ListImportProgress;
import org.labkey.api.pipeline.CancelledException;
import org.labkey.api.pipeline.PipelineJob;
import org.labkey.api.pipeline.PipelineService;
import org.labkey.api.query.BatchValidationException;
import org.labkey.api.query.DefaultSchema;
import org.labkey.api.query.QuerySchema;
import org.labkey.api.query.QueryService;
import org.labkey.api.query.QueryUpdateService;
import org.labkey.api.query.ValidationException;
import org.labkey.api.reader.ColumnDescriptor;
import org.labkey.api.reader.TabLoader;
import org.labkey.api.security.User;
import org.labkey.api.util.DateUtil;
import org.labkey.api.util.ExceptionUtil;
import org.labkey.api.util.FileUtil;
import org.labkey.api.util.Path;
import org.labkey.api.util.URLHelper;
import org.labkey.api.view.ViewBackgroundInfo;
import org.labkey.immport.ImmPortDocumentProvider;
import org.springframework.dao.DataAccessException;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public class DataLoader extends PipelineJob
{
    static Logger _log = Logger.getLogger(DataLoader.class);

    Map<String,Map<String,String>> _lookupDictionary = new CaseInsensitiveHashMap<>();

    ArrayList<String> studyAccessions = new ArrayList<>();

    static class CopyConfig extends org.labkey.api.etl.CopyConfig
    {
        final QueryUpdateService.InsertOption option;

        CopyConfig(String sourceSchema, String source, String targetSchema, String target, QueryUpdateService.InsertOption option)
        {
            super(sourceSchema, source, targetSchema, target);
            this.option = option;
        }

        QueryUpdateService.InsertOption getInsertOption()
        {
            return option;
        }

        DataIteratorBuilder selectFromSource(DataLoader dl, DataIteratorContext context, @Nullable FileObject dir, Logger log) throws SQLException, IOException
        {
            QuerySchema sourceSchema = DefaultSchema.get(dl.getUser(), dl.getContainer(), this.getSourceSchema());
            if (null == sourceSchema)
            {
                context.getErrors().addRowError(new ValidationException("Could not find source schema: " + this.getSourceSchema()));
                return null;
            }
            String sql = getSourceQuery().startsWith("SELECT") ? getSourceQuery() : "SELECT * FROM " + getSourceQuery();
            ResultSet rs = QueryService.get().select(sourceSchema, sql);
            return new DataIteratorBuilder.Wrapper(ResultSetDataIterator.wrap(rs, context));
        }

        int copyFrom(Container c, User u, DataIteratorContext context, DataIteratorBuilder from, DataLoader dl)
                throws IOException, BatchValidationException, SQLException
        {
            assert this.getTargetSchema().getParts().size()==1;
            DbSchema targetSchema = DbSchema.get(this.getTargetSchema().getName());
            TableInfo targetTableInfo = targetSchema.getTable(getTargetQuery());

            if (context.getInsertOption() == QueryUpdateService.InsertOption.MERGE && null != targetTableInfo)
            {
                if (!(new TableSelector(targetTableInfo).exists()))
                    context.setInsertOption(QueryUpdateService.InsertOption.IMPORT);
            }

            return copy(context, from, targetTableInfo, c, u, dl);
        }

        public void deleteFromTarget(PipelineJob job, List<String> studies) throws IOException, SQLException
        {
            DbSchema targetSchema = DbSchema.get(getTargetSchema().getName());
            int rows = new SqlExecutor(targetSchema).execute("DELETE FROM " + getTargetSchema().getName() + "." + getTargetQuery());
            job.info("" + rows + " " + (rows == 1 ? "row" : "rows") + " deleted from " + getTargetQuery());
        }
    }


    // Like DataIteratorUtil.copy, but with cancel support
    static int copy(final DataIteratorContext context, DataIteratorBuilder from, TableInfo to, Container c, User user, final DataLoader dl)
            throws IOException, BatchValidationException
    {
        StandardETL etl = StandardETL.forInsert(to, from, c, user, context);
        DataIteratorBuilder insert = ((UpdateableTableInfo)to).persistRows(etl, context);
        Pump pump = new Pump(insert, context);
        pump.setProgress(new ListImportProgress()
        {
            @Override
            public void setTotalRows(int rows)
            {

            }

            @Override
            public void setCurrentRow(int currentRow)
            {
                if (dl.checkInterrupted())
                    throw new CancelledException();
            }
        });
        pump.run();
        return pump.getRowCount();
    }



    /* copy from a .zip mysql archive */

    static class ImmPortCopyConfig extends CopyConfig
    {
        // we do not delete from shared tables when in import a single study
        String file;


        ImmPortCopyConfig(String table)
        {
            super("#TEXT#", table, "immport", table, QueryUpdateService.InsertOption.IMPORT);
            file = table;
        }

        ImmPortCopyConfig(String table, QueryUpdateService.InsertOption option)
        {
            super("#TEXT#", table, "immport", table, option);
            file = table;
        }


        @Override
        DataIteratorBuilder selectFromSource(DataLoader dl, DataIteratorContext context, @Nullable FileObject dir, Logger log) throws SQLException, IOException
        {
            if (null == dir)
                return super.selectFromSource(dl,context,dir,log);

            FileObject tsvFile = null;
            FileObject loadFile = null;
            FileObject f;
            if ((f=dir.resolveFile("Tab/" + file + ".txt")).exists())
                tsvFile = f;
            else if ((f=dir.resolveFile("load/" + file + ".load")).exists())
                loadFile = f;

            ColumnDescriptor[] cols = null;
            if (null == tsvFile && null == loadFile)
            {
                context.getErrors().addRowError(new ValidationException("Could not find data file: " + file + ".txt"));
                return null;
            }

            if (null != tsvFile)
            {
                if (0 == tsvFile.getContent().getSize())
                {
                    log.warn("Data file is empty: " + file + ".txt");
                    return null;
                }
                TabLoader tl = (TabLoader)new TabLoader.TsvFactory().createLoader(tsvFile.getContent().getInputStream(), true, null);
                tl.setInferTypes(false);
                return tl;
            }
            else
            {
                try (InputStream is = loadFile.getContent().getInputStream())
                {
                    String loadConfig = IOUtils.toString(is);
                    Matcher m = Pattern.compile("\"([^\"]*)\"").matcher(loadConfig);
                    if (m.find() && !StringUtils.isEmpty(m.group(1)))
                        tsvFile = dir.resolveFile("load/" + m.group(1));
                    m = Pattern.compile("\\(([^\\)]*)\\)",Pattern.MULTILINE).matcher(loadConfig);
                    if (m.find())
                    {
                        String[] colNames = StringUtils.split(StringUtils.trim(m.group(1)),",");
                        cols = new ColumnDescriptor[colNames.length];
                        for (int i=0 ; i<colNames.length ; i++)
                            cols[i] = new ColumnDescriptor(StringUtils.trim(colNames[i]));
                    }
                    if (null == tsvFile || null == cols)
                    {
                        context.getErrors().addRowError(new ValidationException("Could not parse file: " + loadFile.toString()));
                        return null;
                    }
                    else if (!tsvFile.exists())
                    {
                        context.getErrors().addRowError(new ValidationException("Could not find data file: " + tsvFile.toString()));
                        return null;
                    }
                    if (0 == tsvFile.getContent().getSize())
                    {
                        log.warn("Data file is empty: " + tsvFile.getName());
                        return null;
                    }
                    final TabLoader tl = (TabLoader)new TabLoader.MysqlFactory().createLoader(tsvFile.getContent().getInputStream(), false, null);
                    tl.setInferTypes(false);
                    tl.setColumns(cols);
                    return tl;
                }
            }
        }
    }


    /**
     *  Tables that don't have a study_accession column
     */
    static class SharedCopyConfig extends ImmPortCopyConfig
    {
        SharedCopyConfig(String table)
        {
            super(table, QueryUpdateService.InsertOption.MERGE);
        }

        SharedCopyConfig(String table, QueryUpdateService.InsertOption option)
        {
            super(table, option);
        }

        @Override
        public void deleteFromTarget(PipelineJob job, List<String> studies) throws IOException, SQLException
        {
            assert 1==1 : "place to put breakpoint";
        }
    }


    // hand-written for postgres performance
    static abstract class CustomMergeCopyConfig extends BiosampleCopyConfig
    {
        CustomMergeCopyConfig(String table)
        {
            super(table, QueryUpdateService.InsertOption.MERGE);
        }

        // TODO don't hard code the custom queries, generate the "upsert" statement using schema meta-data
        abstract Parameter.ParameterMap getParameterMap() throws SQLException;

        @Override
        int copyFrom(Container c, User user, DataIteratorContext context, DataIteratorBuilder from, DataLoader dl) throws IOException, BatchValidationException, SQLException
        {
            assert this.getTargetSchema().getParts().size()==1;
            DbSchema targetSchema = DbSchema.get(this.getTargetSchema().getName());
            TableInfo targetTableInfo = targetSchema.getTable(getTargetQuery());

            // non-merge case
            if (context.getInsertOption() == QueryUpdateService.InsertOption.MERGE && null != targetTableInfo)
            {
                if (!(new TableSelector(targetTableInfo).exists()))
                {
                    context.setInsertOption(QueryUpdateService.InsertOption.IMPORT);
                    return super.copyFrom(c,user,context,from,dl);
                }
            }

            StandardETL etl = StandardETL.forInsert(targetTableInfo, from, c, user, context);
            //DataIteratorBuilder insert = ((UpdateableTableInfo)targetTableInfo).persistRows(etl, context);
            DataIterator insert = new _StatementDataIterator(etl.getDataIterator(context),getParameterMap(),context);
            Pump pump = new Pump(insert, context);
            pump.setProgress(new ListImportProgress()
            {
                @Override
                public void setTotalRows(int rows)
                {

                }

                @Override
                public void setCurrentRow(int currentRow)
                {
                    if (dl.checkInterrupted())
                        throw new CancelledException();
                }
            });
            pump.run();
            return pump.getRowCount();
        }
    }


    static class ExpSample2FileInfo extends CustomMergeCopyConfig
    {
        ExpSample2FileInfo(String table)
        {
            super(table);
        }

        @Override
        Parameter.ParameterMap getParameterMap() throws SQLException
        {
            DbSchema targetSchema = DbSchema.get(this.getTargetSchema().getName());
            TableInfo targetTableInfo = targetSchema.getTable(getTargetQuery());

            Parameter expsample_accession = new Parameter("expsample_accession", JdbcType.VARCHAR);
            Parameter file_info_id = new Parameter("file_info_id", JdbcType.INTEGER);
            Parameter experiment_accession = new Parameter("experiment_accession", JdbcType.VARCHAR);
            Parameter data_format = new Parameter("data_format", JdbcType.VARCHAR);
            Parameter result_schema = new Parameter("result_schema", JdbcType.VARCHAR);
            SQLFragment insert = new SQLFragment(
                "INSERT INTO immport.expsample_2_file_info (expsample_accession, file_info_id, experiment_accession, data_format, result_schema)\n" +
                "SELECT ?, ?, ?, ?, ?\n",
                expsample_accession, file_info_id, experiment_accession, data_format, result_schema);
            SQLFragment update = new SQLFragment("UPDATE immport.expsample_2_file_info SET expsample_accession=?, file_info_id=?, experiment_accession=?, data_format=?, result_schema=?\n" +
                "WHERE expsample_accession=? AND file_info_id=?\n",
                expsample_accession, file_info_id, experiment_accession, data_format, result_schema, expsample_accession, file_info_id);
            SQLFragment sqlf = new SQLFragment();
            sqlf.append("WITH __upsert__ AS (").append(update).append(" RETURNING *) ").append(insert).append(" WHERE NOT EXISTS (SELECT * FROM __upsert__)");
            return new Parameter.ParameterMap(targetSchema.getScope(), sqlf, (Map<String,String>)null);
        }
    }

    static class ExpSample2Reagent extends CustomMergeCopyConfig
    {
        ExpSample2Reagent(String table)
        {
            super(table);
        }

        @Override
        Parameter.ParameterMap getParameterMap() throws SQLException
        {
            DbSchema targetSchema = DbSchema.get(this.getTargetSchema().getName());
            TableInfo targetTableInfo = targetSchema.getTable(getTargetQuery());

            Parameter expsample_accession = new Parameter("expsample_accession", JdbcType.VARCHAR);
            Parameter reagent_accession = new Parameter("reagent_accession", JdbcType.VARCHAR);
            Parameter experiment_accession = new Parameter("experiment_accession", JdbcType.VARCHAR);
            SQLFragment insert = new SQLFragment(
                    "INSERT INTO immport.expsample_2_file_info (expsample_accession, reagent_accession, experiment_accession)\n" +
                            "SELECT ?, ?, ?\n",
                    expsample_accession, reagent_accession, experiment_accession);
            SQLFragment update = new SQLFragment("UPDATE immport.expsample_2_file_info SET expsample_accession=?, reagent_accession=?, experiment_accession=?\n" +
                    "WHERE expsample_accession=? AND reagent_accession=?\n",
                    expsample_accession, reagent_accession, experiment_accession, expsample_accession, reagent_accession);
            SQLFragment sqlf = new SQLFragment();
            sqlf.append("WITH __upsert__ AS (").append(update).append(" RETURNING *) ").append(insert).append(" WHERE NOT EXISTS (SELECT * FROM __upsert__)");
            return new Parameter.ParameterMap(targetSchema.getScope(), sqlf, (Map<String,String>)null);
        }
    }

    static class ExpSample2Treatment extends CustomMergeCopyConfig
    {
        ExpSample2Treatment(String table)
        {
            super(table);
        }

        @Override
        Parameter.ParameterMap getParameterMap() throws SQLException
        {
            DbSchema targetSchema = DbSchema.get(this.getTargetSchema().getName());
            TableInfo targetTableInfo = targetSchema.getTable(getTargetQuery());

            Parameter expsample_accession = new Parameter("expsample_accession", JdbcType.VARCHAR);
            Parameter treatment_accession = new Parameter("treatment_accession", JdbcType.VARCHAR);
            Parameter experiment_accession = new Parameter("experiment_accession", JdbcType.VARCHAR);
            SQLFragment insert = new SQLFragment(
                    "INSERT INTO immport.expsample_2_file_info (expsample_accession, treatment_accession, experiment_accession)\n" +
                            "SELECT ?, ?, ?\n",
                    expsample_accession, treatment_accession, experiment_accession);
            SQLFragment update = new SQLFragment("UPDATE immport.expsample_2_file_info SET expsample_accession=?, treatment_accession=?, experiment_accession=?\n" +
                    "WHERE expsample_accession=? AND treatment_accession=?\n",
                    expsample_accession, treatment_accession, experiment_accession, expsample_accession, treatment_accession);
            SQLFragment sqlf = new SQLFragment();
            sqlf.append("WITH __upsert__ AS (").append(update).append(" RETURNING *) ").append(insert).append(" WHERE NOT EXISTS (SELECT * FROM __upsert__)");
            return new Parameter.ParameterMap(targetSchema.getScope(), sqlf, (Map<String,String>)null);
        }
    }

    static class _StatementDataIterator extends StatementDataIterator
    {
        _StatementDataIterator(DataIterator data, @Nullable Parameter.ParameterMap map, DataIteratorContext context)
        {
            super(data,map,context);
        }
    }


    /**
     * Small one or two column tables (name) or (name,description)
     * Can use in-memory filtering to avoid merge
     */
    static class LookupCopyConfig extends SharedCopyConfig
    {
        LookupCopyConfig(String table)
        {
            // we don't need to merge, because we're filtering in memory
            super(table, QueryUpdateService.InsertOption.IMPORT);
        }

        @Override
        DataIteratorBuilder selectFromSource(DataLoader dl, DataIteratorContext context, @Nullable FileObject dir, Logger log) throws SQLException, IOException
        {
            // select existing names
            DbSchema targetSchema = DbSchema.get(getTargetSchema().getName());
            final ArrayList<String> names = new SqlSelector(targetSchema, "SELECT Name FROM " + getTargetSchema().getName() + "." + getTargetQuery()).getArrayList(String.class);
            final DataIteratorBuilder select = super.selectFromSource(dl,context,dir,log);
            if (names.isEmpty())
                return select;
            return new LookupInsertFilter(select, names);
        }
    }


    /**
     * Tables that have a study_accession column
     */
    static class StudyCopyConfig extends ImmPortCopyConfig
    {
        StudyCopyConfig(String table)
        {
            super(table);
        }

        @Override
        public void deleteFromTarget(PipelineJob job, List<String> studies) throws IOException, SQLException
        {
            DbSchema targetSchema = DbSchema.get(getTargetSchema().getName());

            SQLFragment deleteSql = new SQLFragment();
            deleteSql.append(
                "DELETE FROM " + getTargetSchema().getName() + "." + getTargetQuery() + "\n" +
                    "WHERE study_accession ");
            targetSchema.getSqlDialect().appendInClauseSql(deleteSql,studies);

            int rows = new SqlExecutor(targetSchema).execute(deleteSql);
            job.info("" + rows + " " + (rows == 1 ? "row" : "rows") + " deleted from " + getTargetQuery());
        }

        @Override
        DataIteratorBuilder selectFromSource(DataLoader dl, DataIteratorContext context, @Nullable FileObject dir, Logger log) throws SQLException, IOException
        {
            final DataIteratorBuilder select = super.selectFromSource(dl,context,dir,log);
            final boolean restricted = dl._restricted;

            if (null == select)
                return null;
            if (!"study".equals(file))
                return select;

            // OK wrapp the data iterator with a wrapper, that adds the "restricted" column;
            DataIteratorBuilder dib;
            dib = new DataIteratorBuilder()
            {
                @Override
                public DataIterator getDataIterator(DataIteratorContext context)
                {
                    DataIterator in = select.getDataIterator(context);
                    SimpleTranslator out = new SimpleTranslator(in, context);
                    out.selectAll();
                    out.addConstantColumn("restricted", JdbcType.BOOLEAN, restricted);
                    return out;
                }
            };
            return dib;
        }
    }


    /* get study by joining to biosample.biosample_accession */
    static class BiosampleCopyConfig extends ImmPortCopyConfig
    {
        BiosampleCopyConfig(String table)
        {
            super(table);
        }

        BiosampleCopyConfig(String table, QueryUpdateService.InsertOption option)
        {
            super(table, option);
        }

        @Override
        DataIteratorBuilder selectFromSource(DataLoader dl, DataIteratorContext context, @Nullable FileObject dir, Logger log) throws SQLException, IOException
        {
            return super.selectFromSource(dl, context, dir, log);
        }

        @Override
        public void deleteFromTarget(PipelineJob job, List<String> studies) throws IOException, SQLException
        {
            DbSchema targetSchema = DbSchema.get(getTargetSchema().getName());
            TableInfo targetTableInfo = targetSchema.getTable(getTargetQuery());

            SQLFragment deleteSql = new SQLFragment();

            if (null != targetTableInfo.getColumn("biosample_accession"))
            {
                deleteSql.append(
                        "DELETE FROM " + getTargetSchema().getName() + "." + getTargetQuery() + "\n" +
                                "WHERE biosample_accession IN (SELECT biosample_accession FROM " + getTargetSchema().getName() + ".biosample WHERE study_accession ");
                targetSchema.getSqlDialect().appendInClauseSql(deleteSql, studies);
                deleteSql.append(")");
            }
            else if (null != targetTableInfo.getColumn("expsample_accession"))
            {
                deleteSql.append(
                        "DELETE FROM " + getTargetSchema().getName() + "." + getTargetQuery() + "\n" +
                        "WHERE expsample_accession IN \n" +
                        "  (SELECT biosample_2_expsample.expsample_accession FROM " + getTargetSchema().getName() + ".biosample \n" +
                        "    INNER JOIN " + getTargetSchema().getName() + ".biosample_2_expsample ON biosample.biosample_accession=biosample_2_expsample.biosample_accession\n" +
                        "    WHERE biosample.study_accession ");
                targetSchema.getSqlDialect().appendInClauseSql(deleteSql, studies);
                deleteSql.append(")");
            }
            else
            {
                throw new IllegalStateException("could not find biosample_accession or expsample_accession");
            }

            int rows = new SqlExecutor(targetSchema).execute(deleteSql);
            job.info("" + rows + " " + (rows == 1 ? "row" : "rows") + " deleted from " + getTargetQuery());
        }
    }

    /* get study by joining to arm.arm_accession.biosample_accession */
    static class ArmCopyConfig extends ImmPortCopyConfig
    {
        ArmCopyConfig(String table)
        {
            super(table);
        }

        @Override
        public void deleteFromTarget(PipelineJob job, List<String> studies) throws IOException, SQLException
        {
            DbSchema targetSchema = DbSchema.get(getTargetSchema().getName());

            SQLFragment deleteSql = new SQLFragment();
            deleteSql.append(
                    "DELETE FROM " + getTargetSchema().getName() + "." + getTargetQuery() + "\n" +
                            "WHERE arm_accession IN (SELECT arm_accession FROM " + getTargetSchema().getName() + ".arm_or_cohort WHERE study_accession ");
            targetSchema.getSqlDialect().appendInClauseSql(deleteSql, studies);
            deleteSql.append(")");

            int rows = new SqlExecutor(targetSchema).execute(deleteSql);
            job.info("" + rows + " " + (rows == 1 ? "row" : "rows") + " deleted from " + getTargetQuery());
        }
    }

    static CopyConfig[] immportTables = new CopyConfig[]
    {
            // lookup tables
        new SharedCopyConfig("lk_adverse_event_severity"),
        new SharedCopyConfig("lk_age_event"),
        new LookupCopyConfig("lk_allele_status"),
        new SharedCopyConfig("lk_data_completeness"),
        new LookupCopyConfig("lk_data_format"),
        new LookupCopyConfig("lk_ethnicity"),
        new LookupCopyConfig("lk_exon_intron_interrogated"),
        new SharedCopyConfig("lk_exp_measurement_tech"),
        new LookupCopyConfig("lk_expsample_result_schema"),
        new LookupCopyConfig("lk_experiment_purpose"),
        new LookupCopyConfig("lk_feature_location"),
        new LookupCopyConfig("lk_feature_sequence_type"),
        new LookupCopyConfig("lk_feature_strand"),
        new LookupCopyConfig("lk_feature_type"),
        new LookupCopyConfig("lk_file_detail"),
        new LookupCopyConfig("lk_file_purpose"),
        new SharedCopyConfig("lk_gender"),
        new LookupCopyConfig("lk_locus_name"),
        new LookupCopyConfig("lk_locus_typing_method"),
        new LookupCopyConfig("lk_personnel_role"),
        new SharedCopyConfig("lk_plate_type"),
        new LookupCopyConfig("lk_protocol_type"),
        new SharedCopyConfig("lk_public_repository"),
        new LookupCopyConfig("lk_race"),
        new SharedCopyConfig("lk_reagent_type"),
        new LookupCopyConfig("lk_reason_not_completed"),
        new LookupCopyConfig("lk_research_focus"),
        new SharedCopyConfig("lk_sample_type"),
        new SharedCopyConfig("lk_source_type"),
        new SharedCopyConfig("lk_species"),
        new SharedCopyConfig("lk_study_file_type"),
        new SharedCopyConfig("lk_study_panel"),
        new LookupCopyConfig("lk_study_type"),
        new SharedCopyConfig("lk_t0_event"),
        new SharedCopyConfig("lk_time_unit"),
        new SharedCopyConfig("lk_unit_of_measure"),

            // high-level tables
        new SharedCopyConfig("workspace"),
        new StudyCopyConfig("study"),
        new SharedCopyConfig("subject"),
        new StudyCopyConfig("period"),
        new StudyCopyConfig("planned_visit"),
        new StudyCopyConfig("actual_visit"),
        new StudyCopyConfig("arm_or_cohort"),
        new StudyCopyConfig("biosample"),
        new SharedCopyConfig("experiment"),
        new SharedCopyConfig("expsample"),
        new SharedCopyConfig("file_info"),
        new SharedCopyConfig("protocol"),
        new SharedCopyConfig("reagent"),
        new SharedCopyConfig("treatment"),
        new StudyCopyConfig("adverse_event"),
        new StudyCopyConfig("assessment"),
        new SharedCopyConfig("control_sample"),
        new SharedCopyConfig("expsample_mbaa_detail"),
        new SharedCopyConfig("expsample_public_repository"),
        new SharedCopyConfig("hla_allele_status"),
        new SharedCopyConfig("hla_typing_sys_feature"),
        new SharedCopyConfig("hla_typing_system"),
        new SharedCopyConfig("inclusion_exclusion"),
        new SharedCopyConfig("kir_typing_system"),
        new StudyCopyConfig("reference_range"),
        new StudyCopyConfig("lab_test"),
        new StudyCopyConfig("protocol_deviation"),
        new StudyCopyConfig("reported_early_termination"),
        new SharedCopyConfig("standard_curve"),
        new StudyCopyConfig("study_categorization"),
        new StudyCopyConfig("study_file"),
        new StudyCopyConfig("study_glossary"),
        new StudyCopyConfig("study_image"),
        new StudyCopyConfig("study_link"),
        new StudyCopyConfig("study_personnel"),
        new StudyCopyConfig("study_pubmed"),
        new StudyCopyConfig("subject_measure_definition"),
        new StudyCopyConfig("substance_merge"),
        new SharedCopyConfig("contract_grant"),
        new SharedCopyConfig("program"),

        new SharedCopyConfig("fcs_annotation"),
        new SharedCopyConfig("fcs_analyzed_result_marker"),
        new SharedCopyConfig("fcs_header_marker"),
        new SharedCopyConfig("fcs_header"),

            // results
        new StudyCopyConfig("elisa_result"),
        new StudyCopyConfig("elispot_result"),
        new StudyCopyConfig("hai_result"),
        new StudyCopyConfig("fcs_analyzed_result"),
        new StudyCopyConfig("hla_typing_result"),
        new StudyCopyConfig("kir_typing_result"),
        new StudyCopyConfig("mbaa_result"),
        new StudyCopyConfig("neut_ab_titer_result"),
        new StudyCopyConfig("pcr_result"),
        new StudyCopyConfig("subject_measure_result"),

            // junction tables
        new ArmCopyConfig("arm_2_subject"),
        new BiosampleCopyConfig("biosample_2_expsample"),
        new BiosampleCopyConfig("biosample_2_protocol"),
        new BiosampleCopyConfig("biosample_2_treatment"),
        new SharedCopyConfig("experiment_2_protocol"),
        new ExpSample2FileInfo("expsample_2_file_info"),
        new ExpSample2Reagent("expsample_2_reagent"),
        new StudyCopyConfig("study_2_protocol"),
        new SharedCopyConfig("subject_2_protocol"),
        new SharedCopyConfig("control_sample_2_file_info"),
        new ExpSample2Treatment("expsample_2_treatment"),
        new ArmCopyConfig("planned_visit_2_arm"),
        new SharedCopyConfig("reagent_2_fcs_marker"),
        new SharedCopyConfig("standard_curve_2_file_info"),
        new StudyCopyConfig("study_2_panel"),
        new SharedCopyConfig("reagent_set_2_reagent"),

        // this is basically a materialized view, database->database copy
        new CopyConfig("immport", "q_subject_2_study", "immport", "subject_2_study", QueryUpdateService.InsertOption.IMPORT)
    };


    /**
     * load from external schema attached as "hipc"
     * to the immport schema
     **/
    public void loadFromArchive()
    {
        try
        {
            FileSystemManager fsManager = VFS.getManager();
            FileObject archiveFile;
            if (new File(_archive).isDirectory())
                archiveFile = fsManager.resolveFile(new File(_archive).getAbsoluteFile().toURI().toString());
            else if (new File(_archive).isFile() && _archive.endsWith(".zip"))
                archiveFile = fsManager.resolveFile("zip://" + new File(_archive).getAbsolutePath());
            else
                throw new FileNotFoundException(_archive);

            // DR16 added a top level directory to the archive.  Check for that here.
            // find directories
            Map<String,FileObject> dirs = (Arrays.asList(archiveFile.getChildren())).stream().filter(fo ->
                {
                    try
                    {
                        return fo.getType() == FileType.FOLDER;
                    }
                    catch (FileSystemException fse)
                    {
                        return false;
                    }
                })
            .filter(fo -> !fo.getName().getBaseName().startsWith("."))
            .collect(Collectors.toMap(fo -> fo.getName().getBaseName(), fo -> fo));

            if (!dirs.containsKey("MySQL") && dirs.size()==1)
                archiveFile = dirs.values().iterator().next();

            execute(immportTables, archiveFile);
        }
        catch (IOException|SQLException x)
        {
            error("Unexpected exception", x);
        }
    }


    /** CONSIDER : drop indexes and constraints and add them back for performance */

    public boolean executeCopy(CopyConfig config, @Nullable FileObject dir) throws IOException, SQLException
    {
        DbSchema targetSchema = DbSchema.get(config.getTargetSchema().getName());

        DataIteratorContext context = new DataIteratorContext();
        context.setInsertOption(config.getInsertOption());
        context.setFailFast(true);

        assert !targetSchema.getScope().isTransactionActive();
        try (DbScope.Transaction tx = targetSchema.getScope().ensureTransaction())
        {
            long start = System.currentTimeMillis();
            DataIteratorBuilder source = config.selectFromSource(this, context, dir, getLogger());
            if (null != source)
            {
                if (null == dir)
                {
                    info("Copying data from " + config.getSourceSchema() + "." + config.getSourceQuery() + " to " +
                            config.getTargetSchema() + "." + config.getTargetQuery());
                }
                else
                {
                    info("Copying data from " + dir.toString() + " to " +
                            config.getTargetSchema() + "." + config.getTargetQuery());
                }

                if (config instanceof ImmPortCopyConfig)
                {
                    if (((ImmPortCopyConfig)config).file.startsWith("lk_"))
                    {

                        CaseInsensitiveHashMap<String> values = new CaseInsensitiveHashMap<>();
                        _lookupDictionary.put(((ImmPortCopyConfig)config).file,values);
                        source = new CollectLookups(source,values);
                    }
                    else if (((ImmPortCopyConfig)config).file.equals("experiment"))
                    {
                        source = new FixLookups(source,"purpose",_lookupDictionary.get("lk_experiment_purpose"));
                    }
                }

                int count = config.copyFrom(getContainer(), getUser(), context, source, this);

                tx.commit();

                long finish = System.currentTimeMillis();
                if (!context.getErrors().hasErrors())
                    info("Copied " + count + " row" + (count != 1 ? "s" : "") + " in " + DateUtil.formatDuration(finish - start) + ".");
            }
        }
        catch (BatchValidationException x)
        {
            assert x == context.getErrors();
            /* fall through */
        }
        catch (Exception x)
        {
            error(null==x.getMessage()?x.toString():x.getMessage());
            return false;
        }
        finally
        {
            assert !targetSchema.getScope().isTransactionActive();
        }
        if (context.getErrors().hasErrors())
        {
            for (ValidationException v : context.getErrors().getRowErrors())
            {
                String msg = v.getMessage();
                error(msg);
            }
            return false;
        }
        return true;
    }


    public void execute(CopyConfig[] configs, @Nullable FileObject dir) throws IOException, SQLException
    {
        Set<String> setStudyAccession = new TreeSet<>();

        Exception preException = null;
        try
        {
            // find study accession numbers
            DataIteratorContext dix = new DataIteratorContext();
            DataIteratorBuilder dib = new StudyCopyConfig("study").selectFromSource(this,dix,dir,getLogger());
            if (dix.getErrors().hasErrors())
                throw dix.getErrors();

            if (null != dib)
            {
                DataIterator it = dib.getDataIterator(dix);
                while (it.next())
                {
                    String sdy = (String) it.get(1);
                    setStudyAccession.add(sdy);
                }
            }
        }
        catch (BatchValidationException bve)
        {
            bve.getRowErrors().stream().forEach(ve->error(ve.getMessage()));
        }
        catch (Exception x)
        {
            preException = x;
            setStudyAccession.clear();
        }

        if (setStudyAccession.size() == 0)
        {
            error("Could not load study accession numbers", preException);
            return;
        }

        info("Archive contains " + setStudyAccession.size() +" "+(setStudyAccession.size()==1?"study":"studies"));

        studyAccessions.addAll(setStudyAccession);


        ArrayList<CopyConfig> reverse = new ArrayList<>(Arrays.asList(configs));
        Collections.reverse(reverse);

        for (CopyConfig config : reverse)
        {
            if (checkInterrupted())
            {
                throw new CancelledException();
            }
            try
            {
                setStatus(TaskStatus.running, "DELETE from " + config.getTargetQuery());
                config.deleteFromTarget(this,studyAccessions);
            }
            catch (SQLException | DataAccessException x)
            {
                error("deleting from " + config.getTargetQuery() + "\n\t" + x.getMessage(), x);
            }
        }

        for (CopyConfig config : configs)
        {
            if (checkInterrupted())
                throw new CancelledException();
            try
            {
                setStatus(TaskStatus.running, "COPY to " + config.getTargetQuery());
                executeCopy(config, dir);
            }
            catch (SQLException | DataAccessException x)
            {
                error("copying to " + config.getTargetQuery() + "\n\t" + x.getMessage(), x);
            }
        }
        setStatus(TaskStatus.running, "DONE copying");
    }


    @Override
    public boolean setStatus(@NotNull TaskStatus status, @Nullable String info)
    {
        DbSchema p = DbSchema.get("pipeline");
        assert !p.getScope().isTransactionActive();

        return super.setStatus(status, info);
    }


    // DataIterator Helpers

    static class CollectLookups implements DataIteratorBuilder
    {
        DataIteratorBuilder _source;
        Map<String,String> _values;

        CollectLookups(DataIteratorBuilder source, Map<String,String> map)
        {
            _source = source;
            _values = map;
        }

        @Override
        public DataIterator getDataIterator(DataIteratorContext context)
        {
            return new WrapperDataIterator(_source.getDataIterator(context))
            {
                @Override
                public Object get(int i)
                {
                    Object o = _delegate.get(i);
                    if (1==i && o instanceof String)
                        _values.put((String)o, (String)o);
                    return o;
                }
            };
        }
    }


    static class FixLookups implements DataIteratorBuilder
    {
        DataIteratorBuilder _source;
        String fk;
        int indexFK=-1;
        Map<String,String> _values;

        FixLookups(DataIteratorBuilder source, String colname, Map<String,String> map)
        {
            _source = source;
            fk = colname;
            _values = map;
        }

        @Override
        public DataIterator getDataIterator(DataIteratorContext context)
        {
            DataIterator di = _source.getDataIterator(context);
            if (null == di)
                return null;
            if (null != fk && null != _values && !_values.isEmpty())
            {
                for (int i=1 ; i<=di.getColumnCount() ; i++)
                    if (di.getColumnInfo(i).getName().equalsIgnoreCase(fk))
                        indexFK = i;
            }

            return new WrapperDataIterator(_source.getDataIterator(context))
            {
                @Override
                public Object get(int i)
                {
                    Object o = _delegate.get(i);
                    if (i==indexFK && o instanceof String)
                        return StringUtils.defaultString(_values.get(o),(String)o);
                    return o;
                }
            };
        }
    }


    static class LookupInsertFilter implements DataIteratorBuilder
    {
        DataIteratorBuilder in;
        Set<String> existingNames = new CaseInsensitiveTreeSet();

        LookupInsertFilter(DataIteratorBuilder in, Collection<String> names)
        {
            this.in = in;
            this.existingNames.addAll(names);
        }

        @Override
        public DataIterator getDataIterator(DataIteratorContext context)
        {
            DataIterator it = in.getDataIterator(context);
            int index = 0;
            for (int i=1 ; i<=it.getColumnCount() ; i++)
            {
                ColumnInfo col = it.getColumnInfo(i);
                if ("name".equalsIgnoreCase(col.getName()))
                    index = i;
            }
            if (0 == index)
            {
                context.getErrors().addRowError(new ValidationException("Could not find field called 'name'"));
            }
            final int nameField = index;
            return new FilterDataIterator(it)
            {
                protected boolean accept()
                {
                    String name = (String)get(nameField);
                    return !existingNames.contains(name);
                }
            };
        }
    }



    //
    // PipelineJob
    //


    final String _archive;
    final boolean _restricted;

    public DataLoader(Container container, User user, String archive, boolean restricted)
    {
        super("ImmPort", new ViewBackgroundInfo(container, user, null), PipelineService.get().getPipelineRootSetting(container));
        _archive = archive;
        _restricted = restricted;
        setLogFile(new File(new File(archive).getParentFile(), FileUtil.makeFileNameWithTimestamp("import", "log")));
    }

    @Override
    public URLHelper getStatusHref()
    {
        return null;
    }

    @Override
    public String getDescription()
    {
        if (null != _archive)
        {
            Path p = Path.parse(_archive);
            return "Load ImmPort archive " + p.getName();
        }
        return "Load ImmPort archive";
    }

    @Override
    public void setLogFile(File fileLog)
    {
        super.setLogFile(fileLog);
    }


    @Override
    public void run()
    {
        try
        {
            _run();
        }
        catch (CancelledException e)
        {
            setStatus(TaskStatus.cancelled);
        }
        catch (RuntimeException|Error e)
        {
            setStatus(TaskStatus.error);
            ExceptionUtil.logExceptionToMothership(null, e);
            // Rethrow to let the standard Mule exception handler fire and deal with the job state
            throw e;
        }
    }


    public void _run()
    {
        if (checkInterrupted())
            throw new CancelledException();
        setStatus(TaskStatus.running, "Starting import");
        loadFromArchive();
        if (checkInterrupted())
            throw new CancelledException();
        if (CoreSchema.getInstance().getSqlDialect().isPostgreSQL())
        {
            try
            {
                setStatus(TaskStatus.running, "VACUUM ANALYZE");
                info("running VACUUM ANALYZE");
                new SqlExecutor(CoreSchema.getInstance().getScope()).execute("VACUUM ANALYZE");
            }
            catch (Exception x)
            {
                warn(x.getMessage());
            }
        }
        setStatus(TaskStatus.running, "Adding studies to full text index");
        ImmPortDocumentProvider.reindex();
        if (checkInterrupted())
            throw new CancelledException();
        info("COMPLETE");
        setStatus(PipelineJob.TaskStatus.complete, "Complete");
    }
}

