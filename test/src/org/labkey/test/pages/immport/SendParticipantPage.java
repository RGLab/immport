package org.labkey.test.pages.immport;

import org.labkey.test.BaseWebDriverTest;
import org.labkey.test.Locator;
import org.labkey.test.pages.LabKeyPage;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
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
        public static final Locator.CssLocator bodyPanel = Locator.css("#bodypanel");
        public static final Locator.CssLocator recipientsList = bodyPanel.append(" #recipientList");
        public static final Locator.CssLocator messageSubject = bodyPanel.append(" #messageSubject");
        public static final Locator.CssLocator messageBody = bodyPanel.append(" #messageBody");
        public static final Locator.XPathLocator linkText = Locator.xpath("//form//b[contains(text(), 'Message link:')]//following-sibling::div[1]");
        public static final Locator.CssLocator previewLink = bodyPanel.append(" div a.labkey-text-link");
        public static final Locator.CssLocator errorMessage = bodyPanel.append(" div.labkey-error");
    }

}
