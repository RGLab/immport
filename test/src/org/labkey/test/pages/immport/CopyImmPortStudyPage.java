package org.labkey.test.pages.immport;

import org.labkey.test.Locator;
import org.labkey.test.pages.LabKeyPage;
import org.openqa.selenium.WebDriver;

public class CopyImmPortStudyPage extends LabKeyPage
{
    public CopyImmPortStudyPage(WebDriver driver)
    {
        super(driver);
    }

    public LabKeyPage copyStudyResults(String study)
    {
        setFormElement(Locator.id("replaceResultsForm").append(Locator.tagWithName("input", "$STUDY")), study);
        doAndWaitForPageToLoad(() -> Locator.id("replaceResultsForm").findElement(getDriver()).submit());
        return null; // TODO: pipeline-status DetailsAction
    }

    public LabKeyPage appendStudyResults(String study)
    {
        setFormElement(Locator.id("appendResultsForm").append(Locator.tagWithName("input", "$STUDY")), study);
        doAndWaitForPageToLoad(() -> Locator.id("appendResultsForm").findElement(getDriver()).submit());
        return null; // TODO: pipeline-status DetailsAction
    }
}
