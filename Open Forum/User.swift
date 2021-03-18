//
//  User.swift
//  Open Forum
//
//  Created by Rohit Bernard on 18/03/21.
//

import Foundation

struct User :Codable{
    var google_id: String?
    var name: String?
    var email: String?
    var tumbnail: String?
}

struct UserResponse :Codable{
    var user_id: Int?
    var google_id: String?
    var name: String?
    var email: String?
    var tumbnail: String?
}
