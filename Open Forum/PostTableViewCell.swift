//
//  PostTableViewCell.swift
//  Open Forum
//
//  Created by Rohit Pratapa Bernard on 15/03/21.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    //MARK: Properties
    
    
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postBody: UILabel!
    @IBOutlet weak var postUpVoteCount: UILabel!
    @IBOutlet weak var postUpVote: UIButton!
    @IBOutlet weak var postComment: UIButton!
    
    @IBOutlet weak var withHeight: NSLayoutConstraint!
    
    @IBOutlet weak var noHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
