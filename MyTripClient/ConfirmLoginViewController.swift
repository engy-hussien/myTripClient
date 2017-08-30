//
//  ConfirmLoginViewController.swift
//  MyTripClient
//
//  Created by Engy Hussein on 8/28/17.
//  Copyright © 2017 Engy Hussein. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class ConfirmLoginViewController: BaseViewController {
    
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var codeTextField: UITextField!

    @IBAction func codeTextChanged(_ sender: UITextField) {
        if codeTextField.text?.characters.count == 4 {
            self.varifyCode()
        }
    }
    @IBAction func notRecievingCodeTouchUpInside(_ sender: UIButton) {
        self.varifyCode()
        
    }
    
    @IBAction func nextBtnTouchUpInside(_ sender: UIButton) {
        if validateInputs() {
            self.varifyCode()
        }
    }
    
    var user = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        self.codeView.layer.borderColor = UIColor.white.cgColor
        self.codeTextField.attributedPlaceholder = NSAttributedString(string:  "Code", attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
    func validateInputs()-> Bool{
        if !codeTextField.hasText || (codeTextField.text?.characters.count)! < 4 {
            self.codeView.layer.borderColor = UIColor.red.cgColor
            return false
        }
        return true
    }
    
    func varifyCode() {
        showLoader()
        VerifyCodeService.requestCodeVarification(withNumber: user.phoneNumber, withCode: codeTextField.text!, withCompletion: { [weak self] (res,error)-> Void in
            self?.dissmissLoader()
            if error.isEmpty {
                Defaults[.kIsLoggedInUser] = true
                self?.embedSideMenu()
            }
            
        })

    }
    
    func embedSideMenu() {
        let sideMenu = storyboard?.instantiateViewController(withIdentifier: "sideMenuVC") as! UINavigationController
        let homeVC = storyboard?.instantiateViewController(withIdentifier: "homeNC") as! UINavigationController
        sideMenuViewController.embed(sideViewController: sideMenu)
        sideMenuViewController.embed(centerViewController: homeVC)
        show(sideMenuViewController, sender: nil)
    }


}
