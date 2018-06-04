package org.labkey.test.pages.immport;

import org.labkey.test.BaseWebDriverTest;
import org.labkey.test.Locator;
import org.labkey.test.WebTestHelper;
import org.labkey.test.pages.LabKeyPage;
import org.labkey.test.util.LogMethod;

import java.io.File;

public class ImmPortBeginPage extends LabKeyPage
{
    private final BaseWebDriverTest test;

    public ImmPortBeginPage(BaseWebDriverTest test)
    {
        super(test.getDriver());
        this.test = test;
    }

    public static ImmPortBeginPage beginAt(BaseWebDriverTest test)
    {
        return beginAt(test, test.getCurrentContainerPath());
    }

    public static ImmPortBeginPage beginAt(BaseWebDriverTest test, String containerPath)
    {
        test.beginAt(WebTestHelper.buildURL("immport", containerPath, "begin"));
        return new ImmPortBeginPage(test);
    }

    @LogMethod
    public void importArchive(File archive, boolean restricted)
    {
        test.checkErrors();
        clickAndWait(Locator.linkWithText("Import Archive"));
        setFormElement(Locator.name("path"), archive);
        if (restricted) checkCheckbox(Locator.name("restricted"));
        clickAndWait(Locator.css("form[name=importArchive] input[type=submit]"));
        test.waitForPipelineJobsToComplete(1, "Load ImmPort archive", false, 600000);
        test.resetErrors();
    }

    @LogMethod
    public void populateCube()
    {
        clickAndWait(Locator.linkWithText("Populate cube"));
        clickAndWait(Locator.css("form[name=populateCube] input[type=submit]"), 120000);
    }

    //TODO: Create RestrictedStudiesPage
    public LabKeyPage goToRestrictedStudies()
    {
        clickAndWait(Locator.linkWithText("Public/Restricted Studies"));
        return null;
    }

    public CopyImmPortStudyPage copyDatasetsForOneStudy()
    {
        clickAndWait(Locator.linkWithText("Copy datasets for one study in this folder"));
        return new CopyImmPortStudyPage(getDriver());
    }

    public File downloadSpecimens()
    {
        return clickAndWaitForDownload(Locator.linkWithText("Import Archive"));
    }

    public LabKeyPage uploadSpecimens()
    {
        clickAndWait(Locator.linkWithText("Import Archive"));
        //TODO: Finish implementation
        return null;
    }

    public PublishExpressionMatrixPage publishExpressionMatrix()
    {
        clickAndWait(Locator.linkWithText("Export selected expression matrices"));
        return new PublishExpressionMatrixPage(getDriver());
    }
}
