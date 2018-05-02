package org.labkey.test.pages.immport;

import com.google.common.base.Predicate;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.SystemUtils;
import org.labkey.test.BaseWebDriverTest;
import org.labkey.test.Locator;
import org.labkey.test.WebTestHelper;
import org.labkey.test.components.Component;
import org.labkey.test.components.immport.StudySummaryWindow;
import org.labkey.test.pages.LabKeyPage;
import org.labkey.test.util.DataRegionTable;
import org.labkey.test.util.LogMethod;
import org.labkey.test.util.LoggedParam;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebDriverException;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.labkey.test.Locators.pageSignal;

public class DataFinderPage extends LabKeyPage
{
    private static final String CONTROLLER = "immport";
    private static final String ACTION = "dataFinder";
    private static final String COUNT_SIGNAL = "dataFinderCountsUpdated";
    private static final String GROUP_UPDATED_SIGNAL = "participantGroupUpdated";

    public DataFinderPage(BaseWebDriverTest test)
    {
        super(test);
    }

    private Integer parseInt(String s)
    {
        s = StringUtils.trimToEmpty(s).replace(",", "");
        return s.isEmpty() ? null : Integer.parseInt(s);
    }

    @Override
    protected void waitForPage()
    {
        _test.waitForElement(pageSignal(COUNT_SIGNAL));
    }

    protected void waitForGroupUpdate()
    {
        _test.waitForElement(pageSignal(GROUP_UPDATED_SIGNAL));
    }

    public static DataFinderPage goDirectlyToPage(BaseWebDriverTest test, String containerPath)
    {
        test.beginAt(WebTestHelper.buildURL(CONTROLLER, containerPath, ACTION));
        return new DataFinderPage(test);
    }

    public ExportStudyDatasetsPage exportDatasets()
    {
        _test.clickAndWait(Locators.exportDatasets);
        return new ExportStudyDatasetsPage(_test.getDriver());
    }

    public void showUnloadedImmPortStudies()
    {
        selectStudySubset("Unloaded ImmPort studies");
    }

    public void showAllImmuneSpaceStudies()
    {
        selectStudySubset("ImmuneSpace studies");
    }

    public void selectStudySubset(String text)
    {
        String selectedText = _test.getSelectedOptionText(Locators.studySubsetChooser);
        if (!selectedText.equals(text))
        {
            _test.doAndWaitForPageSignal(() -> _test.selectOptionByText(Locators.studySubsetChooser, text), COUNT_SIGNAL);
        }
    }

    @LogMethod
    public void studySearch(@LoggedParam final String search)
    {
        _test.doAndWaitForPageSignal(() -> _test.setFormElement(Locators.studySearchInput, search), COUNT_SIGNAL);
    }

    @LogMethod(quiet = true)
    public void clearSearch()
    {
        if (!_test.getFormElement(Locators.studySearchInput).isEmpty())
            studySearch(" ");
    }

    public void saveGroup()
    {
        DataRegionTable.DataRegion(getDriver()).withName("demoDataRegion").waitFor();
        _test.clickButtonContainingText("Save", BaseWebDriverTest.WAIT_FOR_EXT_MASK_TO_DISSAPEAR);
        waitForGroupUpdate();
    }

    public void saveGroup(String name)
    {
        DataRegionTable.DataRegion(getDriver()).withName("demoDataRegion").waitFor();
        _test.setFormElement(Locators.groupLabelInput, name);
        _test.clickButtonContainingText("Save", BaseWebDriverTest.WAIT_FOR_EXT_MASK_TO_DISSAPEAR);
        waitForGroupUpdate();
    }

    public void saveAndSendGroup(String name)
    {
        DataRegionTable.DataRegion(getDriver()).withName("demoDataRegion").waitFor();
        _test.setFormElement(Locators.groupLabelInput, name);
        _test.clickButtonContainingText("Save and Send", BaseWebDriverTest.WAIT_FOR_EXT_MASK_TO_DISSAPEAR);
        waitForText("Message link:");
    }

    public String getGroupNameFromForm()
    {
        DataRegionTable.DataRegion(getDriver()).withName("demoDataRegion").waitFor();
        return _test.getFormElement(Locators.groupLabelInput);
    }

