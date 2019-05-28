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
<%@ page import="org.labkey.immport.data.StudyBean" %>
<%@ page import="org.labkey.api.view.HttpView" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page extends="org.labkey.api.jsp.OldJspBase"%>
<%
StudyBean study = (StudyBean)HttpView.currentModel();
String descriptionHTML;
if (!StringUtils.isEmpty(study.getDescription()))
    descriptionHTML= study.getDescription();
else
    descriptionHTML = h(study.getBrief_description());
%>
<div id="immport_study_card_<%=h(study.getStudy_accession())%>" style="padding:5pt;">
<%=h(study.getStudy_accession())%> - <%=h(study.getOfficial_title())%>
</div>