' 
' Author: Pradeep
' Summary of last revision: $Id$
'
'Use this Class to handle the http services from csLoginScreen
'It forms the request object, gets the response, parses it and saves it in model
'Returns: {Object} - the service handler object
Function LoginServiceHandler() as object
    if(m.loginService = invalid)
        loginService =  CreateObject("roAssociativeArray")

        loginService.login = Function(loginSuccessCallback as object, loginErrorCallback as object)
            loginUrl = "http://mdw.prokarma.com/mockservice/serviceresponse.php?serviceurl=dd3fa5b6d73617619fc8a8447d6f6229"
                        
            'set your callbacks and parsers and pass this object
            'to HttpClient to receive the callbacks
            callbacks = CreateObject("roAssociativeArray")
            callbacks.success = loginSuccessCallback
            callbacks.error = loginErrorCallback
            callbacks.handleResponse = Function(data as object)
                'This function acts as the parser for this service response  
                if(data <> invalid)
                    'parse the data here and store it in model
                    parsedResponse = CreateObject("roAssociativeArray")
                    parsedResponse.result = data.result
                    
                    SessionStore().setUserData(parsedResponse)
                    'call the callback method inside the screen class
                    m.success()
                else
                    ?"invalid data"
                end if            
            end Function
            
            'get the instance of the service factory and make the service call
            requestFactory = ServiceFactory()
            loginRequest = requestFactory.createGetRequestAsync(loginUrl, callbacks)
            loginRequest.execute()
        end Function        
               
        m.loginService = loginService
    end if
    
    return m.loginService    
End Function