package org.labkey.immport;

import org.apache.commons.lang3.StringUtils;
import org.labkey.api.data.ContainerManager;
import org.labkey.api.module.ModuleLoader;
import org.labkey.api.module.ModuleProperty;
import org.labkey.api.view.NotFoundException;
import org.labkey.immport.proxy.LabKeyAuthenticatedProxy;
import org.springframework.web.servlet.mvc.ServletWrappingController;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.ServletException;
import javax.servlet.ServletRegistration;
import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Properties;


@WebListener
public class RApiServletContextListener implements ServletContextListener
{
    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent)
    {
        ServletRegistration.Dynamic servlet = servletContextEvent.getServletContext().addServlet("RapiProxyServlet", RApiServlet.class);
        servlet.addMapping("/_rapi/*");
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent)
    {
        // pass
    }

    public static class RApiServlet extends HttpServlet
    {
        final ServletWrappingController proxy;

        public RApiServlet()
        {
            proxy = new ServletWrappingController();
        }

        @Override
        public void init() throws ServletException
        {
            String target = null;
            var moduleProperties = ModuleLoader.getInstance().getModule("immport").getModuleProperties();
            var moduleProperty = moduleProperties.get("proxyTargetUri");
            if (null != moduleProperty)
                target = StringUtils.trimToNull(moduleProperty.getEffectiveValue(ContainerManager.getRoot()));
            if (null==target)
                throw new NotFoundException();

            try
            {
                proxy.setServletClass(LabKeyAuthenticatedProxy.class);
                proxy.setServletName("_rapi");
                var properties = new Properties();
                properties.put("targetUri", target);
                proxy.setInitParameters(properties);
                proxy.afterPropertiesSet();
            }
            catch (Exception x)
            {
                throw new ServletException(x);
            }
        }

        @Override
        protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException
        {
            try
            {
                // init every time in case target has been updated, CONSIDER: listen for module variable change
                init();
                proxy.handleRequest(req,resp);
            }
            catch (ServletException|IOException x)
            {
                throw x;
            }
            catch (Exception x)
            {
                throw new ServletException(x);
            }
        }
    }
}


