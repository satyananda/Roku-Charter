' 
' Author: Pradeep
' Summary of last revision: $Id: csHttpClient.brs 11188 2015-01-07 14:05:13Z tsatyananda2605 $
'

'Use this Class to get the service factory object which has properties to 
'establish connection with the server and to make service calls
'Returns: {Object} - the service factory object
Function ServiceFactory() as object
    'check if the Factory instance is already available else create it
    if (m.requestFactory = invalid)
        requestFactory = CreateObject("roAssociativeArray")
        requestFactory.timeOutDuration = 20000
        
        'override the default timout for any service call.
        'Request will be cancelled if the timeout is exceeded
        requestFactory.setTimeOut = Function(duration as integer) as Void
             requestFactory.timeOutDuration = duration
        End Function
        
        'Use this method to make a synchronous GET call
        requestFactory.createGetRequest = Function(remoteUrl as string) as object
            
            requestObject = CreateObject("roUrlTransfer")
            requestObject.SetMessagePort(CreateObject("roMessagePort"))
            requestObject.SetUrl(remoteUrl)
            
            getSyncRequest = CreateObject("roAssociativeArray")
            getSyncRequest.httpObject = requestObject  
            'method to make the service call and retrieve the response          
            getSyncRequest.execute = Function()
                return m.httpObject.GetToString()
            End Function
            
            return getSyncRequest
        End Function
        
        'Use this method to make an asynchronous GET call
        requestFactory.createGetRequestAsync = Function(remoteUrl as string, callbacks as object) as object
            requestObject = CreateObject("roUrlTransfer")
            requestObject.SetMessagePort(CreateObject("roMessagePort"))
           ' requestObject.timeOutDuration = m.requestFactory.timeOutDuration
            requestObject.SetUrl(remoteUrl)
            
            'timer to set the timeout for every service. 
            'If the response is not received within the specific time period, the async service will be cancelled
            timer=createobject("roTimeSpan")
            timer.mark()
            
            getAsyncRequest = CreateObject("roAssociativeArray")
            getAsyncRequest.httpObject = requestObject
            getAsyncRequest.callbacks = callbacks 
            'method to make the service call and retrieve the response  
            getAsyncRequest.execute = Function()
                if (m.httpObject.AsyncGetToString())
                    while(true)
                        msg = wait(0, m.httpObject.getMessagePort())
                        'check if the event is of type roUrlEvent.
                        if (type(msg) = "roUrlEvent")
                            code = msg.GetResponseCode()
                            'check for success status code 
                            if (code = 200)
                                'send back the response in the form of roAssociativeArray
                                m.callbacks.handleResponse(ParseJSON(msg.GetString()))
                                exit while
                            endif
                        else if (event = invalid)
                            m.httpObject.AsyncCancel()
                            exit while
                        endif
                        
                        'cancel the request if the server didn't respond with the configured time.
                        if timer.totalmilliseconds() > m.httpObject.timeOutDuration then
                            ?"timeout exceeded"
                            exit while
                        end if
                    end while
                endif                
            End Function
            return getAsyncRequest
        End Function
        m.requestFactory = requestFactory
    end if   
    
    return m.requestFactory
End Function

'Use this function to post data to server using POST method
'Returns: {Object} - response object in the form of JSON if SUCCESS or invalid if FAILURE
Function postData(request as object, port as object, payload as object) as object
    if (request.AsyncPostFromString(payload))
       return getResponse(request, port)
    endif
    
    return invalid
End Function

'Use this function to generate the URL for any ervices used in the app.
'Params: endPoint - the key to pick the actual endpoint of the service API
'Returns: {String} - the complete url including the domain and endpoint
Function generateUrl(endPoint as string, setToken as boolean) as string
    if(getConfig() = invalid)        
        return invalid        
    end if    
    
    'generate the complete url by concatinating the domain and the endpoint
    requestUrl = getConfig().host + endPoint
        
    'set the authorization token as query string, if necessary.
    if (setToken)
        'get the token from the registry 
        token = getToken()
        requestUrl = requestUrl + "?token=" + token 
    end if
    
    return requestUrl
End Function

'Use this function to read and return the authorization token stored in registry
'Returns: {String} - the token to authorize the API calls
Function getToken() as string
    return getRegistryData("authToken")
End Function

'Use this function to load the config/properties json file and read the values.
Function getConfig() as dynamic
    
    if(m.properties = invalid)
       
        Logger().log(3, "Loading Config file")
        jsonAsString = ReadAsciiFile("pkg:/source/properties/config.json")
        m.properties = ParseJSON(jsonAsString)
    end if
    
    
    if(m.properties <> invalid)          
        return m.properties
    else
        Logger().log(2, "invalid JSON... The App might have deployed using Eclipse. Try side-loading the package from a browser.")
    End if
    
    return invalid
End Function