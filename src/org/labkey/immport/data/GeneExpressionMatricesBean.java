package org.labkey.immport.data;

/**
 * Created by Marty on 3/6/2016.
 */
public class GeneExpressionMatricesBean implements FileBean
{
    String folder;
    String download_link;

    public String getFolder()
    {
        return folder;
    }

    public void setFolder(String folder)
    {
        this.folder = folder;
    }

    public String getDownload_Link()
    {
        return download_link;
    }

    public void setDownload_Link(String download_link)
    {
        this.download_link = download_link;
    }

    public String getFileName()
    {
        return this.download_link;
    }

    public String getStudy() { return this.folder; }

}
