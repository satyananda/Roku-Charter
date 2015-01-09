' 
' Author: Pradeep
' Summary of last revision: $Id: Logger.brs 11188 2015-01-07 14:05:13Z tsatyananda2605 $
'
Function Logger()
    if m.loggerSharedInstance = invalid
        loggerSharedInstance = CreateObject("roAssociativeArray")
        
        loggerSharedInstance.logLevel = 1
        
        level = CreateObject("roAssociativeArray")
        level.error = 1
        level.warning = 2
        level.info = 3
        level.debug = 4
        level.trace = 5
        
        loggerSharedInstance.level = level
        
        loggerSharedInstance.log = Function(level as integer, message as object)
            if level <= m.logLevel
                ? m.convertLevelToString(level) + " : " + message 
            end if
        End Function
        
        loggerSharedInstance.setLogLevel = Function(level as integer)
            m.logLevel = level
        End Function
        
        loggerSharedInstance.convertLevelToString = Function(level as integer)
            if level = 1 return "Error"
            if level = 2 return "Warning"
            if level = 3 return "Info"
            if level = 4 return "Debug"
            if level = 5 return "Trace"
        End Function
        
        m.loggerSharedInstance = loggerSharedInstance
    end if
    
    return m.loggerSharedInstance
End Function