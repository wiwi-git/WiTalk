//
//  LoadingVC.swift
//  WiTalk
//
//  Created by 위대연 on 2020/06/23.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit
import Firebase
import SnapKit
import LocalAuthentication

class LoadingVC: UIViewController {
    var box = UIImageView()
    var remoteConfig: RemoteConfig!
    var loadedApp:Bool = false {
        didSet{
            if loadedApp {
                DispatchQueue.main.async {
                    let loginVc = self.storyboard?.instantiateViewController(withIdentifier: LoginVC.sb_id) as! LoginVC
                    loginVc.modalPresentationStyle = .fullScreen
                    self.present(loginVc, animated: false, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadedApp = false
        
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        remoteConfig.fetch(withExpirationDuration: 0) { (status, error) in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activate() { (error) in
                    if let err = error { print(err.localizedDescription) }
                }
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
            self.displayWelcome()
        }
        
        
        self.view.addSubview(box)
        box.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.height.width.equalTo(50)
        }
        box.image = #imageLiteral(resourceName: "Icon-App-83.5x83.5")
    }
    
    func displayWelcome() {
        let color = remoteConfig["splash_background"].stringValue!
        let caps = remoteConfig["splash_message_caps"].boolValue
        let message = remoteConfig["splash_message"].stringValue!
        
        if caps {
            let alert = UIAlertController(title: "공지사항", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
                exit(0)
            }))
            self.present(alert, animated: false, completion: nil)
        } else {
            if Auth.auth().currentUser != nil {
                // 이전 로그인캐시가 남아 있다?
                let authContext = LAContext()
                var error: NSError?
                var description: String!
                
                if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    switch authContext.biometryType {
                    case .faceID:
                        description = "FaceID로 인증"
                    case .touchID:
                        description = "TouchID로 인증"
                    case .none:
                        description = "FaceID나 TouchID로 인증을 할 수 없는 기기 입니다."
                    @unknown default:
                        print("ERROR, canEvaluatePolicy - unknown값:, 알 수 없는 에러...")
                        fatalError()
                    }
                    
                    authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: description) {
                        (success, error) in
                        if success {
                            print("인증 성공")
                            self.loadedApp = true
                        } else {
                            print("인증 실패")
                            if let error = error {
                                print(error.localizedDescription)
                                let alertController = UIAlertController(title: "인증 실패", message: "인증에 실패했습니다. 앱을 종료합니다.", preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
                                    exit(0)
                                }))
                            }
                        }
                    }
                } else {
                    let reason:String
                    //여러번 시도로 인증이 잠긴상태일 경우
                    if error?.code ==  LAError.Code.biometryLockout.rawValue {
                        reason = "인증시도 가능 횟수가 초과되었습니다.";
                    } else {
                        // Touch ID・Face ID를 사용할 수없는 경우
                        reason = "생체인증을 사용할 수 없습니다."
                    }
                    
                    authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: reason, reply: {
                        (success, error) in
                        switch success {
                        case true:
                            print("인증 성공")
                            self.loadedApp = true
                        case false:
                            print("인증 실패")
                            if let error = error {
                                print(error.localizedDescription)
                                let alertController = UIAlertController(title: "인증 실패", message: "인증에 실패했습니다. 앱을 종료합니다.", preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
                                    exit(0)
                                }))
                            }
                        }
                    })//evaluatePolicy
                }
            }//if currentUser
            else {
                self.loadedApp = true
            }
        }
        self.view.backgroundColor = UIColor(hexString: color)
    }
    
}
