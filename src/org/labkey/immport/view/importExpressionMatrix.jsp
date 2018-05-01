<%@ taglib prefix="labkey" uri="http://www.labkey.org/taglib" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page import="org.labkey.api.data.Container" %>
<%@ page import="org.labkey.api.data.ContainerManager" %>
<%@ page import="org.labkey.api.pipeline.PipeRoot" %>
<%@ page import="org.labkey.api.pipeline.PipelineService" %>
<%@ page import="org.labkey.api.security.permissions.AdminPermission" %>
<%@ page import="org.labkey.api.view.HttpView" %>
<%@ page import="org.labkey.immport.ImmPortController" %>
<%@ page import="java.io.File" %>
<%@ page import="static org.labkey.api.reports.RserveScriptEngine.PIPELINE_ROOT" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="org.labkey.api.util.Path" %>
<%@ page import="org.labkey.api.view.BadRequestException" %>
<%@ page import="java.nio.file.FileVisitResult" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.nio.file.attribute.BasicFileAttributes" %>
<%@ page import="java.nio.file.SimpleFileVisitor" %>
<%@ page import="java.util.Collection" %>
<%@ page import="org.apache.commons.io.FileUtils" %>
<%@ page import="org.apache.commons.io.filefilter.RegexFileFilter" %>
<%@ page import="org.apache.commons.io.filefilter.DirectoryFileFilter" %>
<%@ page import="org.apache.commons.io.filefilter.SuffixFileFilter" %>
<%@ page import="org.apache.commons.io.IOCase" %>
<%@ page extends="org.labkey.api.jsp.JspBase"%>

<labkey:errors/>

<%
    ImmPortController.ImportExpressionMatrixForm form = (ImmPortController.ImportExpressionMatrixForm)HttpView.currentModel();
    PipeRoot pipe = PipelineService.get().findPipelineRoot(getContainer(),PipelineService.PRIMARY_ROOT);
    if (null == pipe)
    {
        %>No pipeline directory found in current folder. Nothing to do.<%
        return;
    }
    File base = pipe.getRootPath();
    List<String> paths = new ArrayList<>();
    String selectedPath = null;

    // first see if there is a target on the url
    if (!StringUtils.isBlank(form.getXarPath()))
    {
        selectedPath = StringUtils.trimToEmpty(form.getXarPath());
        Path p = Path.parse(selectedPath).normalize();
        if (null == p)
            throw new BadRequestException("bad request", null);
        File selectedFile = new File(base,p.toString());
        if (selectedFile.isFile())
        {
            paths.add(selectedPath);
        }
    }
    paths.addAll(xarListing(base));

%>
    <labkey:form method="POST" action="<%=h(getViewContext().cloneActionURL().deleteParameters())%>">
<%
    Container root = ContainerManager.getRoot();
    List<Container> targets = ContainerManager.getAllChildren(root, getUser(), AdminPermission.class);
    boolean foundSelected = false;
    %><p>Xar file:&nbsp;<select name="xarPath"><%
        for (String path : paths)
        {
            boolean selectedOption = false;
            if (!foundSelected && StringUtils.equals(path,selectedPath))
                foundSelected = selectedOption = true;
            %><option <%=selected(selectedOption)%>><%=h(path)%></option><%
        }
    %></select><br>
    <input type="submit" value="Import Expression Matrix">
    </labkey:form><%
%>

<%!
    List<String> xarListing(File base)
    {
        Collection<File> files = FileUtils.listFiles(
                base,
                new SuffixFileFilter(".xar.xml", IOCase.INSENSITIVE),
                DirectoryFileFilter.DIRECTORY
        );
        ArrayList<String> ret = new ArrayList<>(files.size());
        String basePath = base.getPath() + "/";
        for (File f : files)
        {
            if (StringUtils.startsWith(f.getPath(),basePath))
                ret.add(f.getPath().substring(basePath.length()));
        }
        return ret;
    };
%>