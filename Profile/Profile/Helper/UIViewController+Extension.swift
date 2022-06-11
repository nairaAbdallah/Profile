//
//  UIViewController+Extension.swift
//  Profile
//
//  Created by naira bassam on 10/06/2022.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController: UIGestureRecognizerDelegate {
    
    func initActivityIndicator(activity: NVActivityIndicatorView) {
        activity.frame = CGRect(x: self.view.frame.size.width/2 - 25, y: self.view.frame.size.height/2 - 30, width: 50, height: 50)
        activity.type = .ballSpinFadeLoader
        activity.color = .label
        view.addSubview(activity)
        activity.startAnimating()
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func setUpBackBtn(){
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        let bkBtn = UIButton(frame: CGRect(x: 8, y: 0, width: 30, height: 30))
        bkBtn.setImage(UIImage(named: "backBtn"), for: .normal)
        bkBtn.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.barStyle = .default
        bkBtn.addTarget(self, action: #selector(bkBtnPressed), for: .touchUpInside)
        navigationItem.leftBarButtonItem =  UIBarButtonItem(customView: bkBtn)
    }
    
    func customNavLabel(labelText: String){
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.textAlignment = .center
        label.textColor = .label
        label.text = labelText
        self.navigationItem.titleView = label
        label.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 120).isActive = true
    }
    
    @objc func bkBtnPressed(){
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
}

var activityIndicatorView   = NVActivityIndicatorView(frame: .zero)
