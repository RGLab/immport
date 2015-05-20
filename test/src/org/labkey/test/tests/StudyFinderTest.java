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

package org.labkey.test.tests;

import org.apache.commons.collections15.Bag;
import org.apache.commons.collections15.bag.HashBag;
import org.apache.http.HttpStatus;
import org.junit.BeforeClass;
import org.junit.Test;
import org.junit.experimental.categories.Category;
import org.labkey.test.BaseWebDriverTest;
import org.labkey.test.Locator;
import org.labkey.test.TestFileUtils;
import org.labkey.test.TestTimeoutException;
import org.labkey.test.WebTestHelper;
import org.labkey.test.categories.External;
import org.labkey.test.components.ParticipantListWebPart;
import org.labkey.test.components.immport.StudySummaryWindow;
import org.labkey.test.components.study.StudyOverviewWebPart;
import org.labkey.test.pages.immport.ImmPortBeginPage;
import org.labkey.test.pages.immport.StudyFinderPage;
import org.labkey.test.pages.immport.StudyFinderPage.Dimension;
import org.labkey.test.util.APIContainerHelper;
import org.labkey.test.util.AbstractContainerHelper;
import org.labkey.test.util.DataRegionTable;
import org.labkey.test.util.DatasetDomainEditor;
import org.labkey.test.util.LogMethod;
import org.labkey.test.util.Maps;
import org.labkey.test.util.PortalHelper;
import org.labkey.test.util.PostgresOnlyTest;
import org.labkey.test.util.ReadOnlyTest;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotEquals;
import static org.junit.Assert.assertTrue;

@Category({External.class})
public class StudyFinderTest extends BaseWebDriverTest implements PostgresOnlyTest, ReadOnlyTest
{
    private static File immPortArchive = TestFileUtils.getSampleData("HIPC/ANIMAL_STUDIES.zip");
    private static File TEMPLATE_ARCHIVE = TestFileUtils.getSampleData("HIPC/SDY_template.zip");
    private static String IMMPORT_PROJECT = "ImmPort Admin Project";
    private static String[] ANIMAL_STUDIES = {"SDY21", "SDY29", "SDY30", "SDY31", "SDY32", "SDY35", "SDY62", "SDY64", "SDY78", "SDY95", "SDY99", "SDY139", "SDY147", "SDY208", "SDY215", "SDY217", "SDY241", "SDY259", "SDY271", "SDY286", "SDY288"};
    private static String[] STUDY_SUBFOLDERS = {"SDY139", "SDY147", "SDY208", "SDY217"};

    @Override
    protected String getProjectName()
    {
        return "ImmuneSpace Test Dataspace";
    }

    @Override
    protected BrowserType bestBrowser()
    {
        return BrowserType.CHROME;
    }

    @Override
    protected void doCleanup(boolean afterTest) throws TestTimeoutException
    {
        AbstractContainerHelper containerHelper = new APIContainerHelper(this);
        containerHelper.deleteProject(getProjectName(), afterTest);
        containerHelper.deleteProject(IMMPORT_PROJECT, afterTest);
    }

    @BeforeClass
    public static void initTest()
    {
        StudyFinderTest init = (StudyFinderTest)getCurrentTest();

        if (init.needsSetup())
            init.setupProject();
    }

    @Override
    public boolean needsSetup()
    {
        try
        {
            return HttpStatus.SC_NOT_FOUND == WebTestHelper.getHttpGetResponse(WebTestHelper.buildURL("project", getProjectName(), "begin")) ||
                    HttpStatus.SC_NOT_FOUND == WebTestHelper.getHttpGetResponse(WebTestHelper.buildURL("project", IMMPORT_PROJECT, "begin"));
        }
        catch (IOException fail)
        {
            return true;
        }
    }