    public String getGroupLabel()
    {
        return Locators.groupLabel.findElement(_test.getDriver()).getText().trim();
    }

    public GroupMenu getMenu(Locator locator)
    {
        return new GroupMenu(locator.findElement(_test.getDriver()));
    }

    public boolean menuIsDisabled(Locator.CssLocator locator)
    {
        return _test.isElementPresent(locator.append(" .labkey-disabled-text-link"));
    }

    public void openMenu(Locator locator)
    {
        locator.findElement(_test.getDriver()).click();
    }

    public Map<Dimension, Integer> getSummaryCounts()
    {
        WebElement summaryElement = Locators.summaryArea.findElement(_test.getDriver());
        DimensionPanel summary = new DimensionPanel(summaryElement);

        Map<Dimension, Integer> countMap = new HashMap<>();
        for (String value : summary.getValues())
        {
            String[] parts = value.split("\n");
            Dimension dimension = Dimension.fromString(parts[0].toLowerCase());
            Integer count = parseInt(parts[1]);
            countMap.put(dimension, count);
        }
        return countMap;
    }

    public List<StudyCard> getStudyCards()
    {
        List<WebElement> studyCardEls = Locators.studyCard.findElements(_test.getDriver());
        List<StudyCard> studyCards = new ArrayList<>();

        for (WebElement el : studyCardEls)
        {
            studyCards.add(new StudyCard(el));
        }

        return studyCards;
    }

    public List<DimensionMember> getSelectedMembers()
    {
        List<DimensionMember> members = new ArrayList<>();
        for (WebElement el : Locators.selection.findElements(_test.getDriver()))
        {
            members.add(new DimensionMember(el));
        }
        return members;
    }

    public Map<Dimension, List<String>> getSelectionValues()
    {
        Map<Dimension, List<String>> selectionValues = new HashMap<>();

        for (DimensionMember member : getSelectedMembers())
        {
            List<String> values = selectionValues.get(member.getDimension());
            if (values == null)
            {
                values = new ArrayList<>();
                selectionValues.put(member.getDimension(), values);
            }
            values.add(member.getName());
        }

        return selectionValues;
    }

    public Map<Dimension, DimensionPanel> getAllDimensionPanels()
    {
        return getDimensionPanels(Locators.facet);
    }

    public Map<Dimension, DimensionPanel> getDimensionPanels(Locator locator)
    {
        List<WebElement> dimensionPanelEls = locator.findElements(_test.getDriver());
        Map<Dimension, DimensionPanel> dimensionPanels = new HashMap<>();

        for (WebElement el : dimensionPanelEls)
        {
            DimensionPanel panel = new DimensionPanel(el);
            dimensionPanels.put(panel.getDimension(), panel);
        }

        return dimensionPanels;
    }

    public void clearAllFilters()
    {
        if(isElementPresent(Locators.clearAll))
        {
            final WebElement clearAll = Locators.clearAll.findElement(_test.getDriver());
            if (clearAll.isDisplayed())
            {
                _test.doAndWaitForPageSignal(clearAll::click, COUNT_SIGNAL);
            }
        }
        else
        {
            // If that element is not present see if the 'alternative element' is.
            if(isElementPresent(Locators.clearAllFilters))
            {
                final WebElement clearAllFilters = Locators.clearAllFilters.findElement(_test.getDriver());
                if (clearAllFilters.isDisplayed())
                {
                    _test.doAndWaitForPageSignal(clearAllFilters::click, COUNT_SIGNAL);
                }
            }
        }
    }

    public void loadSavedGroup(String groupName)
    {
        click(Locators.loadMenu);
        waitForElement(Locators.savedGroups.append(" a").containing(groupName));
        click(Locators.savedGroups.append(" a").containing(groupName));
    }

    public SendParticipantPage clickSend(BaseWebDriverTest test)
    {
        clickAndWait(Locators.sendMenu);
        return new SendParticipantPage(test);
    }

    public void dismissTour()
    {
        _test.shortWait().until(new Predicate<WebDriver>()
        {
            @Override
            public boolean apply(WebDriver webDriver)
            {
                try
                {
                    return (Boolean) _test.executeScript("" +
                            "if (window.hopscotch)" +
                            "  return !hopscotch.endTour().isActive;" +
                            "else" +
                            "  return true;");
                }
                catch (WebDriverException recheck)
                {
                    return false;
                }
            }

            @Override
            public String toString()
            {
                return "tour to be dismissed.";
            }
        });
    }

