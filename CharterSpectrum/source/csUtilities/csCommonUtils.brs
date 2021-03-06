' 
' Author: Pradeep
' Summary of last revision: $Id$
'
'Use this Class to maintain and common functions or values that are used across the app.
'Returns {Object} - The instance of the CommonConfig class
Function CommonConfig() as object
    if(m.common = invalid)
        common = CreateObject("roAssociativeArray")
        
        'screens which can be navigated through menu popup
        'numbers are given based on the order in which the menu icons are arranged inside the popup
        common.screens = {
            search : 1,
            myLibrary : 2,
            liveTv : 3,
            onDemand : 4,
            kidZone : 5
        }
        
        'Array to hold the history of screens visited
        common.historyStack = []
        
        'While a screen is displayed, it should be added to the history
        common.addToHistory = Function(screen as object)
            m.historyStack.Push(screen)
        End Function
        
        'While a screen is closed, it should be removed from the history
        common.removeFromHistory = Function()            
            m.historyStack.Pop()
        End Function
        
        'returns the screen on top of the history stack
        common.getCurrentScreen = Function() as object
            if(m.historyStack.Count() > 0)
                return m.historyStack.GetEntry(m.historyStack.Count()-1)
            end if
            return invalid    
        End Function
        
        ''This will shows loading while screen is loading
        common.showOneLineMessage = Function() as void
            
            m.oneLineMessageDialog  = CreateObject("roOneLineDialog")
            ''set the text of the dialog
            m.oneLineMessageDialog .SetTitle(CommonConfig().getValue("pleasewait"))
            m.oneLineMessageDialog .ShowBusyAnimation()
            m.oneLineMessageDialog .Show()
            
        End Function
        
        ''Removing loading once screen loaded
        common.closeOneLineMessage = Function() as void
            if m.oneLineMessageDialog <> invalid
                m.oneLineMessageDialog.close()
            end if
        End Function
        
        common.value = {
            pleasewait : "Please wait...",
            myLibraryurl : "http://mdw.prokarma.com/mockservice/serviceresponse.php?serviceurl=fa9b460d704866fdbd4520d50c721164",
            liveTvurl : "http://mdw.prokarma.com/mockservice/serviceresponse.php?serviceurl=ff316deb1297e313d0d24ce4f91be1c8",
            onDemandurl :"http://mdw.prokarma.com/mockservice/serviceresponse.php?serviceurl=93d69049851aaf3dde9c5727f0eb7b5a"
        }
        
        common.getValue = Function(key as string) as object
       
            if(m.value <> invalid)
                return m.value.Lookup(key)
            end if
            return invalid    
        End Function
       
        
        m.common = common
    end if
    return m.common
end Function