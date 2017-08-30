//
//  MenuTableViewCell.swift
//  MyTripClient
//
//  Created by Engy Hussein on 8/19/17.
//  Copyright © 2017 Engy Hussein. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var separatorView: UIView!


    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setupCell(withTitle title: String, withImage img: UIImage) {
        self.itemTitleLabel.text = title
        self.itemImage.image = img
    }

}
