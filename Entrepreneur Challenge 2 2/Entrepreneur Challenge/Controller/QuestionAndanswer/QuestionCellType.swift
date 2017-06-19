//
//  QuestionCellType.swift
//  Entrepreneur Challenge
//
//  Created by Admin media on 3/28/17.
//  Copyright © 2017 Media Mosaic service private limited. All rights reserved.
//

import UIKit

class QuestionCellType: UITableViewCell {

    @IBOutlet weak var yesButton: UIButton!
   
    @IBOutlet weak var surveyQuestionLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet weak var otherOptionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
