//
//  UserCell.swift
//  Gitter
//
//  Created by MacBook Pro on 5/14/22.
//

import UIKit

class UserCell: UITableViewCell, ConfigurableCells {

    static var reuseIdentifier: String = nameOfClass
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var separatorLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userName.font = .preferredFont(forTextStyle: .subheadline).withSize(17)
        userImage.backgroundColor = .systemGray5
        userImage.layer.cornerRadius = userImage.bounds.height / 2
        userImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func build(with data: User) {
        userName.text = data.login
        if let avatarURL = data.avatar_url {
            userImage.sd_setImage(with: .init(string: avatarURL))
        }
    }
}
