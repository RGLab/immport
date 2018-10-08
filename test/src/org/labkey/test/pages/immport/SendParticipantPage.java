package org.labkey.test.pages.immport;

import org.labkey.test.Locator;
import org.labkey.test.pages.LabKeyPage;
import org.openqa.selenium.WebDriver;

import java.util.List;

public class SendParticipantPage extends LabKeyPage
{
    public SendParticipantPage(WebDriver driver)
    {
        super(driver);
    }

    public void setRecipients(List<String> recipients)
    {
        setFormElement(Locators.recipientsList, String.join("\n", recipients));
    }

    public String getRecipients()
    {
        return getFormElement(Locators.recipientsList);
    }

    public void setMessageSubject(String subject)
    {
        setFormElement(Locators.messageSubject, subject);
    }

    public String getMessageSubject()
    {
        return getFormElement(Locators.messageSubject);
    }

    public void setMessageBody(String message)
    {
        setFormElement(Locators.messageBody, message);
    }

    public String getMessageBody()
    {
        return getFormElement(Locators.messageBody);
    }

    public String getMessageLink()
    {
        return getText(Locators.linkText);
    }

    public void clickSubmit()
    {
        clickButton("Submit");
    }

    public void clickCancel()
    {
        clickButton("Cancel");
    }

    private static class Locators
    {
        private static final Locator recipientsList = Locator.id("recipientList");
        private static final Locator messageSubject = Locator.id("messageSubject");
        private static final Locator messageBody = Locator.id("messageBody");
        private static final Locator.XPathLocator linkText = Locator.xpath("//form//b[contains(text(), 'Message link:')]//following-sibling::div[1]");
    }
}
