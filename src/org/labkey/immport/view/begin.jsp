<%
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
%>
<%@ page import="org.labkey.api.data.Container" %>
<%@ page import="org.labkey.api.view.ActionURL" %>
<%@ page import="org.labkey.immport.ImmPortController" %>
<%@ page extends="org.labkey.api.jsp.JspBase" %>
<%
    Container c = getContainer();
    ActionURL exportSpecimens = (new ActionURL("query","exportRowsXLSX",c))
            .addParameter("schemaName","immport")
            .addParameter("query.queryName","q_simple_specimens")
            .addParameter("query.showRows","ALL");
    ActionURL importSpecimens = (new ActionURL("study-samples","showUploadSpecimens",c));
%>
<h3>Data loading</h3>

<p>
<b>To load new ImmPort archive</b><br>
<%=link("Import Archive", new ActionURL(ImmPortController.ImportArchiveAction.class, c))%><br>
<%=link("Populate cube", new ActionURL(ImmPortController.PopulateCubeAction.class, c))%><br>
<%=link("Data Finder", new ActionURL(ImmPortController.DataFinderAction.class, c))%><br>
<%=link("Public/Restricted Studies", new ActionURL(ImmPortController.RestrictedStudiesAction.class, c))%><br>
</p>
<p>
<b>Load or refresh data in a new study</b><br>
<%=link("Copy datasets for one study in this folder", new ActionURL("immport", "copyImmPortStudy", c))%><br>
</p>
<p>
<b>Reload all data (should be executed from the /Studies container):</b><br>
<%=link("Copy datasets for multiple child studies", new ActionURL("immport", "reimportStudies", c))%><br>
<%--
<p>
To create a gender subject_groups<br>
<%=textLink("Create gender subject groups", new ActionURL("immport", "createSubjectGroup", c))%>
</p>
<p>
<%=textLink("Download Specimens",exportSpecimens)%>&nbsp;&nbsp;<%=textLink("Upload Specimens",importSpecimens)%>
--%>
</p>
<h3>Post loading tasks</h3>
  <%=link("Hide empty datasets", new ActionURL("study", "datasetVisibility", c))%><br>
  <%=link("Highligh study", new ActionURL("study", "manageStudyProperties", c))%><br>
  <%=link("Update modules", new ActionURL("admin", "folderType", c).addParameter("tabId", "folderType"))%><br>
</p>

<h3>Expression Matrix publish/import</h3>
  <%=link("Export selected expression matrices", new ActionURL(ImmPortController.PublishExpressionMatrixAction.class, c))%><br>
  <%=link("Import published expression matrices", new ActionURL(ImmPortController.ImportExpressionMatrixAction.class, c))%><br>
