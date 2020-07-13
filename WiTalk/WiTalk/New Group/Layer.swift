//
//  VIew.swift
//  WiTalk
//
//  Created by 위대연 on 2020/07/14.
//  Copyright © 2020 위대연. All rights reserved.
//

import UIKit
extension CALayer {
    func addBorder(_ arr_edge:[UIRectEdge], color: UIColor, width: CGFloat){
        var edges = arr_edge
        if edges.count == 1 , edges[0] == .all {
            edges.removeAll()
            edges.append(.top)
            edges.append(.bottom)
            edges.append(.left)
            edges.append(.right)
        }
        for edge in edges{
            let border = CALayer()
            switch edge{
            case UIRectEdge.top:
                border.frame = CGRect(x: 0, y: 0, width: frame.width, height: width)
            case UIRectEdge.bottom:
                border.frame = CGRect(x: 0, y: frame.height - width, width: frame.width, height: width)
            case UIRectEdge.left:
                border.frame = CGRect(x: 0, y: 0, width: width, height: frame.height)
            case UIRectEdge.right:
                border.frame = CGRect(x: 0, y: frame.width - width, width: width, height: frame.height)
            default:
                break;
            }
            border.backgroundColor = color.cgColor
            self.addSublayer(border)
        }
    }
}
