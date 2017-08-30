//
//  SelectCarViewCell.swift
//  MyTripClient
//
//  Created by Engy Hussein on 8/30/17.
//  Copyright © 2017 Engy Hussein. All rights reserved.
//

import UIKit

class SelectCarViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewNumber: UIView!
    @IBOutlet var carsTypesLabels: [UILabel]?
    @IBOutlet var carsTypesImages: [UIImageView]?
    @IBOutlet var carsTypesBottomViews: [UIView]?
    @IBOutlet var carsTypesBtns: [UIButton]?
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderBtn: UIButton!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var paymentBtn: UIButton!
    
    weak var delegate: HomeViewController?
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    func setupCell() {
        self.viewNumber.layer.borderColor = UIColor.white.cgColor
    }

    func selectCarType(withSender sender: UIButton) {
        for btn in carsTypesBtns! {
            if sender.tag == btn.tag {
                let label = carsTypesLabels?.filter({$0.tag == btn.tag})
                label?[0].textColor = #colorLiteral(red: 0.16864, green: 0.17648, blue: 0.19608, alpha: 1)
                let img = carsTypesImages?.filter({$0.tag == btn.tag})
                img?[0].layer.opacity = 1.0
                let bottomView = carsTypesBottomViews?.filter({$0.tag == btn.tag})
                bottomView?[0].backgroundColor = #colorLiteral(red: 0.2980345098, green: 0.7333372549, blue: 0.4823607843, alpha: 1)
            } else {
                let label = carsTypesLabels?.filter({$0.tag == btn.tag})
                label?[0].textColor = #colorLiteral(red: 0.4902, green: 0.4902, blue: 0.4902, alpha: 1)
                let img = carsTypesImages?.filter({$0.tag == btn.tag})
                img?[0].layer.opacity = 0.6
                let bottomView = carsTypesBottomViews?.filter({$0.tag == btn.tag})
                bottomView?[0].backgroundColor = .white
            }
        }
        if sender.tag == CarType.economy.rawValue {
            delegate?.updateTripPrice(forType: CarType.economy)
            
        } else if sender.tag == CarType.business.rawValue {
            delegate?.updateTripPrice(forType: CarType.business)
            
        } else if sender.tag == CarType.elite.rawValue {
            delegate?.updateTripPrice(forType: CarType.elite)
            
        }
        self.layoutIfNeeded()
        
    }
    
}
