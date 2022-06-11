//
//  PhotosDetailsViewController.swift
//  Profile
//
//  Created by naira bassam on 11/06/2022.
//

import UIKit
import AudioToolbox

class PhotosDetailsViewController: UIViewController {
    //MARK: - Variables
    var imageScrollView: ImageScrollView?
    var initView: PhotosDetailsViewModel?{
        didSet{
            self.customNavLabel(labelText: initView?.title ?? "")
        }
    }
    var image: UIImage? {
        didSet{
            imageScrollView = ImageScrollView(frame: view.bounds)
            view.addSubview(imageScrollView ?? ImageScrollView())
            setupImageScrollView()
            self.imageScrollView?.set(image: image ?? UIImage())
        }
    }
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackBtn()
        setupShare()
    }
    
    //MARK: - setup image
    func setupImageScrollView() {
        imageScrollView?.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    //MARK: - setup shareing
    func setupShare(){
        let shareBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        shareBtn.setImage(UIImage(named: "Share"), for: .normal)
        shareBtn.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.barStyle = .default
        shareBtn.addTarget(self, action: #selector(shareBtnPressed), for: .touchUpInside)
        navigationItem.rightBarButtonItems =  [UIBarButtonItem(customView: shareBtn)]
    }
    @objc func shareBtnPressed(){
        let peek = SystemSoundID(1519)
        AudioServicesPlaySystemSound(peek)
        
        let imageShare = [ image ?? UIImage()]
        let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        
    }
}
