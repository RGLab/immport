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
<%@ page import="org.labkey.api.view.template.ClientDependencies" %>
<%@ page extends="org.labkey.api.jsp.JspBase"%>
<%!
    public void addClientDependencies(ClientDependencies dependencies)
    {
        dependencies.add("clientapi/ext4");
        dependencies.add("immport/renderExport.js");
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
        renderExport();
    });

</script>
