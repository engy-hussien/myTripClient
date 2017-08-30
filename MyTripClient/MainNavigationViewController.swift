//
//  MainNavigationViewController.swift
//  MyTripClient
//
//  Created by Engy Hussein on 8/28/17.
//  Copyright © 2017 Engy Hussein. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class MainNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if Defaults[.kIsLoggedInUser] {
            self.isNavigationBarHidden = true
            embedSideMenu()
            
        } else {
            navToRegisterVC()
        }
    }
    
    func navToRegisterVC() {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "registerVC") as! RegisterViewController
        self.setViewControllers([loginVC], animated: true)
        
    }

    func embedSideMenu() {
        let sideMenu = storyboard?.instantiateViewController(withIdentifier: "sideMenuVC") as! UINavigationController
        let homeVC = storyboard?.instantiateViewController(withIdentifier: "homeNC") as! UINavigationController
        sideMenuViewController.embed(sideViewController: sideMenu)
        sideMenuViewController.embed(centerViewController: homeVC)
        show(sideMenuViewController, sender: nil)
    }


}
