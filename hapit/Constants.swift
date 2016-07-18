//
//  Constants.swift
//  hapit
//
//  Created by Lewis Black on 06/07/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import Foundation
import Firebase

let KEY_UID = "uid"


let ERROR_EMAILALREADYINUSE = 17007
let ERROR_WRONGPASSWORD = 17009
let ERROR_USERNOTFOUND = 17011
let ERROR_INVALIDEMAIL = 17008
let MINPASSWORDLENGTH = 6

let SEGUE_LOGIN_TO_HABITS = "loginToHabits"


let ref = FIRDatabase.database().reference()
