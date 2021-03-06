//
//  ViewController.swift
//  MyTripClient
//
//  Created by Engy Hussein on 8/18/17.
//  Copyright © 2017 Engy Hussein. All rights reserved.
//

import UIKit
import GoogleMaps


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
 //       self.embedSideMenu()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func embedSideMenu() {
        let sideMenu = storyboard?.instantiateViewController(withIdentifier: "sideMenuVC") as! UINavigationController
        let homeVC = storyboard?.instantiateViewController(withIdentifier: "homeNC") as! UINavigationController
        sideMenuViewController.embed(sideViewController: sideMenu)
        sideMenuViewController.embed(centerViewController: homeVC)
        show(sideMenuViewController, sender: nil)
    }


}

