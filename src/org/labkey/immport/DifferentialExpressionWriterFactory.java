package org.labkey.immport;

import org.apache.commons.lang3.StringUtils;
import org.jetbrains.annotations.Nullable;
import org.labkey.api.admin.AbstractFolderContext;
import org.labkey.api.admin.FolderWriter;
import org.labkey.api.admin.FolderWriterFactory;
import org.labkey.api.admin.ImportContext;
import org.labkey.api.data.ColumnHeaderType;
import org.labkey.api.data.ColumnInfo;
import org.labkey.api.data.Container;
import org.labkey.api.data.ContainerFilter;
import org.labkey.api.data.ContainerFilterable;
import org.labkey.api.data.Results;
import org.labkey.api.data.TSVGridWriter;
import org.labkey.api.data.TSVWriter;
import org.labkey.api.data.TableInfo;
import org.labkey.api.data.TableSelector;
import org.labkey.api.query.DefaultSchema;
import org.labkey.api.query.QuerySchema;
import org.labkey.api.security.User;
import org.labkey.api.study.DataspaceContainerFilter;
import org.labkey.api.study.Study;
import org.labkey.api.study.StudyService;
import org.labkey.api.writer.VirtualFile;
import org.labkey.api.writer.Writer;
import org.labkey.folder.xml.FolderDocument;

import java.io.PrintWriter;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;


public class DifferentialExpressionWriterFactory implements FolderWriterFactory
{
    public static String MODULE_NAME = "DifferentialExpressionAnalysis";
    public static String SCHEMA_NAME = "gene_expression";
    public static String DATA_TYPE = "Differential Expression data";
    public static String DIRECTORY_NAME = "hipc_DifferentialExpression";


    @Override
    public FolderWriter create()
    {
        return new _FolderWriter();
    }


    class _FolderWriter implements FolderWriter
    {
        _FolderWriter()
        {
        }

        @Override
        public @Nullable Collection<Writer> getChildren(boolean sort, boolean forTemplate)
        {
            return null;
        }

        @Override
        public boolean show(Container c)
        {
            QuerySchema schema = DefaultSchema.get(User.getSearchUser(), c).getSchema(SCHEMA_NAME);
            return null != schema;
        }

        @Override
        public boolean selectedByDefault(AbstractFolderContext.ExportType type)
        {
            return true;
        }

        @Override
        public void initialize(ImportContext<FolderDocument.Folder> context)
        {

        }

        @Override
        public boolean includeWithTemplate()
        {
            return false;
        }

        @Nullable
        @Override
        public String getDataType()
        {
            return DATA_TYPE;
        }

        @Override
        public void write(Container object, ImportContext<FolderDocument.Folder> ctx, VirtualFile root) throws Exception
        {
            VirtualFile outputDir = root.getDir(DIRECTORY_NAME);
            Container c = ctx.getContainer();
            User user = ctx.getUser();
            StudyService ss = StudyService.get();
            Study s = null==ss ? null : ss.getStudy(c);
            ContainerFilter cf = ContainerFilter.CURRENT;
            if (null != s && s.isDataspaceStudy())
                cf = new DataspaceContainerFilter(user, s);

            QuerySchema schema = DefaultSchema.get(user, c).getSchema(SCHEMA_NAME);
            if (null == schema)
                return;

            for (String tableName : Arrays.asList("gene_expression_analysis", "gene_expression_analysis_results"))
            {
                TableInfo t = schema.getTable("gene_expression_analysis");
                // we want all columns except "container", and "key" SERIAL
                List<ColumnInfo> cols = t.getColumns().stream()
                        .filter(col -> !StringUtils.equalsIgnoreCase(col.getName(), "container") &&
                                !StringUtils.equalsIgnoreCase(col.getName(), "key"))
                        .collect(Collectors.toList());
                ((ContainerFilterable)t).setContainerFilter(cf);
                try (Results r = new TableSelector(t, cols, null, null).getResults())
                {
                    TSVGridWriter tsv = new TSVGridWriter(r);
                    tsv.setDelimiterCharacter(TSVWriter.DELIM.TAB);
                    tsv.setQuoteCharacter(TSVWriter.QUOTE.DOUBLE);
                    tsv.setColumnHeaderType(ColumnHeaderType.Name);
                    PrintWriter out = outputDir.getPrintWriter(tableName + ".tsv");
                    tsv.write(out);
                }
            }
        }
    }
}