    private void setupProject()
    {
        AbstractContainerHelper containerHelper = new APIContainerHelper(this);
        containerHelper.createProject(IMMPORT_PROJECT, null);
        containerHelper.enableModule("ImmPort");
        ImmPortBeginPage
                .beginAt(this, IMMPORT_PROJECT)
                .importArchive(immPortArchive, false);
        ImmPortBeginPage
                .beginAt(this, IMMPORT_PROJECT)
                .populateCube();

        containerHelper.createProject(getProjectName(), "Study");
        clickButton("Create Study");
        checkRadioButton(Locator.radioButtonByNameAndValue("shareDatasets", "true"));
        checkRadioButton(Locator.radioButtonByNameAndValue("shareVisits", "true"));
        selectOptionByValue(Locator.name("securityString"), "ADVANCED_WRITE");
        clickButton("Create Study");
        containerHelper.enableModule("ImmPort");
        containerHelper.setFolderType("Dataspace");
        new PortalHelper(this).addWebPart("ImmPort Study Finder");

        containerHelper.createSubfolder(getProjectName(), "SDY_template", "Study");
        importStudyFromZip(TEMPLATE_ARCHIVE, true, true);

        // Share demographics
        beginAt(WebTestHelper.buildURL("study", getProjectName(), "editType", Maps.of("datasetId", "5001")));
        DatasetDomainEditor datasetDomainEditor = new DatasetDomainEditor(this);
        datasetDomainEditor.shareDemographics(DatasetDomainEditor.ShareDemographicsBy.PTID);
        datasetDomainEditor.save();

        for (String studyAccession : STUDY_SUBFOLDERS)
        {
            containerHelper.createSubfolder(getProjectName(), studyAccession, "Study");
            clickButton("Create Study");
            setFormElement(Locator.name("label"), studyAccession);
            selectOptionByValue(Locator.name("securityString"), "ADVANCED_WRITE");
            clickButton("Create Study");
            goToModule("ImmPort");
            new ImmPortBeginPage(this)
                    .copyDatasetsForOneStudy()
                    .copyStudyResults(studyAccession);
        }

        goToProjectHome();
        goToModule("ImmPort");
        new ImmPortBeginPage(this).populateCube();
    }

    @Test
    public void testCounts()
    {
        goToProjectHome();
        StudyFinderPage studyFinder = new StudyFinderPage(this);
        assertCountsSynced(studyFinder);

        Map<Dimension, Integer> studyCounts = studyFinder.getSummaryCounts();

        for (Map.Entry<Dimension, Integer> count : studyCounts.entrySet())
        {
            if (count.getKey().getSummaryLabel() != null)
                assertNotEquals("No " + count.getKey().getSummaryLabel(), 0, count.getValue().intValue());
        }
    }

    @Test
    public void testStudyCards()
    {
        StudyFinderPage studyFinder = StudyFinderPage.goDirectlyToPage(this, getProjectName());
        studyFinder.dismissTour();

        List<StudyFinderPage.StudyCard> studyCards = studyFinder.getStudyCards();

        studyCards.get(0).viewSummary();
    }

    @Test
    public void testImmuneSpaceStudySubset()
    {
        StudyFinderPage studyFinder = StudyFinderPage.goDirectlyToPage(this, getProjectName());
        studyFinder.dismissTour();

        studyFinder.showAllImmPortStudies();
        assertEquals("Wrong ImmPort studies have LabKey study links", Arrays.asList(STUDY_SUBFOLDERS),
                getTexts(Locator.tagWithClass("div", "study-card").withPredicate(Locator.linkWithText("go to study"))
                        .append(Locator.tagWithClass("span", "studycard-accession")).findElements(getDriver())));

        studyFinder.showAllImmuneSpaceStudies();
        List<StudyFinderPage.StudyCard> studyCards = studyFinder.getStudyCards();
        List<String> studies = new ArrayList<>();
        for (StudyFinderPage.StudyCard studyCard : studyCards)
        {
            studies.add(studyCard.getAccession());
        }
        assertEquals("Wrong study cards for ImmuneSpace studies", Arrays.asList(STUDY_SUBFOLDERS), studies);
    }

    @Test
    public void testSelection()
    {
        goToProjectHome();
        StudyFinderPage studyFinder = new StudyFinderPage(this);
        studyFinder.showAllImmPortStudies();

        Map<Dimension, StudyFinderPage.DimensionPanel> dimensionPanels = studyFinder.getDimensionPanels();

        dimensionPanels.get(Dimension.SPECIES).selectFirstIntersectingMeasure();
        List<String> selectedGenders = new ArrayList<>();
        selectedGenders.add(dimensionPanels.get(Dimension.GENDER).selectFirstIntersectingMeasure());

        assertCountsSynced(studyFinder);
        assertSelectionsSynced(studyFinder);

        dimensionPanels.get(Dimension.SPECIES).selectAll();

        List<String> finalSelectedGenders = dimensionPanels.get(Dimension.GENDER).getSelectedValues();
        List<String> finalSelectedSpecies = dimensionPanels.get(Dimension.SPECIES).getSelectedValues();

        assertEquals("Clearing Species selection removed Gender filter", selectedGenders, finalSelectedGenders);
        assertEquals("Clicking 'ALL' didn't clear species selection", 0, finalSelectedSpecies.size());

        assertCountsSynced(studyFinder);
        assertSelectionsSynced(studyFinder);
    }

