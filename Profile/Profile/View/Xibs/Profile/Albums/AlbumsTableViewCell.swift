//
//  AlbumsTableViewCell.swift
//  Profile
//
//  Created by naira bassam on 10/06/2022.
//

import UIKit

class AlbumsTableViewCell: UITableViewCell {
    //MARK: - Variables
    var albumsTitle: AlbumsViewModel?{
        didSet{
            self.albumName.text = albumsTitle?.title ?? ""
        }
    }
    
    //MARK: - IBOutlets
    @IBOutlet weak var albumName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
}
