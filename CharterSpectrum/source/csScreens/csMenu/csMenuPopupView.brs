' 
' Author: Pradeep
' Summary of last revision: $Id: csMenuPopupView.brs 11188 2015-01-07 14:05:13Z tsatyananda2605 $
'

Function MenuView() as object
    'if(m.menuPopup = invalid)        
        screenFactoryInstance = screenFactorySharedInstance()
        
        'Logger().log(5,  "Current Screen index is " + CommonConfig().getCurrentScreen())
        
        menuPopup = screenFactoryInstance.makeWrapper("roImageCanvas")       
        menuPopup.draw = drawScreen 
        menuPopup.selectedMenuIndex = CommonConfig().getCurrentScreen()
        menuPopup.menuItemArts = ["search.PNG", "my_library.PNG", "live_tv.PNG", "vod.PNG", "kid_zone.PNG"]
        menuPopup.addEventListener("onRemoteKeyPressed", Function(wrapper as object, screen as object, msg as object)
           
           index =msg.GetIndex()
            'event listener for any menu items
                if (index = 0) 'Back
                    screen.Close()
                    return 1
                else if (index = 5) ' Right
                    'move the selection in a cyclic manner towards right
                    if(wrapper.selectedMenuIndex = wrapper.menuItemArts.count())
                        wrapper.selectedMenuIndex = 1
                    else
                        wrapper.selectedMenuIndex = wrapper.selectedMenuIndex + 1
                    end if        
                else if (index = 4) ' Left
                    'move the selection in a cyclic manner towards left
                    if(wrapper.selectedMenuIndex = 1)
                        wrapper.selectedMenuIndex = 5
                    else
                        wrapper.selectedMenuIndex = wrapper.selectedMenuIndex - 1
                    end if
                else if (index = 6) ' OK
                    'click the highlighted menu and take the user to corresponding screen
                    handleMenuClick(wrapper)          
                endif  
                'redraw the canvas to update the highlited menu item
                wrapper.draw(wrapper, true)              
                        
        End Function)        
        
        'draw the UI items to the canvas and show it in the screen
        menuPopup.draw(menuPopup, false)
        'menuPopup.showAndListen()
        
        m.menuPopup = menuPopup
    'end if
    
    return m.menuPopup    
End Function

'Use this function to show the menu popup over any screen
Function drawScreen(menupopup as object, updateSelection as boolean)
    
    canvas = menupopup.screen
    'variable declarations
    canvasRect = canvas.GetCanvasRect()
    selectedMenuIndex = menupopup.selectedMenuIndex
    menuItemId = 10
    menuItemWidth = 75
    menuItemHeight = 75
    paddingOffset = 50
    
    'array of urls for the face image of menu items.
    menuItemArts = menupopup.menuItemArts
    
    'Popup width should wrap its contents, so calculating popup width
    'based on the width and horizontal padding of the menu items.
    dialogRect = {w: (menuItemWidth * menuItemArts.Count()) + (paddingOffset * (menuItemArts.Count() + 1)) , h: 150}
    dialogRect.x = int((canvasRect.w - dialogRect.w) / 2)
    dialogRect.y = int((canvasRect.h - dialogRect.h) / 2)
    
    'icon used to highlight the selected menu item.
    menuHighlight = {
        url: "pkg:/assets/button.png"
        TargetRect: {w: menuItemWidth, h: menuItemHeight}
    }
    menuHighlight.TargetRect.x = int (dialogRect.x + paddingoffset)
    menuHighlight.TargetRect.y = int((canvasRect.h - menuHighlight.TargetRect.h) / 2)
           
    'array of menu items
    menuItems = []    
    menuItems.Push({
        id: menuItemId
        url: "pkg:/assets/dialog.png"
        TargetRect: dialogRect
    })
    
    itemPos = 1
    'iterate the menuItemArts array and prepare objects with complete details to draw a menu item.
    for each item in menuItemArts
        menuItemId = menuItemId + 1
        
        'dimensions for a menu item
        menuItemRect = {w: menuItemWidth, h: menuItemHeight}
        menuItemRect.x = int (dialogRect.x + (paddingoffset * itemPos) + (menuItemRect.w * (itempos-1)))
        menuItemRect.y = int((canvasRect.h - menuItemRect.h) / 2)
        
        menuItems.Push({
            id: menuItemId
            url: "pkg:/assets/" + item
            TargetRect: menuItemRect
        })

        itemPos = itemPos + 1
    end for
        
    'clear the canvas layer and set the new position for the highlight icon
    canvas.ClearLayer(0)
    canvas.ClearLayer(1)
    canvas.ClearLayer(2)
    
    if(updateSelection = false)
        'set a translucent background as the bottom layer
        'draw this layer only once while showing the menu.
        'it shouldn't be drawn during highlighting the items by next and prev buttons 
        canvas.SetLayer(0, { Color: "#a0000000", CompositionMode: "Source_Over" })
    end if
    
    'change the highlight from previous item to current selected item
     menuHighlight.TargetRect = {w: menuItemWidth, h: menuItemHeight}
     menuHighlight.TargetRect.x = menuItems[selectedMenuIndex].TargetRect.x
     menuHighlight.TargetRect.y = menuItems[selectedMenuIndex].TargetRect.y
    
    'set the highlight button as the first layer
    'set the menu items as second layer.
    'first and second layers can be swapped but it depends on the type of highlight image used.
    canvas.SetLayer(1, menuItems)
    canvas.SetLayer(2, menuHighlight)    
        
End Function

'Use this function to handle the click event on the menu. 
'Params: menuIndex - the index of the selected menu item
Function handleMenuClick(canvas as object)
    menuIndex = canvas.selectedMenuIndex
    canvas.Screen.close()
    if(menuIndex = 1)
        searchView = SearchViewController()
        searchView.show()
    else if(menuIndex = 2)   
        CommonConfig().showOneLineMessage()     
        'showMyLibGridScreen()
        myLibrary = MyLibraryViewController()
        CommonConfig().closeOneLineMessage()
        myLibrary.show()
    else if(menuIndex = 3)
        CommonConfig().showOneLineMessage()
        'showLiveTvScreen()
        liveTv = LiveTvViewController()
        CommonConfig().closeOneLineMessage()
        liveTv.show()
    else if(menuIndex = 4)
          CommonConfig().showOneLineMessage()
        'OnDemand Screen
        onDemandScreen = OnDemandViewController()
        CommonConfig().closeOneLineMessage()        
        onDemandScreen.show()
    else if(menuIndex = 5)
        'showKidzoneScreen()
    end if
    
End Function