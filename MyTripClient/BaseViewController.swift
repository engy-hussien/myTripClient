//
//  BaseViewController.swift
//  MyTripClient
//
//  Created by Engy Hussein on 8/19/17.
//  Copyright © 2017 Engy Hussein. All rights reserved.
//

import UIKit
import KVNProgress
import CDAlertView

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }


    func showLoader()  {
        KVNProgress.show()
    }

    func dissmissLoader(){
            KVNProgress.dismiss()
    }
    func showAlertViewMsg(title: String,msg:String)  {
        let alert = CDAlertView(title: title, message: msg, type: .error )
        
        alert.hideAnimations = { (center, transform, alpha) in
            transform = CGAffineTransform(scaleX: 3, y: 3)
            alpha = 0
        }
        alert.hideAnimationDuration = 0.5
        alert.show()
    }

}
