package fr.opensagres.xdocreport.remoting.resources.services.ws.server;

import java.util.List;

import fr.opensagres.xdocreport.remoting.resources.domain.BinaryDataIn;
import fr.opensagres.xdocreport.remoting.resources.domain.Filter;
import fr.opensagres.xdocreport.remoting.resources.domain.Resource;
import fr.opensagres.xdocreport.remoting.resources.services.DelegateResourcesService;
import fr.opensagres.xdocreport.remoting.resources.services.ws.JAXWSResourcesService;

public abstract class JAXWSResourcesServiceImpl
    extends DelegateResourcesService
    implements JAXWSResourcesService
{

    @Override
    public String getName()
    {
        return super.getName();
    }

    @Override
    public Resource getRoot()
    {
        return super.getRoot();
    }

    @Override
    public Resource getRoot( Filter filter )
    {
        return super.getRoot( filter );
    }

    @Override
    public byte[] download( String resourceId )
    {
        return super.download( resourceId );
    }

    @Override
    public List<byte[]> download( List<String> resourceIds )
    {
        return super.download( resourceIds );
    }

    @Override
    public void upload( BinaryDataIn dataIn )
    {
        super.upload( dataIn );
    }
}
