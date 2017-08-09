package org.labkey.immport;

import org.labkey.api.admin.FolderImporter;
import org.labkey.api.admin.FolderImporterFactory;

public class DifferentialExpressionImporterFactory implements FolderImporterFactory
{
    @Override
    public FolderImporter create()
    {
        return null;
    }

    @Override
    public int getPriority()
    {
        return 100;
    }
}
