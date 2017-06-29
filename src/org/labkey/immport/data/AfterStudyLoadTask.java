package org.labkey.immport.data;

import org.apache.xmlbeans.XmlException;
import org.jetbrains.annotations.NotNull;
import org.labkey.api.data.Container;
import org.labkey.api.di.TaskRefTask;
import org.labkey.api.pipeline.PipelineJob;
import org.labkey.api.pipeline.PipelineJobException;
import org.labkey.api.pipeline.RecordedActionSet;
import org.labkey.api.security.User;
import org.labkey.api.services.ServiceRegistry;
import org.labkey.api.study.StudyService;
import org.labkey.api.writer.ContainerUser;

import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * Created by matthew on 6/21/17.
 */
public class AfterStudyLoadTask implements TaskRefTask
{
    Container c = null;
    User user = null;

    @Override
    public RecordedActionSet run(@NotNull PipelineJob job) throws PipelineJobException
    {
        ServiceRegistry.get(StudyService.class).hideEmptyDatasets(c,user);
        return new RecordedActionSet();
    }

    @Override
    public List<String> getRequiredSettings()
    {
        return Collections.emptyList();
    }

    @Override
    public void setSettings(Map<String, String> settings) throws XmlException
    {

    }

    @Override
    public void setContainerUser(ContainerUser containerUser)
    {
        c = containerUser.getContainer();
        user = containerUser.getUser();
    }
}