    @Test
    public void testSelectingEmptyMeasure()
    {
        Map<Dimension, Integer> expectedCounts = new HashMap<>();
        expectedCounts.put(Dimension.STUDIES, 0);
        expectedCounts.put(Dimension.PARTICIPANTS, 0);
        expectedCounts.put(Dimension.SPECIES, 0);
        expectedCounts.put(Dimension.TYPE, 0);
        expectedCounts.put(Dimension.CONDITION, 0);
        expectedCounts.put(Dimension.ASSAY, 0);
        expectedCounts.put(Dimension.TIMEPOINT, 0);
        expectedCounts.put(Dimension.GENDER, 0);
        expectedCounts.put(Dimension.RACE, 0);

        StudyFinderPage studyFinder = StudyFinderPage.goDirectlyToPage(this, getProjectName());
        studyFinder.dismissTour();

        WebElement emptyMember = Locator.css("fieldset.group-fieldset > div.emptyMember").waitForElement(getDriver(), shortWait());
        String value = emptyMember.getText().trim();
        emptyMember.click();

        studyFinder.waitForSelection(value);

        List<StudyFinderPage.StudyCard> filteredStudyCards = studyFinder.getStudyCards();
        Map<Dimension, Integer> filteredSummaryCounts = studyFinder.getSummaryCounts();

        assertEquals("Study cards visible after selection", 0, filteredStudyCards.size());
        assertEquals("Wrong counts after selecting empty measure", expectedCounts, filteredSummaryCounts);
    }

    @Test
    public void testSearch()
    {
        StudyFinderPage studyFinder = StudyFinderPage.goDirectlyToPage(this, getProjectName());
        studyFinder.dismissTour();
        studyFinder.showAllImmPortStudies();

        List<StudyFinderPage.StudyCard> studyCards = studyFinder.getStudyCards();
        String searchString = studyCards.get(0).getAccession();

        studyFinder.studySearch(searchString);

        shortWait().until(ExpectedConditions.stalenessOf(studyCards.get(1).getCardElement()));
        studyCards = studyFinder.getStudyCards();

        assertEquals("Wrong number of studies after search", 1, studyCards.size());

        assertCountsSynced(studyFinder);
    }

    @Test
    public void testStudySummaryWindow()
    {
        StudyFinderPage studyFinder = StudyFinderPage.goDirectlyToPage(this, getProjectName());
        studyFinder.dismissTour();

        StudyFinderPage.StudyCard studyCard = studyFinder.getStudyCards().get(0);

        StudySummaryWindow summaryWindow = studyCard.viewSummary();

        assertEquals("Study card does not match summary (Accession)", studyCard.getAccession(), summaryWindow.getAccession());
        assertEquals("Study card does not match summary (Title)", studyCard.getTitle().toUpperCase(), summaryWindow.getTitle());
        String cardPI = studyCard.getPI();
        String summaryPI = summaryWindow.getPI();
        assertTrue("Study card does not match summary (PI)", summaryPI.contains(cardPI));

        summaryWindow.closeWindow();
    }

    @Test
    public void testStudyParticipantCounts()
    {
        Map<String, Integer> studyFinderParticipantCounts = new HashMap<>();
        Map<String, Integer> studyParticipantCounts = new HashMap<>();

        goToProjectHome();
        StudyFinderPage studyFinder = new StudyFinderPage(this);
        for (String studyAccession : STUDY_SUBFOLDERS)
        {
            studyFinder.studySearch(studyAccession);
            studyFinderParticipantCounts.put(studyAccession, studyFinder.getSummaryCounts().get(Dimension.PARTICIPANTS));
        }

        for (String studyAccession : STUDY_SUBFOLDERS)
        {
            clickFolder(studyAccession);
            StudyOverviewWebPart studyOverview = new StudyOverviewWebPart(this);
            studyParticipantCounts.put(studyAccession, studyOverview.getParticipantCount());
        }

        assertEquals("Participant counts in study finder don't match LabKey studies", studyFinderParticipantCounts, studyParticipantCounts);
    }

    @Test
    public void testStudyCardLinks()
    {
        goToProjectHome();
        StudyFinderPage studyFinder = new StudyFinderPage(this);
        Set<String> foundAccessions = new HashSet<>();
        for (StudyFinderPage.StudyCard studyCard : studyFinder.getStudyCards())
        {
            String studyAccession = studyCard.getAccession();
            foundAccessions.add(studyAccession);
            studyCard.clickGoToStudy();
            switchToWindow(1);
            WebElement title = Locator.css(".labkey-folder-title").waitForElement(getDriver(), shortWait());
            assertEquals("Study card linked to wrong study", studyAccession, title.getText());
            getDriver().close();
            switchToMainWindow();
        }

        assertEquals("Didn't find all studies", new HashSet<>(Arrays.asList(STUDY_SUBFOLDERS)), foundAccessions);
    }

