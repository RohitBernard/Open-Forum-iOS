//
//  CommentTableViewCell.swift
//  Open Forum
//
//  Created by Rohit Pratapa Bernard on 17/03/21.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    //MARK: Properties
    
    var hasBeenLoaded:Bool=false
    @IBOutlet weak var commenterName: UILabel!
    @IBOutlet weak var commentBody: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
