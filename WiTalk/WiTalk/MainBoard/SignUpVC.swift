//
//  SignUpVC.swift
//  WiTalk
//
//  Created by 위대연 on 2020/07/20.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {
    static let sb_id = "sb_id_signupvc"
    
    @IBOutlet weak var emailTextfield:UITextField!
    @IBOutlet weak var nameTextfield:UITextField!
    @IBOutlet weak var passwordTextfield:UITextField!
    
    @IBOutlet weak var signUpButton:UIButton!
    @IBOutlet weak var cancelButton:UIButton!
    
    @IBOutlet weak var imageView:UIImageView!
    
    var activityIndicator:UIActivityIndicatorView!
    
    let remoteConfig = RemoteConfig.remoteConfig()
    var color: String!
    
    enum TextFieldTag:Int {
        case name = 10
        case password
        case email
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let statusBar = UIView()
        self.view.addSubview(statusBar)
        statusBar.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view)
            maker.height.equalTo(20)
        }
        
        self.signUpButton.backgroundColor = UIColor.clear
        self.cancelButton.backgroundColor = UIColor.clear
        
        self.signUpButton.layer.cornerRadius = 20
        self.cancelButton.layer.cornerRadius = 20
        
        self.signUpButton.layer.masksToBounds = true
        self.cancelButton.layer.masksToBounds = true
        
        self.signUpButton.layer.borderColor = UIColor.systemBlue.cgColor
        self.cancelButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        self.signUpButton.layer.borderWidth = 1
        self.cancelButton.layer.borderWidth = 1
        
        
        self.signUpButton.addTarget(self, action: #selector(touchUpButtons(_:)), for: .touchUpInside)
        self.signUpButton.tag = 1
        self.cancelButton.addTarget(self, action: #selector(touchUpButtons(_:)), for: .touchUpInside)
        
        self.imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePicker)))
        
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                self.activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
            } else {
                self.activityIndicator = UIActivityIndicatorView(style: .gray)
            }
        } else {
            self.activityIndicator = UIActivityIndicatorView(style: .gray)
        }
        
        self.view.addSubview(activityIndicator)
        self.activityIndicator.snp.makeConstraints { (maker) in
            maker.centerX.centerY.equalTo(self.view)
        }
        activityIndicator.isHidden = true
        
        self.nameTextfield.delegate = self
        self.emailTextfield.delegate = self
        self.passwordTextfield.delegate = self
        self.nameTextfield.tag = TextFieldTag.name.rawValue
        self.emailTextfield.tag = TextFieldTag.email.rawValue
        self.passwordTextfield.tag = TextFieldTag.password.rawValue
    }
    
    @objc func touchUpButtons(_ btn:UIButton) {
        if btn.tag == 1 {
            signUp(email: emailTextfield.text!, name: nameTextfield.text!, pass: passwordTextfield.text!, image: self.imageView.image)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func imagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func isValidEmail(email:String) -> Bool {
           let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
           let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
           return emailTest.evaluate(with: email)
    }
    
    func signUp(email:String,name:String,pass:String,image:UIImage?){
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        guard isValidEmail(email: email) else {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            
            let alertController = UIAlertController(title: "형식오류", message: "이메일주소를 다시 확인해 주세요.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in }))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard name.count > 0 else {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            
            let alertController = UIAlertController(title: "형식오류", message: "이름은 한자리 이상 입력하셔야 합니다.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in }))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard pass.count > 5 else {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            
            let alertController = UIAlertController(title: "형식오류", message: "비밀번호는 6자리 이상 입력하셔야 합니다.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in }))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: pass) { (result, error) in
            if let err = error {
                print("ERRor createUser " + err.localizedDescription)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                return
            }
            guard let uid = result?.user.uid else { return }
            let dataBaseRef = Database.database().reference()
            let storegeRef = Storage.storage().reference()
            result?.user.createProfileChangeRequest().displayName = name
            result?.user.createProfileChangeRequest().commitChanges(completion: nil)
            
            if let image = image {
                //프로필 이미지 있을경우
                if let jpgImageData = image.jpegData(compressionQuality: 0.5) {
                    let riversRef = storegeRef.child("usersImage/\(uid).jpg")
                    _ = riversRef.putData(jpgImageData, metadata: nil) { (metadata, error) in
                        
                        if let err = error {
                            print("ERROR, Error, SignUpViewcontroller, SignUp, putData, \(err.localizedDescription)")
                        }
                        riversRef.downloadURL { (url, error) in
                            if let err = error {
                                print("ERROR, Error, SignUpViewcontroller, SignUp, downloadUrl, \(err.localizedDescription)")
                            }
                            let currentUser = Auth.auth().currentUser!
                            let value:[String:Any] = url != nil ?
                                [ "name":name,
                                "profileImageUrl": url!.absoluteString,
                                "uid":currentUser.uid,
                                "status":""] :
                                [ "name":name, "uid":currentUser.uid, "status":"" ]
                            
                            dataBaseRef.child("users").child(uid).setValue(value) { (error, ref) in
                                if let err = error {
                                    print("ERROR, Error, SignUpViewcontroller, SignUp, database setValue \(err.localizedDescription)")
                                }
                                self.activityIndicator.isHidden = true
                                self.activityIndicator.stopAnimating()
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                } else {
                    print("ERROR, SignUpViewcontroller, SignUp, jpg데이터 변환 실패")
                    let currentUser = Auth.auth().currentUser!
                    dataBaseRef.child("users").child(uid).setValue(
                    ["name" : name,
                     "uid":currentUser.uid,
                     "status":""]) { (error, ref) in
                        if let err = error {
                            print("ERROR, Error, SignUpViewcontroller, SignUp, database setValue \(err.localizedDescription)")
                        }
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                //프로필 이미지 없을경우
                dataBaseRef.child("users").child(uid).setValue(["name" : name, "uid":Auth.auth().currentUser?.uid]) { (error, ref) in
                    if let err = error {
                        print("ERROR, Error, SignUpViewcontroller, SignUp, database setValue \(err.localizedDescription)")
                    }
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }//createUser
    }
}

extension SignUpVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let tf = TextFieldTag.init(rawValue: textField.tag){
            switch tf {
            case .email:
                nameTextfield.becomeFirstResponder()
            case .name:
                passwordTextfield.becomeFirstResponder()
            case .password:
                passwordTextfield.endEditing(true)
            }
        }
        return true
    }
    
}
