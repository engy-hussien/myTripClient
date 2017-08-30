//
//  SelectLocationsViewCell.swift
//  MyTripClient
//
//  Created by Engy Hussein on 8/26/17.
//  Copyright © 2017 Engy Hussein. All rights reserved.
//

import UIKit

class SelectLocationsViewCell: UICollectionViewCell {

    @IBOutlet weak var viewNumber: UIView!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var destinationBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!

    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func prepareCell() {
        self.viewNumber.layer.borderColor = UIColor.white.cgColor
    }
    func setCellNotShown(forCell cell: UICollectionViewCell) {
        cell.contentView.layer.opacity = 0.7
    }
    
    func setLocation(withLocation location: String) {
        self.locationBtn.setTitle(location, for: .normal)
    }
    func setDestination(withDestination destination: String) {
        self.destinationBtn.setTitle(destination, for: .normal)
    }
    

}
