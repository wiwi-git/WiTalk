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
        self.color = remoteConfig.configValue(forKey: "splash_background").stringValue
        
        statusBar.backgroundColor = UIColor(hexString: self.color)
        self.signUpButton.backgroundColor = UIColor(hexString: self.color)
        self.cancelButton.backgroundColor = UIColor(hexString: self.color)
        
        self.signUpButton.addTarget(self, action: #selector(touchUpButtons(_:)), for: .touchUpInside)
        self.signUpButton.tag = 1
        self.cancelButton.addTarget(self, action: #selector(touchUpButtons(_:)), for: .touchUpInside)
        
        self.imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePicker)))
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
    
    func signUp(email:String,name:String,pass:String,image:UIImage?){
        Auth.auth().createUser(withEmail: email, password: pass) { (result, error) in
            if let err = error {
                print("ERRor createUser " + err.localizedDescription)
            }
            guard let uid = result?.user.uid else { return }
            let dataBaseRef = Database.database().reference()
            let storegeRef = Storage.storage().reference()
            
            if let image = image {
                //프로필 이미지 있을경우
                if let jpgImageData = image.jpegData(compressionQuality: 0.5) {
                    let riversRef = storegeRef.child("usersImage/\(uid)")
                    _ = riversRef.putData(jpgImageData, metadata: nil) { (metadata, error) in
                        if let err = error {
                            print("ERROR, Error, SignUpViewcontroller, SignUp, putData, \(err.localizedDescription)")
                        }
                        riversRef.downloadURL { (url, error) in
                            if let err = error {
                                print("ERROR, Error, SignUpViewcontroller, SignUp, downloadUrl, \(err.localizedDescription)")
                            }
                            let value:[String:Any] = url != nil ? ["name":name, "profileImageUrl": url!.absoluteString, "uid":Auth.auth().currentUser?.uid] : ["name":name, "uid":Auth.auth().currentUser?.uid]
                            dataBaseRef.child("users").child(uid).setValue(value) { (error, ref) in
                                if let err = error {
                                    print("ERROR, Error, SignUpViewcontroller, SignUp, database setValue \(err.localizedDescription)")
                                }
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                } else {
                    print("ERROR, SignUpViewcontroller, SignUp, jpg데이터 변환 실패")
                }
            } else {
                //프로필 이미지 없을경우
                dataBaseRef.child("users").child(uid).setValue(["name" : name, "uid":Auth.auth().currentUser?.uid]) { (error, ref) in
                    if let err = error {
                        print("ERROR, Error, SignUpViewcontroller, SignUp, database setValue \(err.localizedDescription)")
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }//createUser
    }
    

}
extension SignUpVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
}
