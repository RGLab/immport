package org.labkey.immport.proxy;

import org.apache.http.Header;
import org.apache.http.HttpRequest;
import org.labkey.api.security.AuthenticatedRequest;
import org.labkey.api.security.SessionApiKeyManager;
import org.labkey.api.security.User;
import org.labkey.api.util.CSRFUtil;
import org.mitre.dsmiley.httpproxy.ProxyServlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


public class LabKeyAuthenticatedProxy extends ProxyServlet
{
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        super.service(request, response);
    }

    @Override
    protected void copyRequestHeaders(HttpServletRequest servletRequest, HttpRequest proxyRequest)
    {
        super.copyRequestHeaders(servletRequest, proxyRequest);

        for (Header header : proxyRequest.getAllHeaders())
            if (header.getName().startsWith("X-LKPROXY"))
                proxyRequest.removeHeader(header);

        // add labkey headers to request
        User user = (User)((AuthenticatedRequest)servletRequest).getUserPrincipal();
        proxyRequest.addHeader("X-LKPROXY-USERID", String.valueOf(user.getUserId()));
        proxyRequest.addHeader("X-LKPROXY-EMAIL", user.getEmail());

        StringBuilder rolesNames = new StringBuilder();
        user.getStandardContextualRoles().forEach(role -> rolesNames.append(role.getUniqueName()).append(", "));
        proxyRequest.addHeader("X-LKPROXY-SITEROLES", rolesNames.toString());

        String apiKey = SessionApiKeyManager.get().getApiKey(servletRequest, LabKeyAuthenticatedProxy.class.getName());
        proxyRequest.addHeader("X-LKPROXY-APIKEY", apiKey);
        proxyRequest.addHeader("X-LKPROXY-CSRF", CSRFUtil.getExpectedToken(servletRequest, null));
    }
}
