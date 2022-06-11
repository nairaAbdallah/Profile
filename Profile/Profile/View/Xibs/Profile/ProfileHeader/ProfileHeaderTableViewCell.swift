//
//  ProfileHeaderTableViewCell.swift
//  Profile
//
//  Created by naira bassam on 10/06/2022.
//

import UIKit

class ProfileHeaderTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    var profileDetails: UsersDetailsViewModel?{
        didSet{
            self.userName.text = profileDetails?.name ?? ""
            self.address.text = "\(profileDetails?.street ?? ""), \(profileDetails?.suite ?? ""), \(profileDetails?.city ?? ""), \(profileDetails?.zipcode ?? "")"
        }
    }
    //MARK: - IBOutlets
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var address: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
}
