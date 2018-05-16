package org.labkey.test.components.immport;

import org.labkey.test.BaseWebDriverTest;
import org.labkey.test.Locator;
import org.labkey.test.components.Component;
import org.labkey.test.components.WebDriverComponent;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.ArrayList;
import java.util.List;

public class StudySummaryPanel extends WebDriverComponent<StudySummaryPanel.Elements>
{
    private final WebDriver _driver;
    private final WebElement _panel;

    public StudySummaryPanel(WebDriver driver)
    {
        _driver = driver;
        _panel = Locator.css("div#demographics.study-demographics").waitForElement(driver, BaseWebDriverTest.WAIT_FOR_JAVASCRIPT);
        elementCache().accession.isDisplayed();
    }

    @Override
    protected WebDriver getDriver()
    {
        return _driver;
    }

    @Override
    public WebElement getComponentElement()
    {
        return _panel;
    }

    public String getAccession()
    {
        return elementCache().accession.getText();
    }

    public String getTitle()
    {
        return elementCache().title.getText();
    }

    public String getPI()
    {
        return elementCache().PI.getText();
    }

    public String getOrganization()
    {
        return elementCache().organization.getText();
    }

    public WebElement getImmportLink()
    {
        return elementCache().immportLink;
    }

    public List<Paper> getPapers()
    {
        return elementCache().getPapers();
    }

    @Override
    protected Elements newElementCache()
    {
        return new Elements();
    }

    protected class Elements extends Component.ElementCache
    {
        protected final WebElement accession = Locator.css(".study-accession").findWhenNeeded(this);
        protected final WebElement title = Locator.css(".study-title").findWhenNeeded(this);
        protected final WebElement PI = Locator.css(".study-pi").findWhenNeeded(this);
        protected final WebElement organization = Locator.css(".study-organization").findWhenNeeded(this);
        protected final WebElement immportLink = Locator.linkWithText("ImmPort").findWhenNeeded(this);

        private List<Paper> papers;
        protected List<Paper> getPapers()
        {
            if (papers == null)
            {
                papers = new ArrayList<>();
                List<WebElement> paperEls = Locator.css(".study-papers > p").findElements(_panel);

                for (WebElement el : paperEls)
                {
                    papers.add(new Paper(el));
                }
            }
            return papers;
        }
    }

    private class Paper extends Component
    {
        private final WebElement paper;

        private Paper(WebElement el)
        {
            this.paper = el;
        }

        @Override
        public WebElement getComponentElement()
        {
            return paper;
        }

        public String getJournal()
        {
            return journal.getText();
        }

        public String getYear()
        {
            return year.getText();
        }

        public String getTitle()
        {
            return title.getText();
        }

        public WebElement getPubMedLink()
        {
            return pubMedLink;
        }

        protected final WebElement journal = Locator.css(".pub-journal").findWhenNeeded(this);
        protected final WebElement year = Locator.css(".pub-year").findWhenNeeded(this);
        protected final WebElement title = Locator.css(".pub-title").findWhenNeeded(this);
        protected final WebElement pubMedLink = Locator.linkWithText("PubMed").findWhenNeeded(this);
    }
}