    public static class Locators
    {
        public static final Locator.CssLocator studyFinder = Locator.css("#dataFinderApp");
        public static final Locator.XPathLocator exportDatasets = Locator.linkWithText("Export Study Datasets");
        public static final Locator.CssLocator studySearchInput = studyFinder.append(Locator.css("#searchTerms"));
        public static final Locator studySubsetChooser = Locator.name("studySubsetSelect");
        public static final Locator.CssLocator studyCard = studyFinder.append(Locator.css(".labkey-study-card"));
        public static final Locator.CssLocator selectionPanel = studyFinder.append(Locator.css(".df-selection-panel"));
        public static final Locator.CssLocator facetPanel = selectionPanel.append(Locator.css("#facetPanel"));
        public static final Locator.CssLocator facet = facetPanel.append(" .df-facet");
        public static final Locator.CssLocator summaryArea = selectionPanel.append(Locator.css("#summaryArea"));
        public static final Locator.CssLocator selection = facetPanel.append(Locator.css(" .df-selected-member"));
        public static final Locator.CssLocator clearAll = Locator.css("span[ng-click='clearAllFilters(true);']");
        public static final Locator.CssLocator clearAllFilters = Locator.css("span[ng-click='clearAllClick();']");
        public static final Locator.CssLocator groupLabel = Locator.css(".labkey-group-label");
        public static final Locator groupLabelInput = Locator.name("groupLabel");
        public static final Locator.CssLocator saveMenu = Locator.css("#saveMenu");
        public static final Locator.CssLocator loadMenu = Locator.css("#loadMenu");
        public static final Locator.CssLocator sendMenu = Locator.css("#sendMenu");
        public static final Locator.IdLocator manageMenu = Locator.id("df-manageMenu");
        public static final Locator.CssLocator savedGroups = loadMenu.append(" ul.labkey-dropdown-menu-active");
        public static final Locator.XPathLocator save = Locator.xpath("//li[contains(@ng-repeat, 'saveOptions')][not(contains(@class, 'inactive'))]").append(Locator.linkWithText("Save"));
        public static final Locator.XPathLocator saveAs = Locator.xpath("//li[contains(@ng-repeat, 'saveOptions')][not(contains(@class, 'inactive'))]").append(Locator.linkWithText("Save As"));
    }

    public enum Dimension
    {
        STUDIES(null, "studies"),
        SUBJECTS(null, "subjects"),
        SPECIES("Species", "species"),
        CONDITION("Condition", "conditions"),
        TYPE("Type", "types"),
        CATEGORY("Research focus", "Category"),
        ASSAY("Assay", "assays"),
        TIMEPOINT("Day of Study", "timepoints"),
        GENDER("Gender", "genders"),
        RACE("Race", "races"),
        AGE("Age", "age groups"),
        STUDY("Study", "studies");

        private String caption;
        private String summaryLabel;

        Dimension(String caption, String summaryLabel)
        {
            this.caption = caption;
            this.summaryLabel = summaryLabel;
        }

        public String getCaption()
        {
            return caption;
        }

        public String getSummaryLabel()
        {
            return summaryLabel;
        }

        public static Dimension fromString(String value)
        {
            for (Dimension dimension : values())
            {
                if (value.equals(dimension.getSummaryLabel()) || value.equals(dimension.getCaption()))
                    return dimension;
                if (value.equalsIgnoreCase("participants"))
                    return Dimension.SUBJECTS;
            }

            throw new IllegalArgumentException("No such dimension: " + value);
        }
    }


    public class GroupMenu extends Component
    {

        private final WebElement menu;
        private final Elements elements;

        private GroupMenu(WebElement menu)
        {
            this.menu = menu;
            elements = new Elements();
        }

        public void toggleMenu()
        {
            this.menu.click();
        }

        @Override
        public WebElement getComponentElement()
        {
            return menu;
        }

        public List<String> getActiveOptions()
        {
            return getOptions(elements.activeOption);
        }

