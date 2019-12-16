//
//  ProfileCollectionViewCell.swift
//  AirTasker
//
//  Created by Timothy Storey on 04/03/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: AirtaskCollectionViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
