' 
' Author: Prabhakaran
' Summary of last revision: $Id: csMyLibraryGridScreen.brs 11061 2014-12-29 15:09:03Z prabhakaran11 $
'
Function MyLibraryViewController() as Object

   if(m.screenWrapper = invalid) 
    screenFactory = screenFactorySharedInstance()
    screenWrapper = screenFactory.makeWrapper("roGridScreen")
    screenWrapper.screen.SetBreadcrumbEnabled(true)
    screenWrapper.screen.SetBreadcrumbText("Menu * ", "MyLibrary") 
    screenWrapper.screen.SetGridStyle("flat-portrait")
    screenWrapper.screen.SetDescriptionVisible(true)
    'screenWrapper.screen.SetUpBehaviorAtTopRow("exit")         
     
    libraryHandler=MyLibraryServiceHandler()
    libraryHandler.getLibrary(function()
         
         Logger().log(3, "MyLibrary json download success")
         
         end function,function() 
           
          Logger().log(1, "MyLibrary json download failed")
         end function)
         
    data=SessionStore().getLibraryData().Result
    'libCategories=getCategories(data)
    libCategories=getCategoriesByLoop(data)
    categoriesCount=libCategories.Count()
      
    Logger().log(5, "libCategories.Count() : ")
    ?categoriesCount  
    screenWrapper.GridRows=[]
    
    for i=0 to categoriesCount-1        
        
       
         rowList=getRowItems(data,libCategories[i])
        if rowList<> invalid and rowList.Count() > 0
                 
            screenWrapper.GridRows.Push(rowList)                 
        else
           
            Logger().log(1, "MyLibrary rowList : invalid"  ) 
        end if
    end for   
  
    
    screenWrapper.screen.SetupLists(categoriesCount)
    screenWrapper.screen.SetListNames(libCategories)
   
    for j=0 to categoriesCount-1
         screenWrapper.screen.SetContentList(j,screenWrapper.GridRows.GetEntry(j))    
    end for
    
    screenWrapper.addEventListener("onListItemFocused", Function(wrapper as object,screen as object,msg as object)
              
        Logger().log(5, "MyLibGridScreen onListItemFocused index : ")  
        
    End Function)
    
    screenWrapper.addEventListener("onListItemSelected", Function(wrapper as object,screen as object,msg as object)
        'take to springboardscreen
        row =msg.GetIndex()
        column=msg.GetData()
       
        Logger().log(5, "MyLibGridScreen listItemSelected row : ")
        
        video = getVideo(wrapper.GridRows,row,column)
        videoCategory =video.Category
        if  videoCategory ="Live TV"
            CommonConfig().showOneLineMessage()
            'showLiveTvScreen()
            liveTv=LiveTvViewController()
            CommonConfig().closeOneLineMessage()
            liveTv.show()
        else if videoCategory ="On Demand"
            'OnDemand Row Selection
            ''Show message while Loading next screen
            CommonConfig().showOneLineMessage()
            onDemandScreen = OnDemandViewController()
            CommonConfig().closeOneLineMessage()
            onDemandScreen.show()
             
        else
            detailScreen = DetailViewController(video,"Title",video.Title)
            detailScreen.showAndListen()
        end if        
        
    End Function)
    
    screenWrapper.addEventListener("onRemoteKeyPressed", Function(wrapper as object,screen as object,msg as object)
        index=msg.GetIndex()
       
        if index=10 then            
            menu = MenuView()
            menu.showAndListen() 
        end if
    End Function)
    
    screenWrapper.addEventListener("onScreenClosed", Function(wrapper as object,screen as object,msg as object)
        CommonConfig().removeFromHistory()
    End Function)
    
    screenWrapper.show = Function()    
        CommonConfig().addToHistory(CommonConfig().screens.myLibrary)
        m.showAndListen()    
    End Function
        m.screenWrapper = screenWrapper
    end if    
    return m.screenWrapper
        
End Function

'   getCategoryList()  as Object
'   Description : Provides array of item which may exists in json under attribute Category

'Function getCategoryList() As Object

  '  categoryList = [ "Recently watched", "Last channels", "Most Popular on demand","Favourites","WatchList","Live TV","On Demand","Kid Zone"]
  '  return categoryList

'End Function

Function getCategories(json as Object) as object

    categoryList=[]
    categories=json.Categories
    if categories <> invalid
        for each category in categories
            categoryList.Push(category.name)
        end for
    end if
    return categoryList
End Function

'   getRowItems(json as Object,category as dynamic)  as Object
'   Description : Provides array of item for given category if it exists in json else empty array

Function getRowItems(json as Object,category as dynamic) as Object
    
    videos=json.Videos
     
    Logger().log(5, "In getRowItems() Given category : ")
    contentList = []
    if videos <> invalid       
      
        for each video in videos
        
            if category = video.Category
                
                
                if video.Category = "series"
                    videoContent = CreateObject("roAssociativeArray")           
                    
                    videoContent.Title = video.Title
                    videoContent.TitleSeason = video.TitleSeason
                    videoContent.ShortDescriptionLine1 = video.Title
                    videoContent.SDPosterURL = video.Image
                    videoContent.HDPosterURL = video.Image
                    videoContent.EpisodeDetails = video.EpisodeDetails
                    videoContent.Category=video.Category
                    videoContent.Description = video.Description
                   
                    contentList.push( videoContent )
                else
                    videoContent = CreateObject("roAssociativeArray")           
                    
                    videoContent.Title = video.Title
                    videoContent.TitleSeason = video.TitleSeason
                    videoContent.ShortDescriptionLine1 = video.Title
                    videoContent.SDPosterURL = video.Image
                    videoContent.HDPosterURL = video.Image
                    'videoContent.StreamFormat= video.StreamFormat        
                    videoContent.Actors=getList(video.Actors)
                    videoContent.Stream ={Url:video.Url}
                    videoContent.Description=   video.Description
                    videoContent.Rating=   video.Rating
                    videoContent.StarRating=   video.StarRating
                    videoContent.ReleaseDate=   video.ReleaseDate
                    videoContent.Length=   video.Length
                    videoContent.Director=   video.Director
                    videoContent.Category=video.Category
                    
                   
                    contentList.push( videoContent )
                end if 
                
                
            end if
           
        end for
    end if 
    return contentList
End Function

'   getList()  as Object
'   Description : Provides array of item from given Object ie.) to get actors name alone as list from actors array which has more information


Function getList(arr as object) as Object
    list=[]
    if arr<> invalid
        for each item in arr
            list.Push(item.Name)
        end for
        return list
    end if

End Function

'   getCategoriesByLoop(json as Object)  as Object
'   Description : Provides array of categories from given json 

Function getCategoriesByLoop(json as Object) as object
   
    categoryList=[]
    videos=json.Videos
    
     if videos <> invalid       
      
        for each video in videos
            currentCategory=video.Category
            categoryExists=isExists(currentCategory,categoryList)
            if  categoryExists=false
                categoryList.Push(currentCategory)
            else
                 
                Logger().log(5, "category already exists")
            end if
        end for
    end if
    return categoryList
End Function

'   isExists(categoryName as dynamic,categoryList as object) as boolean
'   Description : Checks whether categoryName exists in given categoryList and returns true if exists otherwise false

Function isExists(categoryName as dynamic,categoryList as object) as boolean

    exists=false
    if  categoryList <> invalid and categoryList.Count() > 0
        for each category in categoryList
                
                if  categoryName=category
                    exists=true
                    exit for
                else
                    exists=false
                end if
        end for
    end if
    return exists
    
End Function

