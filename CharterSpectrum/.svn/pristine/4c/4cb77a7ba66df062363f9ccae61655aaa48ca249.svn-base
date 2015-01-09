' 
' Author: Prabhakaran
' Summary of last revision: $Id$
'
Function VideoViewController(video as object) as Object

    
    screenFactory = screenFactorySharedInstance() 
    videoScreenWrapper = screenFactory.makeWrapper("roVideoScreen")
    videoScreenWrapper.screen.SetContent(video)
  
    videoScreenWrapper.addEventListener("onPlaybackPosition", Function(wrapper as object,screen as object,msg as object)
       
        Logger().log(5, " videoScreenEventListener onPlaybackPosition : " )    
        
    End Function)
    
    videoScreenWrapper.addEventListener("onRemoteKeyPressed", Function(wrapper as object,screen as object,msg as object)
        
          
         Logger().log(5, " videoScreenEventListener onRemoteKeyPressed ")
       
    End Function)
    '
     videoScreenWrapper.addEventListener("onStreamStarted", Function(wrapper as object,screen as object,msg as object)
      
        Logger().log(5, " videoScreenEventListener onStreamStarted  ")
       
    End Function)   
    
    
    return videoScreenWrapper
    
End Function



Function getVideo(content as Object,row as integer,column as integer) as object
    
    selectedRow=content.GetEntry(row)
    selectedVideo= selectedRow.GetEntry(column)      
    
    return selectedVideo
End Function
