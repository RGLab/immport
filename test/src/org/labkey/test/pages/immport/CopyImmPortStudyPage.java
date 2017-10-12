package org.labkey.test.pages.immport;

import org.labkey.test.BaseWebDriverTest;
import org.labkey.test.Locator;
import org.labkey.test.pages.LabKeyPage;

public class CopyImmPortStudyPage extends LabKeyPage
{
    public CopyImmPortStudyPage(BaseWebDriverTest test)
    {
        super(test);
    }

    public LabKeyPage copyStudyResults(String study)
    {
        setFormElement(Locator.id("replaceResultsForm").append(Locator.tagWithName("input", "$STUDY")), study);
        _test.doAndWaitForPageToLoad(() -> Locator.id("replaceResultsForm").findElement(getDriver()).submit());
        return new LabKeyPage(getDriver()); // TODO: pipeline-status DetailsAction
    }

    public LabKeyPage appendStudyResults(String study)
    {
        setFormElement(Locator.id("appendResultsForm").append(Locator.tagWithName("input", "$STUDY")), study);
        _test.doAndWaitForPageToLoad(() -> Locator.id("appendResultsForm").findElement(getDriver()).submit());
        return new LabKeyPage(getDriver()); // TODO: pipeline-status DetailsAction
    }
}
