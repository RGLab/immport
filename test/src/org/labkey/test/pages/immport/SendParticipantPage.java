package org.labkey.test.pages.immport;

import org.labkey.test.BaseWebDriverTest;
import org.labkey.test.Locator;
import org.labkey.test.pages.LabKeyPage;

import java.util.List;

public class SendParticipantPage extends LabKeyPage
{
    public SendParticipantPage(BaseWebDriverTest test)
    {
        super(test.getDriver());
    }

    public void setRecipients(List<String> recipients)
    {
        String fullList = "";
        for(String recipient : recipients)
        {
            fullList += recipient + "\n";
        }

        setFormElement(Locators.recipientsList, fullList);
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

    public String getErrorMessage()
    {
        return getText(Locators.errorMessage);
    }

    public static class Locators
    {
        public static final Locator recipientsList = Locator.id("recipientList");
        public static final Locator messageSubject = Locator.id("messageSubject");
        public static final Locator messageBody = Locator.id("messageBody");
        public static final Locator.XPathLocator linkText = Locator.xpath("//form//b[contains(text(), 'Message link:')]//following-sibling::div[1]");
        public static final Locator errorMessage = org.labkey.test.Locators.labkeyError;
    }

}
