//
//  UIView+Extension.swift
//  Profile
//
//  Created by naira bassam on 10/06/2022.
//

import UIKit

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
    func viewCorner(_ num: CGFloat){
        self.layer.cornerRadius = self.frame.size.height / num
        self.clipsToBounds = true
    }
}