        public List<String> getInactiveOptions()
        {
            return getOptions(elements.inactiveOption);
        }

        public void chooseOption(String optionText, boolean waitForUpdate)
        {
            _test.log("Choosing menu option " + optionText);
            List<WebElement> activeOptions = findElements(elements.activeOption);
            for (WebElement option : activeOptions)
            {
                if (optionText.equals(option.getText().trim()))
                {
                    option.click();
                    if (waitForUpdate)
                        waitForGroupUpdate();
                    return;
                }
            }
        }

        private List<String> getOptions(Locator locator)
        {
            List<WebElement> options = findElements(locator);
            List<String> optionStrings = new ArrayList<String>();
            for (WebElement option : options)
            {
                optionStrings.add(option.getText().trim());
            }
            return optionStrings;
        }

        private class Elements
        {
            public Locator.CssLocator activeOption = Locator.css(".df-menu-item-link:not(.inactive)");
            public Locator.CssLocator inactiveOption = Locator.css(".df-menu-item-link.inactive");
        }
    }

    public class DimensionPanel extends Component
    {
        private WebElement panel;
        private Elements elements;
        private Dimension dimension;

        private DimensionPanel(WebElement panel)
        {
            this.panel = panel;
            elements = new Elements();
        }

        public Dimension getDimension()
        {
            if (dimension == null)
            {
                dimension = Dimension.fromString(findElement(elements.dimension).getText());
            }

            return dimension;
        }

        @Override
        public WebElement getComponentElement()
        {
            return panel;
        }

        public List<String> getValues()
        {
            displayDimension();
            return getTexts(findElements(elements.member));
        }

        public List<String> getEmptyValues()
        {
            displayDimension();
            return getTexts(findElements(elements.emptyMemberName));
        }

        public List<String> getNonEmptyValues()
        {
            displayDimension();
            return getTexts(findElements(elements.nonEmptyMemberName));
        }

        public List<String> getSelectedValues()
        {
            displayDimension();
            return getTexts(findElements(elements.selectedMemberName));
        }

        public void displayDimension()
        {
            if (!isDisplayed())
            {
                log("Member list is not displayed.");
                WebElement caption = findElement(elements.facetCaption);
                log("Click facet: '" + caption.getText() + "'.");
                scrollIntoView(caption);
                caption.click();
                sleep(500);
            }
            else
            {
                log("Member list is displayed.");
            }
        }

        public boolean isDisplayed()
        {
            return this.panel.getAttribute("class").contains("expanded");
        }

        public String selectFirstIntersectingMeasure()
        {
            displayDimension();

            WebElement el = findElement(elements.nonEmptyNonSelectedMemberName);
            String value = el.getText();

            addToSelection(el);

            waitForSelection(value);
            return value;
        }

        public Map<String, Integer> getMemberCounts()
        {
            displayDimension();
            Map<String, Integer> countMap = new HashMap<>();
            List<WebElement> members = findElements(elements.member);
            log("getMemberCounts: dimension: " + getDimension().name());
            log("There are " + members.size() + " members in the list.");
            for (WebElement member : members)
            {
                String name = elements.memberName.findElement(member).getText();

                if(name.trim().length() == 0)
                {
                    // The panel wasn't expanded, try again.
                    log("The dimension wasn't expanded trying again.");
                    displayDimension();
                    name = elements.memberName.findElement(member).getText();
                }

                String countText = elements.memberCount.findElement(member).getText();
                log("getMemberCounts: name: " + name + " countText: " + countText);
                Integer count = parseInt(countText);
                countMap.put(name, count);
            }

            return countMap;
        }

        public void selectMember(String memberName)
        {
            displayDimension();
            select(findElement(elements.memberName.withText(memberName)));
            waitForSelection(memberName);
        }

        public void deselectMember(String memberName)
        {
            WebElement member = findElement(elements.member.containing(memberName));
            WebElement check = elements.selectedMemberCheck.findElement(member);
            select(check);
        }

        public void addToSelection(String value)
        {
            displayDimension();
            addToSelection(findElement(elements.member.withText(value)));
            waitForSelection(value);
        }

        public void clearFilters()
        {
            select(findElement(elements.clearFilters));
        }

