//
//  SuggestedTypeCell.swift
//  Entrepreneur Challenge
//
//  Created by Admin media on 3/24/17.
//  Copyright © 2017 Media Mosaic service private limited. All rights reserved.
//

import UIKit

class SuggestedTypeCell: UICollectionViewCell {
    
    @IBOutlet weak var suggestedLabel: UILabel!
    @IBOutlet weak var suggestedImageView: UIImageView!{
        didSet{
//            suggestedImageView.layer.borderColor = UIColor.white.cgColor
//            suggestedImageView.layer.borderWidth = 0.5
        }
    }
}
