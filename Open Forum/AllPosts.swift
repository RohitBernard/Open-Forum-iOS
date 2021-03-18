//
//  Post.swift
//  Open Forum
//
//  Created by Rohit Pratapa Bernard on 15/03/21.
//

import Foundation

struct AllPosts: Codable{
    var post_id: Int
    var user_id: Int
    var title: String
    var overview: String
    var body: String
    var image: String
    var imageData: Data?
    var votes: Int
    var created: String
    var voted: Bool?
}
