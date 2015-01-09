' 
' Author: Prabhakar
' Summary of last revision: $Id$
'
Function MyLibraryServiceHandler() as object
    if(m.myLibService = invalid)
        myLibService =  CreateObject("roAssociativeArray")

        myLibService.getLibrary = Function(MYLIBsuccesscallback as object, MYLIBerrorcallback as object)
            'MYLIBurl = "http://mdw.prokarma.com/mockservice/serviceresponse.php?serviceurl=fa9b460d704866fdbd4520d50c721164"
            MYLIBurl = CommonConfig().getValue("myLibraryurl")    
              
            'set your callbacks and parsers and pass this object
            'to HttpClient to receive the callbacks
            callbacks = CreateObject("roAssociativeArray")
            callbacks.success = MYLIBsuccesscallback
            callbacks.error = MYLIBerrorcallback
            callbacks.handleResponse = Function(data as object)
                'This function acts as the parser for this service response  
                if(data <> invalid)
                    'parse the data here and store it in model
                    parsedResponse = CreateObject("roAssociativeArray")
                    parsedResponse.Result = data
                     
                    'Logger().log(5, "LibraryServiceHandler() parsedResponse not invalid "+ parsedResponse)
                    
                    SessionStore().setLibraryData(parsedResponse)
                    
                    'call the callback method inside the screen class
                    m.success()
                else
                    
                    Logger().log(1, "invalid data")
                end if            
            end Function
            
            'get the instance of the service factory and make the service call
            requestFactory = ServiceFactory()
            myLibRequest = requestFactory.createGetRequestAsync(MYLIBurl, callbacks)
            myLibRequest.execute()
        end Function        
               
        m.myLibService = myLibService
    end if
    
    return m.myLibService    
End Function