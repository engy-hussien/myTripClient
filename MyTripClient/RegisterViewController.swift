//
//  RegisterViewController.swift
//  MyTripClient
//
//  Created by Engy Hussein on 8/28/17.
//  Copyright © 2017 Engy Hussein. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileNumberView: UIView!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    
    
    @IBAction func nextBtnTouchUpInside(_ sender: UIButton) {
        if validateInputs() {
            showLoader()
            RegisterService.requestRegisterUser(withName: userNameTextField.text!, withEmail: emailTextField.text!, withMobileNumber: "+2" + mobileNumberTextField.text!, withCompletion: { [weak self] (userModel, error) -> Void in
                self?.dissmissLoader()
                if let user = userModel! as? UserModel {
                    self?.navigateToConfirmVC(withUser: user)
                    
                } else {
                    self?.showAlertViewMsg(title: "Error", msg: "Error while connecting to server")
                }
            })
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupView() {
        self.nameView.layer.borderColor = UIColor.white.cgColor
        self.emailView.layer.borderColor = UIColor.white.cgColor
        self.mobileNumberView.layer.borderColor = UIColor.white.cgColor
        self.userNameTextField.attributedPlaceholder = NSAttributedString(string:  "Name", attributes: [NSForegroundColorAttributeName: UIColor.white])
        self.emailTextField.attributedPlaceholder = NSAttributedString(string:  "Email", attributes: [NSForegroundColorAttributeName: UIColor.white])
        self.mobileNumberTextField.attributedPlaceholder = NSAttributedString(string:  "Mobile Number", attributes: [NSForegroundColorAttributeName: UIColor.white])


    }
    func validateInputs()-> Bool{
        var hasValidInputs = false
        if !userNameTextField.hasText {
            self.nameView.layer.borderColor = UIColor.red.cgColor
            hasValidInputs = false
        } else {
            hasValidInputs = true
            self.nameView.layer.borderColor = UIColor.white.cgColor
        }
        if !emailTextField.hasText {
            self.emailView.layer.borderColor = UIColor.red.cgColor
            hasValidInputs = false
        } else {
            if (emailTextField.text?.isValidEmail())! {
                hasValidInputs = true
              self.emailView.layer.borderColor = UIColor.white.cgColor
            } else {
                hasValidInputs = false
                self.emailView.layer.borderColor = UIColor.red.cgColor
            }
        }
        if !mobileNumberTextField.hasText {
            hasValidInputs = false
            self.mobileNumberView.layer.borderColor = UIColor.red.cgColor
        } else {
            if hasValidInputs {
             hasValidInputs = true
             self.mobileNumberView.layer.borderColor = UIColor.white.cgColor
            }
        }
        return hasValidInputs
    }
    
    func navigateToConfirmVC(withUser user: UserModel) {
        let confirmVC = storyboard?.instantiateViewController(withIdentifier: "confirmLoginVC") as! ConfirmLoginViewController
        confirmVC.user = user
        self.navigationController?.pushViewController(confirmVC, animated: true)
    }

    


}