    @Test
    public void testStickyStudyFinderFilterCounts()
    {
        Map<Dimension, Integer> expectedCounts = new HashMap<>();
        expectedCounts.put(Dimension.STUDIES, 2);
        expectedCounts.put(Dimension.PARTICIPANTS, 307);
        expectedCounts.put(Dimension.SPECIES, 1);
        expectedCounts.put(Dimension.TYPE, 1);
        expectedCounts.put(Dimension.CONDITION, 0);
        expectedCounts.put(Dimension.ASSAY, 3);
        expectedCounts.put(Dimension.TIMEPOINT, 11);
        expectedCounts.put(Dimension.GENDER, 1);
        expectedCounts.put(Dimension.RACE, 1);

        goToProjectHome();

        StudyFinderPage studyFinder = new StudyFinderPage(this);
        studyFinder.getDimensionPanels().get(Dimension.CATEGORY).select("Immune Response");

        Map<Dimension, Integer> studyFinderSummaryCounts = studyFinder.getSummaryCounts();
        assertEquals("Study finder counts not as expected for 'Immune Response'.", expectedCounts, studyFinderSummaryCounts);

        clickAndWait(Locator.linkWithText("15 datasets"));
        clickAndWait(Locator.linkWithText("Demographics"));
        DataRegionTable demData = new DataRegionTable("Dataset", this);
        demData.showAll();
        assertEquals("Demographics dataset doesn't have same number of genders as filtered study finder",
                new HashSet<>(demData.getColumnDataAsText("Gender")).size(), studyFinderSummaryCounts.get(Dimension.GENDER).intValue());
        assertEquals("Demographics dataset doesn't have same number of races as filtered study finder",
                new HashSet<>(demData.getColumnDataAsText("Race")).size(), studyFinderSummaryCounts.get(Dimension.RACE).intValue());
        assertEquals("Demographics dataset doesn't have same number of species as filtered study finder",
                new HashSet<>(demData.getColumnDataAsText("Species")).size(), studyFinderSummaryCounts.get(Dimension.SPECIES).intValue());
        assertEquals("Demographics dataset doesn't have same number of participants as filtered study finder",
                demData.getDataRowCount(), studyFinderSummaryCounts.get(Dimension.PARTICIPANTS).intValue());

        clickTab("Participants");
        ParticipantListWebPart participantListWebPart = new ParticipantListWebPart(this);
        assertEquals("Participant list count doesn't match study finder", participantListWebPart.getParticipantCount(), studyFinderSummaryCounts.get(Dimension.PARTICIPANTS));
    }

    @LogMethod(quiet = true)
    private void assertCountsSynced(StudyFinderPage studyFinder)
    {
        List<StudyFinderPage.StudyCard> studyCards = studyFinder.getStudyCards();
        Map<Dimension, Integer> studyCounts = studyFinder.getSummaryCounts();
        Map<Dimension, StudyFinderPage.DimensionPanel> dimensions = studyFinder.getDimensionPanels();

        assertEquals("Study count mismatch", studyCards.size(), studyCounts.get(Dimension.STUDIES).intValue());

        for (Dimension dim : Dimension.values())
        {
            if (dim.getSummaryLabel() != null && dim.getCaption() != null)
            {
                assertEquals("Counts out of sync: " + dim.getCaption(), studyCounts.get(dim).intValue(), dimensions.get(dim).getNonEmptyValues().size());
            }
        }
    }

    @LogMethod(quiet = true)
    private void assertSelectionsSynced(StudyFinderPage studyFinder)
    {
        Map<Dimension, StudyFinderPage.DimensionPanel> dimensionPanels = studyFinder.getDimensionPanels();
        Map<Dimension, StudyFinderPage.DimensionFilter> summarySelections = studyFinder.getSelections();

        for (Dimension dim : Dimension.values())
        {
            Bag<String> panelSelections;
            if (dimensionPanels.containsKey(dim))
                panelSelections = new HashBag<>(dimensionPanels.get(dim).getSelectedValues());
            else
                panelSelections = new HashBag<>();

            Bag<String> dimensionSummarySelections;
            if (summarySelections.containsKey(dim))
                dimensionSummarySelections = new HashBag<>(summarySelections.get(dim).getFilterValues());
            else
                dimensionSummarySelections = new HashBag<>();

            assertEquals("Selection did not match summary for " + dim.getCaption(), panelSelections, dimensionSummarySelections);
        }
    }

    @Override
    public List<String> getAssociatedModules()
    {
        return Arrays.asList("ImmPort");
    }
}