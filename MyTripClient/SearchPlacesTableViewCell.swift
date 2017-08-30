//
//  SearchPlacesTableViewCell.swift
//  MyTripClient
//
//  Created by Engy Hussein on 8/27/17.
//  Copyright © 2017 Engy Hussein. All rights reserved.
//

import UIKit

class SearchPlacesTableViewCell: UITableViewCell {

    @IBOutlet weak var placeTypeIcon: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeAddress: UILabel!
    @IBOutlet weak var isFavBtn: UIButton!
    @IBOutlet weak var separatorView: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    

}
