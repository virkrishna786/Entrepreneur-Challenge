//
//  ReviewTableViewCell.swift
//  CruzSortMeApp
//
//  Created by Admin media on 1/11/17.
//  Copyright © 2017 Gopal Gupta. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewDetailLabel: UILabel!

    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var profileImageView: UIImageView! {
//        didSet {
//            profileImageView.layer.borderWidth = 1
//            profileImageView.layer.masksToBounds = false
//            profileImageView.layer.borderColor = UIColor.white.cgColor
//            profileImageView.layer.cornerRadius = profileImageView.frame.height/2
//            profileImageView.clipsToBounds = true
//        }
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
