' 
' Author: Pradeep
' Summary of last revision: $Id$
'

Function SearchServiceHandler() as object
    if(m.searchService = invalid)
        searchService =  CreateObject("roAssociativeArray")

        searchService.getSearchResults = Function(wrapper as object, searchSuccessCallback as object, searchErrorCallback as object)
            searchUrl = "http://mdw.prokarma.com/mockservice/serviceresponse.php?serviceurl=7cb02d50fd1fe21b72c31a9d19209056"
                        
            'set your callbacks and parsers and pass this object
            'to HttpClient to receive the callbacks
            callbacks = CreateObject("roAssociativeArray")
            callbacks.success = searchSuccessCallback
            callbacks.error = searchErrorCallback
            callbacks.wrapper = wrapper
            callbacks.handleResponse = Function(data as object)
                'This function acts as the parser for this service response  
                if(data <> invalid)
                    'parse the data here and store it in model
                    parsedResponse = CreateObject("roAssociativeArray")
                    parsedResponse.result = data.result
                    
                    SessionStore().setSearchResults(parsedResponse)
                    'call the callback method inside the screen class
                    m.success(m.wrapper)
                else
                    Logger().log(1, "invalid data")
                end if            
            end Function
            
            'get the instance of the service factory and make the service call
            requestFactory = ServiceFactory()
            searchRequest = requestFactory.createGetRequestAsync(searchUrl, callbacks)
            searchRequest.execute()
        end Function        
               
        m.searchService = searchService
    end if
    
    return m.searchService    
End Function