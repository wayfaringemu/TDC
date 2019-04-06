//
//  LoginViewController.swift
//  TDC
//
//  Created by ryan kowalski on 4/5/19.
//  Copyright © 2019 ryan kowalski. All rights reserved.
//

import UIKit

class LoginViewController: TDCViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    let dataModels = DataModels()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        usernameLabel.text = "Username: "
        passwordLabel.text = "Password: "
        usernameTextField.placeholder = "username or email"
        passwordTextField.placeholder = "password1234"
        
        loginButton.setTitle("Login", for: .normal)
        forgotPasswordButton.setTitle("Forgot Password", for: .normal)
        logoImageView.image = UIImage(named: "TDC_Members_Logo")
    }
    
    func login() {
        if TempItem.parsingCompleted == false {
            dataModels.makeAPIPost()
        } else {
            print("data has already been loaded")
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        login()
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        
    }
    
}
