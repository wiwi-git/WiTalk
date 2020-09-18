//
//  Color.swift
//  WiTalk
//
//  Created by 위대연 on 2020/07/01.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit
extension UIColor {
    static var my_chat_bubble: UIColor = UIColor(named: "MyBubble")!
    static var you_chat_bubble: UIColor = UIColor(named: "YouBubble")!
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let scanner = Scanner(string: hexString)

        scanner.scanLocation = 1
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: alpha
        )
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
