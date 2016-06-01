package org.labkey.immport.view;

import org.labkey.api.data.Container;
import org.labkey.api.view.ActionURL;
import org.labkey.api.view.JspView;
import org.labkey.api.view.ViewContext;
import org.labkey.immport.ImmPortController;

/**
 * Created by matthew on 4/22/15.
 */

public class DataFinderWebPart extends JspView
{
    boolean isAutoResize = false;
    Integer groupId;

    public boolean isAutoResize()
    {
        return isAutoResize;
    }

    public void setIsAutoResize(boolean isAutoResize)
    {
        this.isAutoResize = isAutoResize;
    }

    public Integer getGroupId()
    {
        return groupId;
    }

    public void setGroupId(Integer groupId)
    {
        this.groupId = groupId;
    }

    public DataFinderWebPart(Container c, ImmPortController.SentGroupForm form)
    {
        super("/org/labkey/immport/view/dataFinder.jsp");
        setTitle("Data Finder");
        setTitleHref(new ActionURL(ImmPortController.DataFinderAction.class, c));

        if (form != null)
            setGroupId(form.getGroupId());
    }
    public DataFinderWebPart(ViewContext v)
    {
        this(v.getContainer(), null);
    }

    @Override
    public void setIsOnlyWebPartOnPage(boolean b)
    {
        setIsAutoResize(b);
    }
}
