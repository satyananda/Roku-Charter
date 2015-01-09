' 
' Author: Prabhakar
' Summary of last revision: $Id$
'

Function LiveTvViewController() as Object
   
   if(m.liveTvScreenWrapper = invalid)
    screenFactory = screenFactorySharedInstance()
    liveTvScreenWrapper = screenFactory.makeWrapper("roGridScreen")
      
    liveTvScreenWrapper.screen.SetBreadcrumbEnabled(true)
    liveTvScreenWrapper.screen.SetBreadcrumbText("Menu * ", "Live TV") 
    liveTvScreenWrapper.screen.SetGridStyle("flat-portrait")
    liveTvScreenWrapper.screen.SetDescriptionVisible(true)
    'liveTvScreenWrapper.screen.SetUpBehaviorAtTopRow("exit")  
        
    liveTvHandler=LiveTvServiceHandler()
    liveTvHandler.getLiveTv(function()
         Logger().log(3, "LiveTv json download success")
         
         end function,function() 
          Logger().log(1, "LiveTv json download failed")
         end function)
   
    data=SessionStore().getLiveTvData().Result
    'tvCategories=getLiveTvCategories()
    tvCategories=getCategoriesByLoop(data)
    categoriesCount=tvCategories.Count()
   
    liveTvScreenWrapper.GridRows=[]
    for i=0 to categoriesCount-1
        

        
        rowList=getRowItems(data,tvCategories[i])
        if rowList<> invalid and rowList.Count() > 0                 
            liveTvScreenWrapper.GridRows.Push(rowList)                 
        else
         
            Logger().log(2,  "LiveTv rowList : invalid" ) 
        end if
        
    end for  
    
    liveTvScreenWrapper.screen.SetupLists(categoriesCount)
    liveTvScreenWrapper.screen.SetListNames(tvCategories)
   
    for j=0 to categoriesCount-1
         liveTvScreenWrapper.screen.SetContentList(j,liveTvScreenWrapper.GridRows.GetEntry(j))    
    end for
    
    liveTvScreenWrapper.addEventListener("onListItemFocused", Function(wrapper as object,screen as object,msg as object)
           
        Logger().log(5,  "liveTvGridScreen onListItemFocused index : ")     
    End Function)
    
    liveTvScreenWrapper.addEventListener("onListItemSelected", Function(wrapper as object,screen as object,msg as object)
       
        row =msg.GetIndex()
        column=msg.GetData()
         
        
        'take to springboardscreen
        'video=getLiveTvVideo(wrapper.GridRows,row,column)
        video=getVideo(wrapper.GridRows,row,column)
        detailScreen = DetailViewController(video,"Title",video.Title)
        detailScreen.showAndListen()
    End Function)
    
    liveTvScreenWrapper.addEventListener("onRemoteKeyPressed", Function(wrapper as object,screen as object,msg as object)
        index=msg.GetIndex()
        
        if index=10 then
            
            menu = MenuView()
            menu.showAndListen() 
            
        end if
    End Function)
       
    liveTvScreenWrapper.addEventListener("onScreenClosed", Function(wrapper as object,screen as object,msg as object)
        CommonConfig().removeFromHistory()
    End Function)
    
    liveTvScreenWrapper.show = Function()
        CommonConfig().addToHistory(CommonConfig().screens.liveTv)
        m.showAndListen()    
    End Function
        
        m.liveTvScreenWrapper = liveTvScreenWrapper
    end if    
    return m.liveTvScreenWrapper
End Function

Function getLiveTvCategories() As Object

    categoryList = [ "Network", "Family & Education", "Kid Zone","Lifestyles","Movies","Music","News & Weather","Premium","Sports","Uncategorized"]
    return categoryList

End Function
