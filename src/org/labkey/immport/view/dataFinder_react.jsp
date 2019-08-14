<%
    /*
     * Copyright (c) 2014-2015 LabKey Corporation
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
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page import="org.labkey.api.data.Container" %>
<%@ page import="org.labkey.api.data.ContainerFilter" %>
<%@ page import="org.labkey.api.data.ContainerManager" %>
<%@ page import="org.labkey.api.data.DbSchema" %>
<%@ page import="org.labkey.api.data.DbSchemaType" %>
<%@ page import="org.labkey.api.data.SqlSelector" %>
<%@ page import="org.labkey.api.data.TableInfo" %>
<%@ page import="org.labkey.api.data.TableSelector" %>
<%@ page import="org.labkey.api.query.DefaultSchema" %>
<%@ page import="org.labkey.api.query.QuerySchema" %>
<%@ page import="org.labkey.api.util.HeartBeat" %>
<%@ page import="org.labkey.api.view.ActionURL" %>
<%@ page import="org.labkey.api.view.HttpView" %>
<%@ page import="org.labkey.api.view.ViewContext" %>
<%@ page import="org.labkey.api.view.template.ClientDependencies" %>
<%@ page import="org.labkey.immport.data.StudyBean" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collection" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.TreeMap" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page extends="org.labkey.api.jsp.JspBase"%>
<%!
    @Override
    public void addClientDependencies(ClientDependencies dependencies)
    {
        dependencies.add("internal/jQuery");
        dependencies.add("Ext4");               // TODO still used for popup window
        dependencies.add("clientapi/ext4");     // TODO
        dependencies.add("query/olap.js");
        dependencies.add("core/SQL.js");

        dependencies.add("dataFinder.css");
        dependencies.add("immport/ParticipantGroup.js");
        dependencies.add("immport/hipc.css");
        dependencies.add("immport/react.js");
        dependencies.add("immport/react-dom.js");
        dependencies.add("immport/dataFinder_react.js");
    }
%>
<%
    ViewContext context = HttpView.currentContext();
    assert null != context;
    // CONSIDER: add this to fn_populateDimensions (maybe just add additional program_id column to dimStudy)
    ArrayList<StudyBean> studies = new SqlSelector(DbSchema.get("immport", DbSchemaType.Module),
            "SELECT study.*, P.name as program_title, pi.pi_names\n" +
            "FROM immport.study " +
//            "LEFT OUTER JOIN immport.contract_grant_2_study CG2S ON study.study_accession = CG2S.study_accession\n" +
            "LEFT OUTER JOIN (SELECT study_accession, MIN(contract_grant_id) as contract_grant_id FROM immport.contract_grant_2_study GROUP BY study_accession) CG2S ON study.study_accession = CG2S.study_accession\n" +
            "LEFT OUTER JOIN immport.contract_grant C ON CG2S.contract_grant_id = C.contract_grant_id\n" +
            "LEFT OUTER JOIN immport.program P on C.program_id = P.program_id\n" +
            "LEFT OUTER JOIN\n" +
            "\t(\n" +
            "\tSELECT study_accession, array_to_string(array_agg(first_name || ' ' || last_name),', ') as pi_names\n" +
            "\tFROM immport.study_personnel\n" +
            "\tWHERE role_in_study ilike '%principal%'\n" +
            "\tGROUP BY study_accession) pi ON study.study_accession = pi.study_accession\n").getArrayList(StudyBean.class);

    Collections.sort(studies, (o1, o2) -> {
        String a = o1.getStudy_accession();
        String b = o2.getStudy_accession();
        return Integer.parseInt(a.substring(3)) - Integer.parseInt(b.substring(3));
    });

    Map<String,StudyBean> mapOfStudies = new TreeMap<>();
    for (StudyBean sb : studies)
        mapOfStudies.put(sb.getStudy_accession(), sb);
%>

<div id="dataFinderWrapper" class="labkey-data-finder-outer">
<div id="dataFinderApp" class="labkey-data-finder-inner" ng-app="dataFinderApp" ng-controller="dataFinder">
<div id="studyPopup"></div>
</div>
</div>


<%--
			controller
 --%>
<%-- N.B. This is not robust enough to have two finder web parts on the same page --%>

<%!
    String isTrue(Object o)
    {
        if (null == o)
            return "false";
        if (o instanceof Boolean)
            return o == Boolean.TRUE ? "true" : "false";
        if (o instanceof Number)
            return ((Number) o).intValue() == 0 ? "false" : "true";
        return "false";
    }
%>
<script src='<%=getContextPath()%>/clientapi/core/SQL.js'></script>
<script type="text/javascript">

var $=$||jQuery;


    //
    // INITIALIZE STUDY DATA
    // INITIALIZE STUDY DATA
    //

<%--    var studyData = [<%
    String comma = "\n  ";
    for (StudyBean study : studies)
    {
        %><%=text(comma)%>[<%=q(study.getStudy_accession())%>,<%=text(study.getStudy_accession().substring(3))%>,<%=q(StringUtils.defaultString(study.getBrief_title(),study.getOfficial_title()))%>,<%=q(study.getPi_names())%>,<%=text(study.getRestricted()?"true":"false")%>]<%
        comma = ",\n  ";
    }
%>];

    var loaded_studies = {
    <%
    Container c = context.getContainer();
    if (!c.isRoot())
    {
        Pattern sdyPattern = Pattern.compile("(SDY\\d+).*");

        comma = "\n";
        Container p = c.getProject();
        QuerySchema s = DefaultSchema.get(context.getUser(), p).getSchema("study");
        TableInfo sp = s.getTable("StudyProperties", new ContainerFilter.AllInProject(context.getUser()));
        Collection<Map<String, Object>> maps = new TableSelector(sp).getMapCollection();

        long now = HeartBeat.currentTimeMillis();

        for (Map<String, Object> map : maps)
        {
            Container studyContainer = ContainerManager.getForId((String)map.get("container"));
            if (null == studyContainer)
                continue;
            ActionURL url = studyContainer.getStartURL(context.getUser());

            String study_accession = null;
            String name = StringUtils.defaultIfBlank((String)map.get("Label"),studyContainer.getName());
            if (null != name)
            {
                Matcher m = sdyPattern.matcher(name);
                if (m.matches())
                    study_accession = m.group(1);
            }
            Date until = (Date)map.get("highlight_until");
            boolean highlight = null != until && until.getTime() > now;
            if (null != study_accession)
            {
                if (StringUtils.endsWithIgnoreCase(study_accession," Study"))
                    study_accession = study_accession.substring(0,study_accession.length()-6).trim();
                StudyBean bean = mapOfStudies.get(study_accession);
                if (null == bean)
                {
                    continue;
                }
                %><%=text(comma)%><%=q(study_accession)%>:{<%
                %>name:<%=q(study_accession)%>,<%
                %>uniqueName:<%=q("[Study].["+study_accession+"]")%>, <%
                %>hipc_funded:<%=text(isTrue(StringUtils.contains(bean.getProgram_title(),"HIPC")))%>,<%
                %>highlight:<%=text(highlight?"true":"false")%>,<%
                %>containerId:<%=q((String)map.get("container"))%>, url:<%=q(url.getLocalURIString())%>}<%
               comma = ",\n";
           }
       }
   }%>
    };
    var studies = [];
    var loaded_study_list = [];
    var recent_study_list = [];
    var hipc_study_list = [];
    var unloaded_study_list = [];
    for (var i = 0; i < studyData.length; i++)
    {
        var name = studyData[i][0];
        var s =
        {
            'memberName': "[Study].[" + name + "]",
            'study_accession': name,
            'id': studyData[i][1], 'title': studyData[i][2], 'pi': studyData[i][3], 'restricted': studyData[i][4],
            'hipc_funded': false,
            'loaded': false,
            'url': null,
            'containerId': null
        };
        if (loaded_studies[name])
        {
            s.loaded = true;
            s.hipc_funded = loaded_studies[name].hipc_funded;
            s.highlight = loaded_studies[name].highlight;
            s.url = loaded_studies[name].url;
            s.containerId = loaded_studies[name].containerId;
            loaded_study_list.push(s.memberName);
            if (s.highlight)
                recent_study_list.push(s.memberName);
            if (s.hipc_funded)
                hipc_study_list.push(s.memberName);
        }
        else if (!s.restricted)
        {
            unloaded_study_list.push(s.memberName);
        }
        studies.push(s);
    }
--%>
    //
    // INITIALIZE DIMENSIONS
    //

    var dimensions =
    {
        "Study":
        {
            name: 'Study', pluralName: 'Studies', hierarchyName: 'Study', levelName: 'Name', allMemberName: '[Study].[(All)]', popup: true,
                filterType: "OR", filterOptions: [{type: "OR", caption: "is any of"}]
        },
        "Condition":
        {
            name: 'Condition', hierarchyName: 'Study.Conditions', levelName: 'Condition', allMemberName: '[Study.Conditions].[(All)]',
                filterType: "OR", filterOptions: [{type: "OR", caption: "is any of"}]
        },
        "Assay":
        {
            name: 'Assay', hierarchyName: 'Assay', levelName: 'Assay', allMemberName: '[Assay].[(All)]',
                filterType: "AND", filterOptions: [{type: "OR", caption: "data for any of these"}, { type: "AND", caption: "data for all of these"}]
        },
        "Type":
        {
            name: 'Type', hierarchyName: 'Study.Type', levelName: 'Type', allMemberName: '[Study.Type].[(All)]',
                filterType: "OR", filterOptions: [{type: "OR", caption: "is any of"}]
        },
        "Category":
        {
            caption: 'Research focus', name: 'Category', hierarchyName: 'Study.Category', levelName: 'Category', allMemberName: '[Study.Category].[(All)]',
                filterType: "OR", filterOptions: [{type: "OR", caption: "is any of"}]
        },
        "Timepoint":
        {
            caption: 'Day of Study', name: 'Timepoint', hierarchyName: 'Timepoint.Timepoints', levelName: 'Timepoint', allMemberName: '[Timepoint.Timepoints].[(All)]',
                filterType: "AND", filterOptions: [{type: "OR", caption: "has data for any of"}, { type: "AND", caption: "has data for all of"}]
        },
        "Race":
        {
            name: 'Race', hierarchyName: 'Subject.Race', levelName: 'Race', allMemberName: '[Subject.Race].[(All)]',
                filterType: "OR", filterOptions: [{type: "OR", caption: "is any of"}]
        },
        "Age":
        {
            name: 'Age', hierarchyName: 'Subject.Age', levelName: 'Age', allMemberName: '[Subject.Age].[(All)]',
                filterType: "OR", filterOptions: [{type: "OR", caption: "is any of"}]
        },
        "Gender":
        {
            name: 'Gender', hierarchyName: 'Subject.Gender', levelName: 'Gender', allMemberName: '[Subject.Gender].[(All)]',
                filterType: "OR", filterOptions: [{type: "OR", caption: "is any of"}]
        },
        "Species":
        {
            name: 'Species', pluralName: 'Species', hierarchyName: 'Subject.Species', levelName: 'Species', allMemberName: '[Subject.Species].[(All)]',
                filterType: "OR", filterOptions: [{type: "OR", caption: "is any of"}]
        },
        "Principal":
        {
            name: 'Principal', pluralName: 'Species', hierarchyName: 'Study.Principal', levelName: 'Principal', allMemberName: '[Study.Principal].[(All)]',
                filterType: "OR", filterOptions: [{type: "OR", caption: "is any of"}]
        },
        "ExposureMaterial":
        {
            name: 'ExposureMaterial', caption:"Exposure Material", pluralName: 'Exposure Materials', hierarchyName: 'Subject.ExposureMaterial', levelName: 'ExposureMaterial', allMemberName: '[Subject.ExposureMaterial].[(All)]',
                filterType: "OR", filterOptions: [{type: "OR", caption: "is any of"}]
        },
        "ExposureProcess":
        {
            name: 'ExposureProcess', caption:"Exposure Process", pluralName: 'Exposure Processes', hierarchyName: 'Subject.ExposureProcess', levelName: 'ExposureProcess', allMemberName: '[Subject.ExposureProcess].[(All)]',
                filterType: "OR", filterOptions: [{type: "OR", caption: "is any of"}]
        },
        "SampleType":
        {
            name: 'SampleType', caption:"Sample Type", pluralName: 'Sample Types', hierarchyName: 'Sample.Type', levelName: 'Type', allMemberName: '[Sample.Type].[(All)]',
                filterType: "OR", filterOptions: [{type: "OR", caption: "is any of"}]
        },
        "Subject":
        {
            name: 'Subject', hierarchyName: 'Subject', levelName: 'Subject', allMemberName: '[Subject].[(All)]',
                filterType: "OR", filterOptions: [{type: "OR", caption: "is any of"}]
        }
    };
    for (var p in dimensions)
    {
        var dim = dimensions[p];
        LABKEY.Utils.apply(dim, {members: [], memberMap: {}, filters: [], summaryCount: 0, allMemberCount: 0});
        dim.pluralName = dim.pluralName || dim.name + 's';
        dim.filterType = dim.filterType || "OR";
        for (var f = 0; f < dim.filterOptions.length; f++)
        {
            if (dim.filterOptions[f].type === dim.filterType)
                dim.filterCaption = dim.filterOptions[f].caption;
        }
    }


LABKEY.Utils.onReady(function()
{
    var map = {};

    // query immport.studies
    var SQL = LABKEY.Query.SQL || LABKEY.Query.experimental.SQL;
    var queryComplete = 0;

    var immportStudySQL =
            "SELECT study.*, P.name as program_title, pi.pi_names\n" +
            "FROM immport.study\n" +
            " LEFT OUTER JOIN (SELECT study_accession, MIN(contract_grant_id) as contract_grant_id FROM immport.contract_grant_2_study GROUP BY study_accession) CG2S ON study.study_accession = CG2S.study_accession\n" +
            " LEFT OUTER JOIN immport.contract_grant C ON CG2S.contract_grant_id = C.contract_grant_id\n" +
            " LEFT OUTER JOIN immport.program P on C.program_id = P.program_id\n" +
            " LEFT OUTER JOIN\n" +
            "\t(\n" +
            // extra parens required in group_concat is probably a bug
            "\tSELECT study_accession, group_concat( (first_name || ' ' || last_name), ', ') as pi_names\n" +
            "\tFROM immport.study_personnel\n" +
            "\tWHERE role_in_study like '%principal%' OR role_in_study like '%Principal%'\n" +
            "\tGROUP BY study_accession) pi ON study.study_accession = pi.study_accession\n";

    SQL.execute({schema:"immport", sql:immportStudySQL, success:function(raw)
        {
            var immportStudies = SQL.asObjects(raw.names, raw.rows);
            immportStudies.forEach(function(immportStudy)
            {
                var study_accession = immportStudy.study_accession;
                var hipc_funded = (immportStudy.program_title && immportStudy.program_title.indexOf("HIPC")>=0);
                map[study_accession] = $.extend(
                        map[study_accession]||{study_accession:study_accession, container:null, highlight:false, hipc_funded:hipc_funded, loaded:false, url:null},
                        {
                            id: parseInt(study_accession.substr(3)),
                            memberName: '[Study].[' + study_accession + ']',
                            pi : immportStudy.pi_names,
                            restricted : !!immportStudy.restricted,
                            title : immportStudy.brief_title || immportStudy.official_title
                        });
            });
            queryComplete++;
            if (queryComplete === 2)
                renderFinder();
        }
    });
    SQL.execute({schema:"study", sql:"SELECT *, Container.Name FROM study.StudyProperties", success:function(raw)
        {
            var labkeyStudies = SQL.asObjects(raw.names, raw.rows);
            labkeyStudies.forEach(function(labkeyStudy){
                var study_accession = labkeyStudy.Label || labkeyStudy.Name;
                if (!/SDY[0-9]+/.exec(study_accession))
                    return;
                var highlight = labkeyStudy.highlight_until && labkeyStudy.highlight_until>(new Date());
                map[study_accession] = $.extend(
                        map[study_accession]||{study_accession:study_accession},
                        {
                            containerId : labkeyStudy.Container,
                            highlight : highlight,
                            hipc_funded: !!labkeyStudy.hipc_funded,
                            loaded: true,
                            url: LABKEY.ActionURL.buildURL("project","begin",LABKEY.ActionURL.getContainer() + "/" + study_accession)
                        });
            });
            queryComplete++;
            if (queryComplete === 2)
                renderFinder();
        }
    });

    function renderFinder()
    {
        var studiesFromQuery = [];
        for (var study_accession in map)
        {
            if (map.hasOwnProperty(study_accession))
                studiesFromQuery.push(map[study_accession]);
        }
        ReactDOM.render(React.createElement(DataFinderController, {studies:studiesFromQuery, dimensions:dimensions}), document.getElementById("dataFinderApp"));
    }
    // query study.studyData

});

</script>
