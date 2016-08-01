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
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page import="org.labkey.api.view.HttpView" %>
<%@ page import="org.labkey.api.view.template.ClientDependencies" %>
<%@ page import="org.labkey.immport.ImmPortController" %>
<%@ page extends="org.labkey.api.jsp.JspBase"%>
<%!
    @Override
    public void addClientDependencies(ClientDependencies dependencies)
    {
        dependencies.add("Ext4");
    }
%>
<%
    ImmPortController.CopyBean form = (ImmPortController.CopyBean)HttpView.currentModel();
    String log = StringUtils.defaultString(form.log,"");
%>

<labkey:errors/>
<labkey:form name="importArchive" method="POST" onsubmit="Ext4.getBody().mask();true;;">
Copy from mysql archive -&gt; labkey.immport<br>
<input style='width:640px;' name="path" title="Absolute path on server" value="<%=h(form.getPath())%>"><br>
<input type="checkbox" name="restricted" title="restricted">restricted<br>
<input type="submit">
</labkey:form>
<p></p>
<pre><%=h(log)%></pre>



