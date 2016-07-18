//
//  ViewController.swift
//  hapit
//
//  Created by Lewis Black on 04/07/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import FacebookLogin


var currentUser:User?


class ViewController: UIViewController, GIDSignInUIDelegate{

    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var loginSignUpStackView: UIStackView!
    @IBOutlet weak var namesStackView: UIStackView!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var yellowView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
    

        
   
        FIRAuth.auth()?.addAuthStateDidChangeListener{ auth, user in
    
            if let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID){
                currentUser = User(uid: uid as! String)
                self.performSegueWithIdentifier(SEGUE_LOGIN_TO_HABITS, sender: nil)
                print("Going to the next VC with \(currentUser!.uid)")

            } else {
                print("No User Logged In, There is nothing ales to say")
            }
        }
        

       
       
            
        
       

        
        loginSignUpStackView.hidden = false
        namesStackView.hidden = true
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showErrorAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    //email
    
    
    func emailAddressAndPassportOk(errorCode:Int?, password:String) -> Bool {
        
        if errorCode == ERROR_WRONGPASSWORD {
            
            self.showErrorAlert("Incorrect Password", msg: "It looks like you've misspelled your password chuck")
            return false
            
        } else if errorCode == ERROR_INVALIDEMAIL {
            
            self.showErrorAlert("Invalid Email Address", msg: "Try again chuck")
            return false
        } else if password.characters.count <= MINPASSWORDLENGTH {
            
            self.showErrorAlert("Password Too Short", msg: "Passwords must be 6 or more Characters")
            return false
        }
        
        return true
    }
   
    
    func signUserIn(firstName: String?, lastName: String?){
        
        if let email = emailTxt.text where email != "", let password = passwordTxt.text where password != ""  {
            FIRAuth.auth()?.signInWithEmail(email, password: password){ (user,error) in
                
                if let errorCode = error?.code {
                    print(errorCode.description)
                    self.emailAddressAndPassportOk(errorCode, password: password)
                    
                    if errorCode == ERROR_USERNOTFOUND {
                        
                        self.showErrorAlert("Email Address Not Recognised", msg: "Try Again or Sign Up")
                    }
                } else {
                    
                    let uid = user!.uid
                    currentUser = User(uid: uid)
                    
                    if let firstName = firstName, let lastName = lastName {
                     
                        
                        
                        let user = ["firstName": firstName,
                                    "lastName": lastName,
                                    "email": email,
                                    "password": password,
                                    "uid": uid]

                        ref.updateChildValues(["/users/\(uid)":user])
                        

                    }
                    
                    NSUserDefaults.standardUserDefaults().setValue(uid, forKey: KEY_UID)

                    print("Going to the next VC with \(currentUser!.uid)")
                    self.performSegueWithIdentifier(SEGUE_LOGIN_TO_HABITS, sender: nil)
                }
            }
        }
    }
    
    //just login
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        signUserIn(nil, lastName: nil)
    }
    
    
    //make account
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        
        if let email = emailTxt.text where email != "", let password = passwordTxt.text where password != ""  {
            FIRAuth.auth()?.createUserWithEmail(email, password: password){ (user,error) in

                if let errorCode = error?.code {
                    print(errorCode.description)
                
                    if self.emailAddressAndPassportOk(errorCode, password: password) == true {
                        if errorCode == ERROR_USERNOTFOUND {
                            self.showErrorAlert("Email Address Not Recognised", msg: "Correct email address or Sign Up")
                        } else if errorCode == ERROR_EMAILALREADYINUSE {
                            self.showErrorAlert("Email Address Already In Use", msg: "Try Signing In")
                        }
                    }
                } else {
                    
                    self.loginSignUpStackView.hidden = true
                    self.namesStackView.hidden = false
                }
                
            }
        }
    }
    
    @IBAction func makeAccountButtonPressed(sender: AnyObject) {
        
        if let firstName = firstNameText.text where firstName != "", let lastName = lastNameText.text where lastName != "" {
            
            // add that is doesn't contain Spaces
            self.signUserIn(firstName, lastName: lastName)
        } else {
            self.showErrorAlert("No Name Entered", msg: "Enter Your Name")
        }
        
    }
    
  
    
    //facebook
    @IBAction func facebookButtonClicked(sender: AnyObject) {
        
        let loginManager = LoginManager()
        loginManager.logIn([ .PublicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .Failed(let error):
                print(error)
            case .Cancelled:
                print("User cancelled")
            case .Success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in")
                print(accessToken)
                
                print(accessToken.appId)
                let uid = accessToken.userId
                //NSUserDefaults.standardUserDefaults().setValue(uid, forKey: KEY_UID)
                print("Going to the next VC with \(uid)")
                
                self.performSegueWithIdentifier(SEGUE_LOGIN_TO_HABITS, sender: nil)
                
                print("why no segue??")
            }
        }
    }
    
    @IBAction func segueCheck(sender: AnyObject) {
        
        self.performSegueWithIdentifier(SEGUE_LOGIN_TO_HABITS, sender: nil)

        
    }

 

    
    //google

}


