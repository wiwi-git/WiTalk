//
//  LoginVC.swift
//  WiTalk
//
//  Created by 위대연 on 2020/07/20.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

class LoginVC: UIViewController {
    
    static let sb_id = "sb_id_loginvc"
    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var pwTextField:UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    let remoteConfig = RemoteConfig.remoteConfig()
    var color: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {try Auth.auth().signOut()}
        catch let err {
            print("err \(err.localizedDescription)")
        }
        
        let statusBar = UIView()
        self.view.addSubview(statusBar)
        statusBar.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view)
            maker.height.equalTo(20)
        }
        color = remoteConfig.configValue(forKey: "splash_background").stringValue
        
        statusBar.backgroundColor = UIColor(hexString: color)
        loginButton.backgroundColor = UIColor(hexString: color)
        signUpButton.backgroundColor = UIColor(hexString: color)
        
        signUpButton.addTarget(self, action: #selector(touchUpSignUpButton(_:)), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(touchUpLoginButton(_:)), for: .touchUpInside)
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "sb_tabbarcontroller") as! UITabBarController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @objc func touchUpSignUpButton(_ sender:UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "sb_id_signupvc") as! SignUpVC
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
