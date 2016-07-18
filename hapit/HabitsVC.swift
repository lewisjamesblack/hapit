//
//  HabitsVC.swift
//  hapit
//
//  Created by Lewis Black on 06/07/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import UIKit
import Firebase


class HabitsVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print (currentUser?.firstName)
    
        FIRAuth.auth()?.addAuthStateDidChangeListener{ auth,user in
        
        if user != nil {
            print("user Signed In")
            print(user!.displayName)
            print(user!.email)
        } else {
            print("no user signed in")
        }
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