        private void select(final WebElement value)
        {
            _test.doAndWaitForPageSignal(value::click, COUNT_SIGNAL);
        }

        private void addToSelection(final WebElement value)
        {
            _test.doAndWaitForPageSignal(() -> controlClick(value), COUNT_SIGNAL);
        }

        private void controlClick(WebElement el)
        {
            Keys multiSelectKey;
            if (SystemUtils.IS_OS_MAC)
                multiSelectKey = Keys.COMMAND;
            else
                multiSelectKey = Keys.CONTROL;

            Actions builder = new Actions(_test.getDriver());
            builder.keyDown(multiSelectKey).build().perform();
            el.click();
            builder.keyUp(multiSelectKey).build().perform();
        }

        private void waitForSelection(String value)
        {
            elements.selectedMemberName.containing(value).waitForElement(panel, BaseWebDriverTest.WAIT_FOR_JAVASCRIPT);
        }

        private class Elements
        {
            public Locator.CssLocator facetCaption = Locator.css(".df-facet-caption");
            public Locator.CssLocator dimension = Locator.css(".df-facet-caption > span");
            public Locator.CssLocator member = Locator.css(".df-member");
            public Locator.CssLocator memberName = Locator.css(".df-member-name");
            public Locator.CssLocator memberCount = Locator.css(".df-member-count");
            public Locator.CssLocator selectedMemberCheck = Locator.css(".df-member .df-member-indicator.selected");
            public Locator.CssLocator emptyMemberName = Locator.css(".ng-scope.df-empty-member .df-member-name");
            public Locator.CssLocator nonEmptyMemberName = Locator.css(".ng-scope.df-member:not(.df-empty-member) .df-member-name");
            public Locator.CssLocator nonEmptyNonSelectedMemberName = Locator.css(".ng-scope.df-member:not(.df-empty-member):not(.df-selected-member) .df-member-name");
            public Locator.CssLocator selectedMemberName = Locator.css(".ng-scope.df-selected-member .df-member-name");
            public Locator.CssLocator clearFilters = Locator.css(".df-clear-filter");
        }
    }

    public class StudyCard
    {
        WebElement card;
        Elements elements;
        String title;
        String accession;
        String pi;

        private StudyCard(WebElement card)
        {
            this.card = card;
            elements = new Elements();
        }

        public WebElement getCardElement()
        {
            return card;
        }

        public StudySummaryWindow viewSummary()
        {
            elements.viewStudyLink.findElement(card).click();
            return new StudySummaryWindow(_test);
        }

        public void clickGoToStudy()
        {
            _test.clickAndWait(elements.goToStudyLink.findElement(card));
        }

        public String getAccession()
        {
            return elements.name.findElement(card).getText();
        }

        public String getPI()
        {
            return elements.PI.findElement(card).getText();
        }

        public String getTitle()
        {
            return elements.title.findElement(card).getText();
        }

        private class Elements
        {
            public Locator viewStudyLink = Locator.linkWithText("view summary");
            public Locator goToStudyLink = Locator.linkWithText("go to study");
            public Locator name = Locator.css(".labkey-study-card-accession");
            public Locator PI = Locator.css(".labkey-study-card-pi");
            public Locator title = Locator.css(".labkey-study-card-description");
        }
    }

    public class DimensionMember extends Component
    {
        private final Elements elements;
        private final WebElement memberElement;
        private Dimension dimension;

        private DimensionMember(final WebElement memberElement)
        {
            this.memberElement = memberElement;
            elements = new Elements();
            parseMemberId();
        }

        private void parseMemberId()
        {
            String id = this.memberElement.getAttribute("id");
            String[] parts = id.split("_");
            this.dimension = Dimension.fromString(parts[1]);
        }

        @Override
        public WebElement getComponentElement()
        {
            return memberElement;
        }

        public Dimension getDimension()
        {
            return dimension;
        }

        public String getName()
        {
            return elements.memberName.findElement(memberElement).getText();
        }

        public Integer getCount()
        {
            return parseInt(elements.memberCount.findElement(memberElement).getText());
        }

        private class Elements
        {
            public Locator memberName = Locator.css(".df-member-name");
            public Locator memberCount = Locator.css(".df-member-count");
        }
    }
}
