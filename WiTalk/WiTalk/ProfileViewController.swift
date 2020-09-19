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
    
    @IBOutlet weak var profileImageView:UIImageView!
    @IBOutlet weak var photoIconImageView:UIImageView!
    @IBOutlet weak var statusMessageTextField:UITextField!
    
    @IBOutlet weak var editButton:UIButton!
    @IBOutlet weak var saveButton:UIButton!
    @IBOutlet weak var closeButton:UIButton!
    
    let basicImage = UIImage(named: "basic_profile")!
    
    var previousImage:UIImage?
    var previousMessage:String?
    
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
        
        self.imagePicker = UIImagePickerController()
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
        
        self.imagePicker.delegate = self
        
        self.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureProfileImageViewAction)))
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
            case .close :
                print(" close ")
                self.dismiss(animated: true, completion: nil)
                
            case .cancel:
                print(" cancel ")
                self.profileImageView.image = self.previousImage
                self.statusMessageTextField.text = self.previousMessage
                self.isEditMode = false
                
            case .save :
                print(" save ")
                let currentUser = Auth.auth().currentUser!
                
                let previousMessage = self.previousMessage ?? ""
                if previousMessage != (self.statusMessageTextField.text ?? "") {
                    
                }
                
                guard let changedImage = self.profileImageView.image  else {
                    print("Error, profileImageView is nil")
                    self.dismiss(animated: false, completion: nil)
                    return
                }
                if changedImage != basicImage, changedImage != previousImage {
                    self.chageImage(uid: currentUser.uid, image: self.profileImageView.image)
                }
                
            case .edit :
                print(" toggle ")
                self.isEditMode = !self.isEditMode
                
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
                
            }))
            alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { (_) in
            }))
            
        } else {
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    func chageImage(uid:String, image:UIImage?) {
        if let image = image {
            if let jpgImageData = image.jpegData(compressionQuality: 0.5) {
                let dataBaseRef = Database.database().reference()
                let storegeRef = Storage.storage().reference()
                let riversRef = storegeRef.child("usersImage/\(uid).jpg")
                _ = riversRef.putData(jpgImageData, metadata: nil) { (metadata, error) in
                    
                    if let err = error {
                        print("ERROR, Error, SignUpViewcontroller, SignUp, putData, \(err.localizedDescription)")
                    }
                }
            } else {
                print("ERROR, SignUpViewcontroller, SignUp, jpg데이터 변환 실패")
            }
        }
    }

}
extension ProfileViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.profileImageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
}
