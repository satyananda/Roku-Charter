' 
' Author: Pradeep
' Summary of last revision: $Id$
'

'Use this class to store data that are needed throughtout the session
'returns {Object} - instance of the SessionStore to set and get values
Function SessionStore() as object
    if(m.dataStore = invalid)
        'Data structure to store the session values
        dataStore = CreateObject("roAssociativeArray")
        
        'set the loggedin user data
        dataStore.setUserData = Function(data as object) as void
            m.userData = data
        End Function
        
        'get the loggedin user data
        dataStore.getUserData = Function() as object
            return m.userData
        End Function
        
        'set the user's library channels data
        dataStore.setLibraryData = Function(data as object) as void
            m.libraryData = data
        End Function
        
        'get the user's library channels data
        dataStore.getLibraryData = Function() as object
            return m.libraryData
        End Function
        
        'set the user's live tv channels data
        dataStore.setLiveTvData = Function(data as object) as void
            m.liveTvData = data
        End Function
        
        'get the user's live tv channels data
        dataStore.getLiveTvData = Function() as object
            return m.liveTvData
        End Function
        
        'set the search results data for later use
        dataStore.setSearchResults = Function(data) as void
            m.searchResults = data
        End Function
        
        'get the search results data stored earlier
        dataStore.getSearchResults = Function() as object
            return m.searchResults
        End Function
        
        dataStore.setSerialsData = Function(data as object) as object
            m.episodesData = data
        End Function
        
        dataStore.getSerialsData = Function() as object
            return m.episodesData
        End Function
        
        m.dataStore = dataStore
    end if
        
    return m.dataStore
End Function