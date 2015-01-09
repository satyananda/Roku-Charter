' 
' Author: Satyanand
' Summary of last revision: $Id$
'
Function onDemandServiceHandler() as object
    if(m.onDemandService = invalid)
        onDemandService =  CreateObject("roAssociativeArray")

        onDemandService.getOnDemand = Function(onDemand_successCallback as object, onDemand_errorCallback as object)
            'ONDemandurl = "http://mdw.prokarma.com/mockservice/serviceresponse.php?serviceurl=93d69049851aaf3dde9c5727f0eb7b5a"
            ONDemandurl = CommonConfig().getValue("onDemandurl")                 
            'set your callbacks and parsers and pass this object
            'to HttpClient to receive the callbacks
            callbacks = CreateObject("roAssociativeArray")
            callbacks.success = onDemand_successCallback
            callbacks.error = onDemand_errorCallback
            callbacks.handleResponse = Function(data as object)
                'This function acts as the parser for this service response  
                if(data <> invalid)
                    'parse the data here and store it in model
                    parsedResponse = CreateObject("roAssociativeArray")
                    parsedResponse = data
                    
                    '?"onDemandResponse:";parsedResponse
                    
                    SessionStore().setSerialsData(parsedResponse)
                    
                    'call the callback method inside the screen class
                    m.success()
                else
                    Logger().log(5, "invalid data")
                end if            
            end Function
            
            'get the instance of the service factory and make the service call
            requestFactory = ServiceFactory()
            myLibRequest = requestFactory.createGetRequestAsync(ONDemandurl, callbacks)
            myLibRequest.execute()
        end Function        
               
        m.onDemandService = onDemandService
    end if
    
    return m.onDemandService    
End Function