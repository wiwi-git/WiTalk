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

class LoadingVC: UIViewController {
    var box = UIImageView()
    var remoteConfig: RemoteConfig!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            let loginVc = self.storyboard?.instantiateViewController(withIdentifier: LoginVC.sb_id) as! LoginVC
            loginVc.modalPresentationStyle = .fullScreen
            self.present(loginVc, animated: false, completion: nil)
        }
        self.view.backgroundColor = UIColor(hexString: color)
    }

}
