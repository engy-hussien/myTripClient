//
//  SideMenuViewController.swift
//  MyTripClient
//
//  Created by Engy Hussein on 8/19/17.
//  Copyright © 2017 Engy Hussein. All rights reserved.
//

import UIKit

class SideMenuTableViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {


    let menuItems = ["Home", "Rides History", "Profile", "Wallet", "Help", "Contact Us"]
    let menuImages = [#imageLiteral(resourceName: "ic_home"), #imageLiteral(resourceName: "ic_rideshistory"), #imageLiteral(resourceName: "ic_profile"), #imageLiteral(resourceName: "ic_wallet"), #imageLiteral(resourceName: "ic_help"), #imageLiteral(resourceName: "ic_contactus")]
    
    
    @IBAction func closeMenuTouchUpInside(_ sender: UIButton) {
        sideMenuViewController.toggle()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sideMenuCell", for: indexPath) as! MenuTableViewCell
        let itemTitle = menuItems[indexPath.row]
        let itemImage = menuImages[indexPath.row]
        cell.setupCell(withTitle: itemTitle, withImage: itemImage)
        if indexPath.row == 5 {
            cell.separatorView.isHidden = true
        } else {
            cell.separatorView.isHidden = false
        }
        return cell
    }


}
