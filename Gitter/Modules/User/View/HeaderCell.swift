//
//  HeaderCell.swift
//  Gitter
//
//  Created by MacBook Pro on 5/15/22.
//

import UIKit

class HeaderCell: UITableViewCell, ConfigurableCells {
    
    static var reuseIdentifier: String = nameOfClass
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var employer: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var bio: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.contentMode = .scaleAspectFill
        userImage.backgroundColor = .quaternarySystemFill
        userImage.layer.cornerRadius = 10
        userImage.clipsToBounds = true
        
        userAvatar.tintColor = .systemGray3
        userAvatar.alpha = 1
        
        employer.font = .preferredFont(forTextStyle: .caption2)
        fullName.font = .preferredFont(forTextStyle: .subheadline)
        bio.font = .preferredFont(forTextStyle: .headline)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        fullName.isHidden = false
        bio.isHidden = false
        employer.isHidden = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func build(with data: User) {
        if data.company == nil {
            employer.isHidden = true
        }
        
        if data.bio == nil {
            bio.isHidden = true
        }
        
        if data.name == nil {
            fullName.isHidden = true
        }
        
        employer.text = "Company: \(data.company ?? "")"
        fullName.text = "Name: \(data.name ?? "")"
        bio.text = data.bio
        
        if let avatarURL = data.avatar_url {
            userImage.sd_setImage(with: URL(string: avatarURL), completed: {[weak self] (_,error,_,_) in
                guard let `self` = self else { return }
                if error == nil {
                    self.userAvatar.alpha = 0
                }
            })
        }
    }
}
