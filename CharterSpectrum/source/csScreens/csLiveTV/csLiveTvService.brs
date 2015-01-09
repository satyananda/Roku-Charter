' 
' Author: Prabhakar
' Summary of last revision: $Id$
'

Function LiveTvServiceHandler() as object
    if(m.myLiveTvService = invalid)
        myLiveTvService =  CreateObject("roAssociativeArray")

        myLiveTvService.getLiveTv = Function(LTVsuccessCallback as object, LTVerrorCallback as object)
            'LTVurl = "http://mdw.prokarma.com/mockservice/serviceresponse.php?serviceurl=ff316deb1297e313d0d24ce4f91be1c8"
            LTVurl = CommonConfig().getValue("liveTvurl")               
            'set your callbacks and parsers and pass this object
            'to HttpClient to receive the callbacks
            callbacks = CreateObject("roAssociativeArray")
            callbacks.success = LTVsuccessCallback
            callbacks.error = LTVerrorCallback
            callbacks.handleResponse = Function(data as object)
                'This function acts as the parser for this service response  
                if(data <> invalid)
                    'parse the data here and store it in model
                    parsedResponse = CreateObject("roAssociativeArray")
                    parsedResponse.Result = data
                     
                    'Logger().log(5, "liveTvServiceHandler() parsedResponse not invalid "+parsedResponse)
                    
                    SessionStore().setLiveTvData(parsedResponse)
                    
                    'call the callback method inside the screen class
                    m.success()
                else
                    
                    Logger().log(2, "invalid data")
                end if            
            end Function
            
            'get the instance of the service factory and make the service call
            requestFactory = ServiceFactory()
            myTvRequest = requestFactory.createGetRequestAsync(LTVurl, callbacks)
            myTvRequest.execute()
        end Function        
               
        m.myLiveTvService = myLiveTvService
    end if
    
    return m.myLiveTvService    
End Function