//
//  AirtaskCollectionViewCell.swift
//  AirTasker
//
//  Created by Timothy Storey on 04/03/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import UIKit

class AirtaskCollectionViewCell: UICollectionViewCell {
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1.5 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
