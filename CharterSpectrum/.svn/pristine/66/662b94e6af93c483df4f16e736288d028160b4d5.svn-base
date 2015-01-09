' 
' Author: Pradeep
' Summary of last revision: $Id$
'

Function SearchResultsViewController() as object
    screenFactoryInstance = screenFactorySharedInstance()
    searchResultsScreenWrapper = screenFactoryInstance.makeWrapper("roListScreen")
    searchResultsScreenWrapper.Screen.SetContent(getSearchContentList())
    
    searchResultsScreenWrapper.addEventListener("onScreenClosed", Function(wrapper as object,screen as object,msg as object)              
        return -1   'to terminate the event loop of Menu dialog after closed        
    End Function)
    
    return searchResultsScreenWrapper
End Function

Function getSearchContentList() as object
    contentList = [
        {
            Title: "Titanic",
            ID: "1",
            SDSmallIconUrl: "pkg:/images/breakfast_small.png",
            HDSmallIconUrl: "pkg:/images/breakfast_small.png",
            HDBackgroundImageUrl: "pkg:/images/breakfast_large.png",
            SDBackgroundImageUrl: "pkg:/images/breakfast_large.png",            
            ShortDescriptionLine1: "Breakfast Menu",
            ShortDescriptionLine2: "Select from our award winning offerings"
        },
        {
            Title: "Avatar",
            ID: "2",
            SDSmallIconUrl: "pkg:/images/lunch_small.png",
            HDSmallIconUrl: "pkg:/images/lunch_small.png",
            HDBackgroundImageUrl: "pkg:/images/lunch_large.png",
            SDBackgroundImageUrl: "pkg:/images/lunch_large.png",            
            ShortDescriptionLine1: "Lunch Menu",
            ShortDescriptionLine2: "Eating again already?"            
        },
        {
            Title: "Lord of the rings",
            ID: "3",
            SDSmallIconUrl: "pkg:/images/dinner_small.png",
            HDSmallIconUrl: "pkg:/images/dinner_small.png",
            HDBackgroundImageUrl: "pkg:/images/dinner_large.png",
            SDBackgroundImageUrl: "pkg:/images/dinner_large.png",            
            ShortDescriptionLine1: "Dinner Menu",
            ShortDescriptionLine2: "Chicken or Fish?"            
        },
        {
            Title: "The Mummy",
            ID: "4",
            SDSmallIconUrl: "pkg:/images/dessert_small.png",
            HDSmallIconUrl: "pkg:/images/dessert_small.png",
            HDBackgroundImageUrl: "pkg:/images/dessert_large.png",
            SDBackgroundImageUrl: "pkg:/images/dessert_large.png",            
            ShortDescriptionLine1: "Dessert Menu",
            ShortDescriptionLine2: "Something for your sweet tooth"            
        }
        {
            Title: "The life of PI",
            ID: "5",
            SDSmallIconUrl: "pkg:/images/about_small.png",
            HDSmallIconUrl: "pkg:/images/about_small.png",
            HDBackgroundImageUrl: "pkg:/images/about_large.png",
            SDBackgroundImageUrl: "pkg:/images/about_large.png",            
            ShortDescriptionLine1: "The Channel Diner",
            ShortDescriptionLine2: "Phone: 1-(111)-111-1111"            
        }
    ]
    return contentList
End Function