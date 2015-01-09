' 
' Author: Satyanand
' Summary of last revision: $Id: csFacade.brs 11188 2015-01-07 14:05:13Z tsatyananda2605 $
'

'************ Facade Screen*******
'This will be bottom screen of all the screen
'to avoid having an empty screen stack have this Facade screen
'This will always remains on the stack until your app is ready to exit
function IntializeFacadeScreen()
    
    facade = CreateObject("roParagraphScreen")
    facade.AddParagraph("Retrieving...")
    facade.Show()
    
    navigateToHome()      
end function


'************ Home Navigation*******
function navigateToHome() as void
    
    registryInstance = registryManagerSharedInstance()
    
    'Remove this deletion code for AutoLogin
    registryInstance.delete("Username")
    username = registryInstance.get("Username")
    
    Logger().log(5,"USERNAME")

    if (username <> invalid) 
        showMyLibGridScreen()
    else
        loginScreen = LoginViewController()
        loginScreen.show()
    end if
    
end function