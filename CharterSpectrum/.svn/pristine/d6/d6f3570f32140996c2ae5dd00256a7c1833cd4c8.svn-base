' 
' Author: Satyanand
' Summary of last revision: $Id$
'

'******* Use following image dimensions from service*************
'If the ContentType is episode, the album art dimensions are:
'SD: 180 x 122
'HD: 264 x 198

'If the ContentType is any other value, the album art dimensions are:
'SD: 112 x 142
'HD: 148 x 212

'****************************************** 
'This Method will details screen
'Param: selectedItem will be particular moview/episode
'Param: menuTitle will be Breadcum title
'Param: menuSubTitle will be Breadcum subtitle

Function DetailViewController(selectedItem as object,menuTitle = "Screen Title:", menuSubTitle = "Avatar") as object
        
    screenFactoryInstance = screenFactorySharedInstance()
    springboardWrapper = screenFactoryInstance.makeWrapper("roSpringboardScreen")
    
    ''Title and SubTitles on overhang
    springboardWrapper.Screen.SetBreadcrumbText(menuTitle, menuSubTitle)
    
    ''DetailScreen Style: movie/audio/video/generic set any one accordingly
    springboardWrapper.Screen.SetDescriptionStyle("movie")   
   
   ''Add Buttons
    springboardWrapper.Screen.AddButton(1, "Play")
    springboardWrapper.Screen.AddButton(2, "Pay")
    springboardWrapper.Screen.AddButton(3, "Add to WatchList")
    
    springboardWrapper.SelectedItem = selectedItem
    
    ''Set the Content for Screen   
    springboardWrapper.Screen.SetContent(selectedItem)
    
    springboardWrapper.addEventListener("onButtonPressed", Function(wrapper as object,screen as object,msg as object)
           
            index = msg.GetIndex()
            if index = 1 then
               ''Play Button
               videoContent = wrapper.SelectedItem
               
               if videoContent<> invalid
                 videoScreen = VideoViewController(videoContent)
                 videoScreen.showAndListen()
               else 
                 messageDialog = ShowMessageDialog("Message","Unable to Play")
                 messageDialog.showAndListen()
               end if 
               
             else  if index = 2 then
                ''Pay Button
                
             else if index = 3 then
                ''Add To WishList
             
            end if        
    End Function)
       
    return springboardWrapper
    
End Function
