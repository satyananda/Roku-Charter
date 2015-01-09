' 
' Author: Satyanand
' Summary of last revision: $Id: csLoginViewController.brs 11188 2015-01-07 14:05:13Z tsatyananda2605 $
'

'*****Login Screen******
Function LoginViewController() as object
    screenFactoryInstance = screenFactorySharedInstance()
    keyboardWrapper = screenFactoryInstance.makeWrapper("roKeyboardScreen")
    
    keyboardWrapper.Screen.SetTitle("Login")
    keyboardWrapper.Screen.SetDisplayText("Please Enter Your Charter Email")
   
   'Secure Text
    keyboardWrapper.Screen.setSecureText(false)
      
   'Add Buttons
    keyboardWrapper.Screen.AddButton(1, "Done")
    keyboardWrapper.Screen.AddButton(2, "Secure Help")
    keyboardWrapper.Screen.AddButton(3, "Back")
    
        
    keyboardWrapper.addEventListener("onButtonPressed", Function(wrapper as object,screen as object,msg as object)
            
            index=msg.GetIndex()
            if index = 1 then
                username = screen.GetText()
                
                
                Logger().log(5, "Email:")
                validatorstring = "^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}" +"\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\" + ".)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$"
            
                validatorObject = CreateObject("roRegex",validatorstring, "i")
                
                ''Enable the AND Condition for Email Validation
                if username <> "" 'AND (validatorObject.IsMatch(username))  
                  ''valid Email proceed
                  ''Save username for in Registry for Auto Login 
                    registryInstance = registryManagerSharedInstance()
                    registryInstance.set("Username",username)
                    
                    ''once Login close login and go to next page 
                    screen.close()
                    
                    ''Show message while Loading next screen
                    CommonConfig().showOneLineMessage()

                    ''Next screen navigation
                    myLibrary = MyLibraryViewController()
                    CommonConfig().closeOneLineMessage()  
                    myLibrary.show()
                                    
                   ''code snippet to make the login service call 
                   'loginServiceCall = LoginServiceHandler()
                   'loginServiceCall.login(Function()
                       '?SessionStore().getUserData().result
                   'End function, Function()
                       '?"Error..."
                   'End function)
                   
                else 
                  ''Not a Valid Email
                  messageDialog = ShowMessageDialog()  
                  messageDialog.showAndListen() 
            
                end if
                
             else if index = 2 then
                'Secure Help
                'screen.Close()
                
             else  if index = 0 then
                'Back
                screen.Close()   
                             
            end if        
    End Function)
        
    keyboardWrapper.show = Function()    
        
        m.showAndListen()
    End Function
    
    return keyboardWrapper
    
End Function


''****Message Dialog Box ****
''This method will show alert to user 
''Param: msgTitle- message title msgSubTitle- message description
Function ShowMessageDialog(msgTitle = "Message",msgSubTitle = "Please Enter Valid Email") As object 

    screenFactoryInstance = screenFactorySharedInstance()
    messageDialogWrapper = screenFactoryInstance.makeWrapper("roMessageDialog")
    
    messageDialogWrapper.Screen.SetTitle(msgTitle)
    messageDialogWrapper.Screen.SetText(msgSubTitle)

    messageDialogWrapper.Screen.AddButton(1, "OK")
    messageDialogWrapper.Screen.EnableBackButton(true) 
       
    messageDialogWrapper.addEventListener("onButtonPressed", Function(wrapper as object,screen as object,msg as object)
            index=msg.GetIndex()
            
            if index = 1
                screen.close()
            end if
            
    End Function)
       
    return messageDialogWrapper
    
End Function

