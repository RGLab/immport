/*
 * Copyright (c) 2013-2014 LabKey Corporation
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

package org.labkey.immport;

import org.labkey.api.action.FormViewAction;
import org.labkey.api.action.RedirectAction;
import org.labkey.api.action.SimpleViewAction;
import org.labkey.api.action.SpringActionController;
import org.labkey.api.data.Container;
import org.labkey.api.data.DbSchema;
import org.labkey.api.data.DbSchemaType;
import org.labkey.api.data.DbScope;
import org.labkey.api.data.SQLFragment;
import org.labkey.api.data.SimpleFilter;
import org.labkey.api.data.SqlExecutor;
import org.labkey.api.data.SqlSelector;
import org.labkey.api.data.TableInfo;
import org.labkey.api.data.TableSelector;
import org.labkey.api.data.dialect.SqlDialect;
import org.labkey.api.gwt.client.util.StringUtils;
import org.labkey.api.pipeline.PipelineJob;
import org.labkey.api.pipeline.PipelineService;
import org.labkey.api.pipeline.PipelineUrls;
import org.labkey.api.query.DefaultSchema;
import org.labkey.api.query.FieldKey;
import org.labkey.api.query.QuerySchema;
import org.labkey.api.query.QueryService;
import org.labkey.api.security.RequiresNoPermission;
import org.labkey.api.security.RequiresPermission;
import org.labkey.api.security.RequiresSiteAdmin;
import org.labkey.api.security.permissions.AdminPermission;
import org.labkey.api.security.permissions.ReadPermission;
import org.labkey.api.util.CSRFUtil;
import org.labkey.api.util.PageFlowUtil;
import org.labkey.api.util.URLHelper;
import org.labkey.api.view.ActionURL;
import org.labkey.api.view.HtmlView;
import org.labkey.api.view.JspView;
import org.labkey.api.view.NavTree;
import org.labkey.api.view.NotFoundException;
import org.labkey.api.view.RedirectException;
import org.labkey.api.view.VBox;
import org.labkey.api.view.template.ClientDependency;
import org.labkey.api.view.template.PageConfig;
import org.labkey.immport.data.DataLoader;
import org.labkey.immport.data.StudyBean;
import org.labkey.immport.data.StudyPersonnelBean;
import org.labkey.immport.data.StudyPubmedBean;
import org.labkey.immport.view.DataFinderWebPart;
import org.labkey.immport.view.StudyIdForm;
import org.springframework.validation.BindException;
import org.springframework.validation.Errors;
import org.springframework.web.servlet.ModelAndView;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class ImmPortController extends SpringActionController
{
    @SuppressWarnings("unchecked")
    private static final DefaultActionResolver _actionResolver = new DefaultActionResolver(ImmPortController.class);

    public ImmPortController()
    {
        setActionResolver(_actionResolver);
    }

    @Override
    public PageConfig defaultPageConfig()
    {
        PageConfig config = super.defaultPageConfig();
        config.addClientDependency(ClientDependency.fromPath("Ext4"));
        config.addClientDependency(ClientDependency.fromPath("internal/jQuery"));
        return config;
    }

    @RequiresPermission(ReadPermission.class)
    public class BeginAction extends SimpleViewAction
    {
        public ModelAndView getView(Object o, BindException errors) throws Exception
        {
            return new JspView("/org/labkey/immport/view/begin.jsp");
        }

        public NavTree appendNavTrail(NavTree root)
        {
            return root;
        }
    }


    public static class CopyBean
    {
        String path;
        boolean restricted;
        public String log;

        public String getPath()
        {
            return path;
        }

        @SuppressWarnings("UnusedDeclaration")
        public void setPath(String path)
        {
            this.path = path;
        }

        public boolean isRestricted()
        {
            return restricted;
        }

        public void setRestricted(boolean restricted)
        {
            this.restricted = restricted;
        }
    }


    @RequiresPermission(AdminPermission.class)
    public class ImportArchiveAction extends FormViewAction<CopyBean>
    {
        String _log = null;

        @Override
        public void validateCommand(CopyBean target, Errors errors)
        {
        }

        @Override
        public ModelAndView getView(CopyBean form, boolean reshow, BindException errors) throws Exception
        {
            if (reshow)
            {
                form.log = _log;
            }
            return new JspView<>("/org/labkey/immport/view/importArchive.jsp", form, errors);
        }

        @Override
        public boolean handlePost(CopyBean form, BindException errors) throws Exception
        {
            if (null == form.getPath() || !new File(form.getPath()).exists())
            {
                errors.reject(ERROR_MSG, "Directory not found: " + form.getPath());
                return false;
            }
            PipelineJob j = (new DataLoader(getContainer(), getUser(), form.getPath(), form.isRestricted()));
            PipelineService.get().queueJob(j);
            return true;
        }

        @Override
        public URLHelper getSuccessURL(CopyBean o)
        {
            PipelineUrls urls = PageFlowUtil.urlProvider(PipelineUrls.class);
            if (null != urls)
                return urls.urlBegin(getContainer());
            return getContainer().getStartURL(getUser());
        }

        @Override
        public NavTree appendNavTrail(NavTree root)
        {
            return root;
        }
    }


    @RequiresPermission(AdminPermission.class)
    public class PopulateCubeAction extends FormViewAction<CopyBean>
    {
        String _log = null;

        @Override
        public void validateCommand(CopyBean target, Errors errors)
        {
        }

        @Override
        public ModelAndView getView(CopyBean form, boolean reshow, BindException errors) throws Exception
        {
            String log = "";
            String error = "";
            if (reshow)
            {
                if (errors.hasErrors())
                    error = getViewContext().getMessage(errors.getAllErrors().get(0));
                log = "<pre>" + PageFlowUtil.filter(_log, true, true) + "</pre>";
            }
            return new HtmlView("<p class='labkey-error'>" + PageFlowUtil.filter(error) + "</p>" +
                "<form name='populateCube' method='post' onsubmit='Ext4.getBody().mask();true;'>Copy from immport schema to cube dimensions<br>" +
                "<input type=hidden name='X-LABKEY-CSRF' value='" + CSRFUtil.getExpectedToken(getViewContext()) + "'>" +
                "<input type=submit></form>" +
                "<p></p>" + log);
        }

        @Override
        public boolean handlePost(CopyBean form, BindException errors) throws Exception
        {
            DbSchema schema = DbSchema.get("immport", DbSchemaType.Module);
            new SqlExecutor(schema.getScope()).execute(schema.getSqlDialect().execute(schema,"fn_populateDimensions",new SQLFragment()));
            QueryService.get().cubeDataChanged(getContainer());
            ImmPortDocumentProvider.reindex();
            return true;
        }

        @Override
        public URLHelper getSuccessURL(CopyBean o)
        {
            return null;
        }

        @Override
        public NavTree appendNavTrail(NavTree root)
        {
            return root;
        }
    }


    public static class StudyForm
    {
        String study_accession;

        public String getStudy_accession()
        {
            return study_accession;
        }

        public void setStudy_accession(String study_accession)
        {
            this.study_accession = study_accession;
        }
    }


    @RequiresNoPermission
    public static class StudyRedirectAction extends RedirectAction<StudyForm>
    {
        @Override
        public URLHelper getSuccessURL(StudyForm studyForm)
        {
            return null;
        }

        @Override
        public boolean doAction(StudyForm studyForm, BindException errors) throws Exception
        {
            return false;
        }

        @Override
        public void validateCommand(StudyForm target, Errors errors)
        {

        }
    }


    @RequiresPermission(ReadPermission.class)
    public class StudyCardAction extends SimpleViewAction<StudyIdForm>
    {
        @Override
        public ModelAndView getView(StudyIdForm form, BindException errors) throws Exception
        {
            String studyId = (null==form) ? null : form.studyId;
            if (StringUtils.isEmpty(studyId))
                throw new NotFoundException("study not specified");
            StudyBean study = (new TableSelector(DbSchema.get("immport", DbSchemaType.Module).getTable("study"))).getObject(studyId, StudyBean.class);
            if (null == study)
                throw new NotFoundException("study not found: " + form.getStudy());
            return new JspView<>("/org/labkey/immport/view/studycard.jsp", study);
        }

        @Override
        public NavTree appendNavTrail(NavTree root)
        {
            return null;
        }
    }



    public static class StudyDetails
    {
        public StudyBean study;
        public List<StudyPersonnelBean> personnel;
        public List<StudyPubmedBean> pubmed;
    }

    @RequiresPermission(ReadPermission.class)
    public class StudyDetailAction extends SimpleViewAction<StudyIdForm>
    {
        StudyIdForm _form;
        StudyDetails _study = new StudyDetails();

        @Override
        public ModelAndView getView(StudyIdForm form, BindException errors) throws Exception
        {
            _form = form;

            String studyId = (null==form) ? null : form.studyId;
            if (StringUtils.isEmpty(studyId))
                throw new NotFoundException("study not specified");

            _study.study = (new TableSelector(DbSchema.get("immport", DbSchemaType.Module).getTable("study"))).getObject(studyId, StudyBean.class);
            if (null == _study.study)
                throw new NotFoundException("study not found: " + form.getStudy());
            SimpleFilter filter = new SimpleFilter();
            filter.addCondition(new FieldKey(null,"study_accession"),studyId);
            _study.personnel = (new TableSelector(DbSchema.get("immport", DbSchemaType.Module).getTable("study_personnel"),filter,null)).getArrayList(StudyPersonnelBean.class);
            _study.pubmed = (new TableSelector(DbSchema.get("immport", DbSchemaType.Module).getTable("study_pubmed"),filter,null)).getArrayList(StudyPubmedBean.class);

            VBox v = new VBox();
            if (null != _form.getReturnActionURL())
            {
                v.addView(new HtmlView(PageFlowUtil.textLink("back",_form.getReturnActionURL()) + "<br>"));
            }
            v.addView(new JspView<>("/org/labkey/immport/view/studydetail.jsp", _study));
            return v;
        }

        @Override
        public NavTree appendNavTrail(NavTree root)
        {
            if (null == _study.study)
                return root;

            QuerySchema s = DefaultSchema.get(getUser(), getContainer()).getSchema("immport");
            TableInfo t = null==s ? null : s.getTable("study");
            ActionURL grid = null==t ? null : t.getGridURL(getContainer());

            if (null == _form.getReturnActionURL())
            {
                if (null != grid)
                {
                    root.addChild("Studies",grid);
                }
                else
                {
                    ActionURL list = new ActionURL("query","executeQuery",getContainer());
                    list.addParameter("schemaName","immport");
                    list.addParameter("query.queryName","study");
                    list.addParameter(".lastFilter", "true");
                    root.addChild("Studies", list);
                }
            }
            root.addChild(_study.study.getStudy_accession());
            return root;
        }
    }


    public static class StudiesForm
    {
        ArrayList<String> _studies = new ArrayList<>();

        public String[] getStudies()
        {
            return _studies.toArray(new String[_studies.size()]);
        }

        public List<String> getStudiesAsList()
        {
            return _studies;
        }

        public void setStudies(String[] studies)
        {
            for (String s : studies)
            {
                if (!StringUtils.isEmpty(s))
                    _studies.add(s);
            }
        }
    }


    @RequiresSiteAdmin
    public class RestrictedStudiesAction extends FormViewAction<StudiesForm>
    {
        @Override
        public void validateCommand(StudiesForm target, Errors errors)
        {
        }

        @Override
        public ModelAndView getView(StudiesForm studiesForm, boolean reshow, BindException errors) throws Exception
        {
            return new JspView<Void>("/org/labkey/immport/view/restrictedStudies.jsp",null,errors);
        }

        @Override
        public boolean handlePost(StudiesForm form, BindException errors) throws Exception
        {
            DbSchema schema = DbSchema.get("immport", DbSchemaType.Module);
            DbScope scope = schema.getScope();
            SqlDialect d = scope.getSqlDialect();

            SQLFragment update = new SQLFragment("UPDATE immport.study SET restricted=(CASE WHEN study_accession ");
            d.appendInClauseSql(update, form.getStudiesAsList());
            update.append(" THEN true ELSE false END)");

            new SqlExecutor(scope).execute(update);
            return true;
        }

        @Override
        public URLHelper getSuccessURL(StudiesForm studiesForm)
        {
            return new ActionURL(RestrictedStudiesAction.class, getContainer());
        }

        @Override
        public NavTree appendNavTrail(NavTree root)
        {
            root.addChild("ImmPort",new ActionURL(BeginAction.class, getContainer()));
            root.addChild("restricted studies",new ActionURL(RestrictedStudiesAction.class, getContainer()));
            return root;
        }
    }


    @RequiresPermission(ReadPermission.class)
    public class StudyFinderExtAction extends SimpleViewAction
    {
        public ModelAndView getView(Object o, BindException errors) throws Exception
        {
            return new JspView("/org/labkey/immport/view/studyfinderExt.jsp");
        }

        public NavTree appendNavTrail(NavTree root)
        {
            return root;
        }
    }


    @RequiresPermission(ReadPermission.class)
    public class DataFinderAction extends SimpleViewAction
    {
        public ModelAndView getView(Object o, BindException errors) throws Exception
        {
            setTitle("Data Finder");
            DataFinderWebPart wp = new DataFinderWebPart(getContainer());
            wp.setIsAutoResize(true);
            return wp;
        }

        public NavTree appendNavTrail(NavTree root)
        {
            return root;
        }
    }


    public static class FileForm
    {
        String file;

        public String getFile()
        {
            return file;
        }

        public void setFile(String fileName)
        {
            this.file = fileName;
        }
    }


    @RequiresPermission(ReadPermission.class)
    public class FindFlowFileAction extends SimpleViewAction<FileForm>
    {
        @Override
        public void validate(FileForm fileForm, BindException errors)
        {
            super.validate(fileForm, errors);
            if (StringUtils.isEmpty(fileForm.getFile()))
                errors.rejectValue("file", ERROR_REQUIRED);
        }

        private ModelAndView notFound(FileForm form, int count)
        {
            String back = PageFlowUtil.generateBackButton();

            String msg = 0==count?
                    "No flow file found (or duplicates were found) with this name: " + PageFlowUtil.filter(form.getFile()) :
                    "Duplicates were found with this name: " + PageFlowUtil.filter(form.getFile());

            return new HtmlView(msg + "<p></p>" + back);
        }

        @Override
        public ModelAndView getView(FileForm form, BindException errors) throws Exception
        {
            Container c = getContainer();
            QuerySchema ds = DefaultSchema.get(getUser(), c).getSchema("flow");
            if (null == ds)
                return notFound(form, 0);

            TableInfo fcs = ds.getTable("FCSFiles");
            SQLFragment sql = new SQLFragment("SELECT MIN(rowid) FROM ")
                    .append(fcs.getFromSQL("FCS"))
                    .append("\nWHERE name = ? AND uri IS NOT NULL")
                        .add(form.getFile())
                    .append(" AND datafileurl NOT LIKE '%/attributes.flowdata.xml'")
                    .append("\nGROUP BY {fn lcase(uri)}");
            SqlSelector sel = new SqlSelector(fcs.getSchema(),sql);
            Integer[] rowids = sel.getArray(Integer.class);
            if (1 != rowids.length)
                return notFound(form, rowids.length);

            ActionURL flow = new ActionURL("flow-well","showWell",c).addParameter("wellId", rowids[0]);
            throw new RedirectException(flow);
        }

        @Override
        public NavTree appendNavTrail(NavTree root)
        {
            return root;
        }
    }


    @RequiresSiteAdmin
    public class ReindexAction extends SimpleViewAction
    {
        @Override
        public ModelAndView getView(Object o, BindException errors) throws Exception
        {
            ImmPortDocumentProvider.reindex();
            return new HtmlView("done");
        }

        @Override
        public NavTree appendNavTrail(NavTree root)
        {
            return null;
        }
    }

    @RequiresPermission(ReadPermission.class)
    public class ExportStudyDatasetsAction extends SimpleViewAction
    {

        @Override
        public ModelAndView getView(Object o, BindException errors) throws Exception
        {
            return new JspView("/org/labkey/immport/view/exportStudyDatasets.jsp");
        }

        @Override
        public NavTree appendNavTrail(NavTree root)
        {
            return root.addChild("Data Finder", new ActionURL(DataFinderAction.class, getContainer()))
                    .addChild("Export Study Datasets");
        }
    }
}
