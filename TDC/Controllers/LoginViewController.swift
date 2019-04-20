//
//  LoginViewController.swift
//  TDC
//
//  Created by ryan kowalski on 4/5/19.
//  Copyright © 2019 ryan kowalski. All rights reserved.
//

import UIKit
import RealmSwift

class LoginViewController: TDCViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBOutlet weak var saveUsernameLabel: UILabel!
    @IBOutlet weak var saveUsernameSwitch: UISwitch!

    @IBOutlet weak var allowBioAuthLabel: UILabel!
    @IBOutlet weak var allowBioAuthSwitch: UISwitch!
    
    // MARK: - variables and constants
    
    let dataModels = DataModels()
    var saveUsername = false
    var useBioAuth = false
    var currentUser: Results<UserObject>?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveData()
        setupView()
        getData()
    }
    
    func setupView() {
        usernameLabel.text = "Username: "
        passwordLabel.text = "Password: "
        usernameTextField.placeholder = "username or email"
        passwordTextField.placeholder = "password1234"
        
        loginButton.setTitle("Login", for: .normal)
        forgotPasswordButton.setTitle("Forgot Password", for: .normal)
        logoImageView.image = UIImage(named: "TDC_Members_Logo")
        
        saveUsernameLabel.text = "Save Username:"
        allowBioAuthLabel.text = "Use FaceID or Fingerprint:"
        saveUsernameSwitch.onTintColor = Constants.TdcBlueColor
        allowBioAuthSwitch.onTintColor = Constants.TdcBlueColor
    }
    
    
    
    func retrieveData() {
        currentUser = realm.objects(UserObject.self)
        if let user = currentUser?.first {
            userObject.userName = user.userName
            userObject.saveUsername = user.saveUsername
            userObject.useBioAuth = user.useBioAuth
            
            if user.saveUsername == true {
                if user.userName != "" {
                    usernameTextField.text = user.userName
                }
                saveUsernameSwitch.setOn(true, animated: false)
            } else {
                saveUsernameSwitch.setOn(false, animated: false)
            }
            
            if user.useBioAuth == true {
                allowBioAuthSwitch.setOn(true, animated: false)
            } else {
                allowBioAuthSwitch.setOn(false, animated: false)
            }
        }
    }
    
    func login() {
        if saveUsernameSwitch.isOn {
            print("username saved")
            saveUsername = true
        } else {
            print("username not saved")
            saveUsername = false
        }
        
        if allowBioAuthSwitch.isOn {
            print("bio auth saved")
            useBioAuth = true
        } else {
            print("bio auth not saved")
            useBioAuth = false
        }
         userObject.saveUsername = saveUsername
        userObject.useBioAuth = useBioAuth

        if saveUsername == true, let username = usernameTextField.text {
            userObject.userName = username
        } else {
            userObject.userName = ""
        }
        if let password = passwordTextField.text {
            userObject.userPass = password
        }
        
        try! realm.write {
            
            realm.deleteAll()
            userObject.saveUsername = saveUsername
            userObject.userName = userObject.userName
            userObject.useBioAuth = useBioAuth
            realm.add(userObject)
        }
        
        
        if TempItem.parsingCompleted == false {
            dataModels.makeAPIPost(username: userObject.userName, password: userObject.userPass)
        } else {
            print("data has already been loaded")
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let password = passwordTextField.text {
            userObject.userPass = password
        }
        if let username = usernameTextField.text {
            userObject.userName = username
        }
        if userObject.userPass != "" && userObject.userName != "" {
            login()
        } else {
            // display error
        }
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        if let url = URL(string: "http://detroitcast.com/members-login/?action=forgot_password") {
            UIApplication.shared.open(url, options: [:])
        }
    }

    
}
