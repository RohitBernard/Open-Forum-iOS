//
//  Post.swift
//  Open Forum
//
//  Created by Rohit Pratapa Bernard on 15/03/21.
//

import Foundation

struct Post: Codable{
    var post: PostData?
    var comments: [CommentData?]?
}

struct PostData: Codable{
    var post_id: Int?
    var title: String?
    var overview: String?
    var body: String?
    var image: String?
    var imageData: Data?
    var votes: Int?
    var created: String?
    var name: String?
    var voted: Bool?
}

struct CommentData: Codable{
    var com_id: Int?
    var body: String?
    var votes: Int?
    var created: String?
    var name: String?
}

struct UpVote: Codable{
    var user_id: Int?
    var post_id: Int?
}

struct UpVoteResponse: Codable{
    var post_id: Int?
    var votes: Int?
}
