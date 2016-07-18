//
//  User.swift
//  hapit
//
//  Created by Lewis Black on 07/07/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import Foundation

class User {
    
    var firstName:String?
    var lastName:String?
    var uid:String!
   
    init( uid: String){
        self.uid = uid
    }
    
}