//
//  SurveyDetailCellTypeCell.swift
//  Entrepreneur Challenge
//
//  Created by Admin media on 3/27/17.
//  Copyright © 2017 Media Mosaic service private limited. All rights reserved.
//

import UIKit

class SurveyDetailCellTypeCell: UITableViewCell {
    
    @IBOutlet weak var staticLabel: UILabel!
    @IBOutlet weak var eventDetailLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var startSurveyButton : UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var simpleTextLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
