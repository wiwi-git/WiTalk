//
//  ProfileViewController.swift
//  WiTalk
//
//  Created by 위대연 on 2020/09/18.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    static let sb_id = "sb_id_profiel_viewcontroller"
    
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImageView:UIImageView!
    @IBOutlet weak var photoIconImageView:UIImageView!
    @IBOutlet weak var statusMessageTextField:UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var editButton:UIButton!
    @IBOutlet weak var saveButton:UIButton!
    @IBOutlet weak var closeButton:UIButton!
    
    let basicImage = UIImage(named: "basic_profile")!
    
    var previousImage:UIImage?
    var previousMessage:String?
    var userName:String?
    
    var isEditMode : Bool! {
        didSet {
            self.toggleEditMode()
        }
    }
    
    var imagePicker:UIImagePickerController!
    
    enum ButtonTag : Int {
        case close = 10
        // closeButton과 같은 버튼을 공유 editMode시 closeButton은 cancelButton이 됨
        case cancel
        case save
        case edit
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height/2
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.borderWidth = 0.5
        self.profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.mediaTypes = ["public.image"]
        
        self.isEditMode = false
        self.saveButton.isHidden = true
        self.photoIconImageView.isHidden = true
        
        self.closeButton.tag = ButtonTag.close.rawValue
        self.closeButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpInside)
        
        self.editButton.tag = ButtonTag.edit.rawValue
        self.editButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpInside)
        
        self.saveButton.tag = ButtonTag.save.rawValue
        self.saveButton.addTarget(self, action: #selector(touchUpButtonAction(_:)), for: .touchUpInside)
        
        
        self.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureProfileImageViewAction)))
        
        self.statusMessageTextField.delegate = self
        
        self.nameLabel.text = self.userName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let image = self.previousImage {
            self.profileImageView.image = image
        } else {
            self.profileImageView.image = basicImage
        }
        
        self.profileImageView.image = self.previousImage
        self.statusMessageTextField.text = self.previousMessage
        
        self.navigationController?.navigationBar.isHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification:Notification) {
        if let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.viewBottomConstraint.constant = keyboardSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        self.viewBottomConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
    
    func toggleEditMode() {
        if isEditMode {
            self.closeButton.setImage(nil, for: .normal)
            self.closeButton.setTitle("취소", for: .normal)
            self.closeButton.tag = ButtonTag.cancel.rawValue
            
            self.saveButton.isHidden = false
            
            self.photoIconImageView.isHidden = false
            self.profileImageView.isUserInteractionEnabled = true
            
            self.statusMessageTextField.isUserInteractionEnabled = true
            
            self.editButton.isHidden = true
            
        } else {
            self.closeButton.setImage(UIImage(named: "close"), for: .normal)
            self.closeButton.setTitle(nil, for: .normal)
            self.closeButton.tag = ButtonTag.close.rawValue
            
            self.saveButton.isHidden = true
            
            self.photoIconImageView.isHidden = true
            self.profileImageView.isUserInteractionEnabled = false
            
            self.statusMessageTextField.isUserInteractionEnabled = false
            
            self.editButton.isHidden = false
        }
    }
    
    
    @objc func touchUpButtonAction(_ sender:UIButton) {
        if let button = ButtonTag.init(rawValue: sender.tag) {
            switch button {
            case .close : self.dismiss(animated: true, completion: nil)
                
            case .cancel:
                self.profileImageView.image = self.previousImage
                self.statusMessageTextField.text = self.previousMessage
                self.isEditMode = false
                
            case .save :
                print(" save ")
                
                let currentUser = Auth.auth().currentUser!
                let dataRef = Database.database().reference()
                let storegeRef = Storage.storage().reference()
                
                var changeTextFlag = false
                var changeImageFlag = false
                
                let previousMessage = self.previousMessage ?? ""
                let changedMessage = self.statusMessageTextField.text ?? ""
                
                if previousMessage != changedMessage {
                    changeTextFlag = true
                }
                
                guard let changedImage = self.profileImageView.image  else {
                    print("Error, profileImageView is nil")
                    self.isEditMode = false
                    self.dismiss(animated: false, completion: nil)
                    return
                }
                
                if changedImage != previousImage {
                    changeImageFlag = true
                }
                
                
                if changeTextFlag, changeImageFlag {
                    if let jpgImageData = changedImage.jpegData(compressionQuality: 0.5) {
                        let riversRef = storegeRef.child("usersImage/\(currentUser.uid).jpg")
                        riversRef.putData(jpgImageData, metadata: nil) { (metadata, error) in
                            if let err = error {
                                print("ERROR, ProfileViewController, save, putData, \(err.localizedDescription)")
                            }
                            riversRef.downloadURL { (url, error) in
                                if let err = error {
                                    print("ERROR, ProfileViewController, putData, downloadUrl, \(err.localizedDescription)")
                                }
                                dataRef.child("users").child(currentUser.uid).updateChildValues(["profileImageUrl": url!.absoluteString])
                            }
                            
                            dataRef.child("users").child(currentUser.uid).updateChildValues(["status" : changedMessage])
                            self.isEditMode = false
                        }
                    } else {
                        print("ERROR, ProfileViewController, save, jpg데이터 변환 실패")
                        self.isEditMode = false
                    }
                    
                } else if changeTextFlag {
                    dataRef.child("users").child(currentUser.uid).updateChildValues(["status" : changedMessage])
                    self.isEditMode = false
                    
                } else if changeImageFlag {
                    if let jpgImageData = changedImage.jpegData(compressionQuality: 0.5) {
                        let riversRef = storegeRef.child("usersImage/\(currentUser.uid).jpg")
                        _ = riversRef.putData(jpgImageData, metadata: nil) { (metadata, error) in
                            if let err = error {
                                print("ERROR, Error, ProfileViewController, save, putData, \(err.localizedDescription)")
                            }
                            riversRef.downloadURL { (url, error) in
                                if let err = error {
                                    print("ERROR, ProfileViewController, putData, downloadUrl, \(err.localizedDescription)")
                                }
                                dataRef.child("users").child(currentUser.uid).updateChildValues(["profileImageUrl": url!.absoluteString])
                            }
                            self.isEditMode = false
                        }
                    } else {
                        print("ERROR, ProfileViewController, save, jpg데이터 변환 실패")
                        self.isEditMode = false
                    }
                } else {
                    self.isEditMode = false
                }
            case .edit : self.isEditMode = true
            }
        }
    }
    
    @objc func tapGestureProfileImageViewAction() {
        if self.previousImage != nil {
            let alertController = UIAlertController(title: "프로필사진 설정", message: nil, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "앨범에서 사진 선택", style: .default, handler: { (_) in
                self.present(self.imagePicker, animated: true, completion: nil)
            }))
            alertController.addAction(UIAlertAction(title: "기본사진으로 변경", style: .default, handler: { (_) in
                let currentUser = Auth.auth().currentUser!
                let storegeRef = Storage.storage().reference()
                let riversRef = storegeRef.child("usersImage/\(currentUser.uid).jpg")
                let dataRef = Database.database().reference()
                riversRef.delete { (error) in
                    if let error = error {
                        print("Error, 기본사진으로 변경,Delete :\(error.localizedDescription)")
                    }
                    dataRef.child("users").child(currentUser.uid).updateChildValues(["profileImageUrl" : "nil"]) { (error, ref) in
                        if let error = error {
                            print("Error, 기본 사진으로 변경 updateChildValues \(error.localizedDescription)")
                        }
                        self.profileImageView.image = UIImage(named: "basic_profile")
                    }
                }
            }))
            alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { (_) in
            }))
            self.present(alertController, animated: true)
            
        } else {
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    
}
extension ProfileViewController:
    UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.profileImageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}
