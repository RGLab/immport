package org.labkey.test.pages.immport;

import org.labkey.test.pages.LabKeyPage;
import org.labkey.test.util.Ext4Helper;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.io.File;

public class ExportStudyDatasetsPage extends LabKeyPage
{
    public ExportStudyDatasetsPage(WebDriver driver)
    {
        super(driver);
    }

    public File download()
    {
        WebElement downloadButton = Ext4Helper.Locators.ext4Button("Download").waitForElement(shortWait());
        shortWait().until(ExpectedConditions.elementToBeClickable(downloadButton));
        return clickAndWaitForDownload(downloadButton, 1)[0];
    }
}
