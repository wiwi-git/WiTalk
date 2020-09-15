//
//  LoginVC.swift
//  WiTalk
//
//  Created by 위대연 on 2020/08/19.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    static let sb_id = "sb_id_loginvc"
    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var pwTextField:UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    
    
    let remoteConfig = RemoteConfig.remoteConfig()
    var color: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBar = UIView()
        self.view.addSubview(statusBar)
        statusBar.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view)
            maker.height.equalTo(20)
        }
//        color = remoteConfig.configValue(forKey: "splash_background").stringValue
        logoImageView.layer.cornerRadius = 20
        logoImageView.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 20
        loginButton.layer.masksToBounds = true
        signUpButton.layer.cornerRadius = 20
        signUpButton.layer.masksToBounds = true
        
        
        statusBar.backgroundColor = UIColor.clear
        loginButton.backgroundColor = UIColor.clear
        signUpButton.backgroundColor = UIColor.clear
        
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        
        signUpButton.addTarget(self, action: #selector(touchUpSignUpButton(_:)), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(touchUpLoginButton(_:)), for: .touchUpInside)
        
        self.emailTextField.delegate = self
        self.pwTextField.delegate = self
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: PeopleViewController.sb_id_tabbar) as! UITabBarController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
                let uid = Auth.auth().currentUser?.uid
                var token:String = ""
                
                InstanceID.instanceID().instanceID { (result, error) in
                  if let error = error {
                    print("Error fetching remote instance ID: \(error)")
                  } else if let result = result {
                    print("Remote instance ID token: \(result.token)")
                    token = result.token
                    Database.database().reference().child("users").child(uid!).updateChildValues(["pushToken" : token])
                  }
                }
            }// user != nil
        }//Auth addStateDidChangeListener
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func touchUpSignUpButton(_ sender:UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: SignUpVC.sb_id) as! SignUpVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func touchUpLoginButton(_ sender:UIButton) {
        guard let email = emailTextField.text, let pw = pwTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: pw) { (result, error) in
            if let err = error {
                print("Error, \(err.localizedDescription)")
                let alert = UIAlertController(title: "ERROR", message: err.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

}
extension LoginVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}
