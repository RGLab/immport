package org.labkey.test.pages.immport;

import org.labkey.test.BaseWebDriverTest;
import org.labkey.test.Locator;
import org.labkey.test.components.ext4.Checkbox;
import org.labkey.test.pages.LabKeyPage;
import org.labkey.test.util.Ext4Helper;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.io.File;

public class ExportStudyDatasetsPage extends LabKeyPage<ExportStudyDatasetsPage.ElementCache>
{
    public ExportStudyDatasetsPage(WebDriver driver)
    {
        super(driver);
    }

    public ExportStudyDatasetsPage selectDataset(String datasetId)
    {
        return setCheckbox(datasetId, true);
    }

    public ExportStudyDatasetsPage selectDatasetFile(String datasetId)
    {
        return setCheckbox(datasetId + "f", true);
    }

    private ExportStudyDatasetsPage setCheckbox(String rowRecordId, boolean check)
    {
        Checkbox rowChecker = elementCache().findRowCheckbox(rowRecordId);
        if (rowChecker.isChecked() != check)
            doAndWaitForUpdate(rowChecker::toggle);
        return this;
    }

    public File download()
    {
        shortWait().until(ExpectedConditions.elementToBeClickable(elementCache().downloadBtn));
        return clickAndWaitForDownload(elementCache().downloadBtn);
    }

    private void doAndWaitForUpdate(Runnable action)
    {
        doAndWaitForElementToRefresh(action, Locator.id("summaryData").childTag("div"), shortWait());
    }

    @Override
    protected ElementCache newElementCache()
    {
        return new ElementCache();
    }

    protected class ElementCache extends LabKeyPage.ElementCache
    {
        public ElementCache()
        {
            BaseWebDriverTest.waitFor(() -> !downloadBtn.getAttribute("class").contains("disabled"),
                    "Export page did not finish loading", 10000);
        }

        private WebElement downloadBtn = Ext4Helper.Locators.ext4Button("Download").waitForElement(this, 1000);

        private WebElement findGridRow(String recordId)
        {
            return Locator.tagWithAttribute("tr", "data-recordid", recordId).findElement(this);
        }

        private Checkbox findRowCheckbox(String rowRecordId)
        {
            return new Checkbox.CheckboxFinder(Checkbox.CheckboxType.GRID_CHECKER_COLUMN).find(findGridRow(rowRecordId));
        }
    }
}
