//
//  ViewController.swift
//  hapit
//
//  Created by Lewis Black on 04/07/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var loginSignUpStackView: UIStackView!
    @IBOutlet weak var namesStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        if let email = emailTxt.text where email != "", let password = passwordTxt.text where password != ""  {
            FIRAuth.auth()?.signInWithEmail(email, password: password){ (user,error) in
                
                let errorCode = error?.code
                
                print(errorCode)
                
                
                if errorCode == ERROR_WRONGPASSWORD {
                    
                    self.showErrorAlert("Incorrect Password", msg: "It looks like you've misspelled your password chuck")
                    
                } else if password.characters.count <= MINPASSWORDLENGTH {
                    
                    self.showErrorAlert("Password Too Short", msg: "Passwords must be 6 or more Characters")
                    
                } else if errorCode == ERROR_USERNOTFOUND {
                    
                    self.showErrorAlert("Email Address Not Recognised", msg: "Try Again or Sign Up")
                  
                }
            }
        }
    }
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        
        if let email = emailTxt.text where email != "", let password = passwordTxt.text where password != ""  {
            FIRAuth.auth()?.createUserWithEmail(email, password: password){ (user,error) in

                    let errorCode = error?.code
                
                    if password.characters.count <= MINPASSWORDLENGTH {
                
                        self.showErrorAlert("Password Too Short", msg: "Passwords must be 6 or more Characters")
                    
            
                    } else if errorCode == ERROR_USERNOTFOUND {
            
                        self.showErrorAlert("Email Address Not Recognised", msg: "Correct email address or Sign Up")
            
                    } else {
        
                        self.loginSignUpStackView.hidden = true
                        self.namesStackView.hidden = false
                
                        
                    }
                
            }
        }
    }
    
    @IBAction func makeAccountButtonPressed(sender: AnyObject) {
        
        //add First name + last name to account and then segue
        
    }
    
    
    

}

