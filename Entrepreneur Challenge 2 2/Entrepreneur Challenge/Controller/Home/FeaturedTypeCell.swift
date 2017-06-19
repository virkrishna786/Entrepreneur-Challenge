//
//  FeaturedTypeCell.swift
//  Entrepreneur Challenge
//
//  Created by Admin media on 3/24/17.
//  Copyright © 2017 Media Mosaic service private limited. All rights reserved.
//

import UIKit

class FeaturedTypeCell: UICollectionViewCell {
    
    @IBOutlet weak var featureLabel: UILabel!
    @IBOutlet weak var featureImageView: UIImageView!{
        didSet{
            
//            featureImageView.layer.borderColor = UIColor.white.cgColor
//            featureImageView.layer.borderWidth = 0.5
        }
    }
}
