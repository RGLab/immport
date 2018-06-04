package org.labkey.test.components.immport;

import org.labkey.test.Locator;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;

public class StudySummaryWindow extends StudySummaryPanel
{
    private final WebElement _window;

    public StudySummaryWindow(WebDriver test)
    {
        super(test);
        _window = Locator.css("div.labkey-study-detail").findElement(getDriver());
    }

    public void closeWindow()
    {
        Locator.css(".x4-tool-close").findElement(_window).click();
        getWrapper().shortWait().until(ExpectedConditions.stalenessOf(_window));
    }
}
