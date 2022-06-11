//
//  AlbumCollectionViewCell.swift
//  Profile
//
//  Created by naira bassam on 11/06/2022.
//

import UIKit
import Kingfisher

class AlbumCollectionViewCell: UICollectionViewCell {
    var imagePressed: (() -> Void)?
    var initPhoto: String?{
        didSet{
            if let url = URL(string:((initPhoto ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))! ){
                albumImage.kf.setImage(with: url, placeholder:UIImage(named: "placeHolder"))
            }else{
                albumImage.image = UIImage(named: "placeHolder")
            }
        }
    }
    
    //MARK: - IBOutlets
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var heightImage: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        [imageWidth,heightImage].forEach{ image in
            image?.constant = UIScreen.main.bounds.width/3
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        contentView.addGestureRecognizer(tapGesture)
    }
    @objc func tapGestureHandler() {
        imagePressed?()
    }
}
