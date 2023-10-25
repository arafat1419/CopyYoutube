//
//  YoutubeTableViewCell.swift
//  CopyYoutube
//
//  Created by Arafat on 11/10/23.
//

import UIKit

class YoutubeTableViewCell: UITableViewCell {
    
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var imgThumbnail: UIImageView!
    @IBOutlet var txtDesc: UILabel!
    @IBOutlet var txtTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
    }
    
}
