//
//  TabCell.swift
//  Gitter
//
//  Created by MacBook Pro on 5/15/22.
//

import UIKit

class TabCell: UITableViewCell, ConfigurableCells {
    
    static var reuseIdentifier: String = nameOfClass
    
    @IBOutlet weak var tabContainer: UIStackView!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var followings: UILabel!
    
    var onTappedFollowing: (() -> Void)?
    var onTappedFollowers: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        followers.text = "Followers"
        followings.text = "Followings"
        followers.font = .preferredFont(forTextStyle: .caption2).withSize(14)
        followings.font = .preferredFont(forTextStyle: .caption2).withSize(14)
        
        followers.isUserInteractionEnabled = true
        followings.isUserInteractionEnabled = true
        
        followers.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TabCell.onTappedFollowers(_:))))
        followings.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TabCell.onTappedFollowing(_:))))
        
        /// make followers tab active as its the first highlighted tab
        followers.font = .boldSystemFont(ofSize: 14)
        followings.textColor = .secondaryLabel
        followers.textColor = .label
        followings.font = .preferredFont(forTextStyle: .caption2).withSize(14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func build(with data: User) {
    }
    
    @IBAction func onTappedFollowing(_ sender: Any){
        onTappedFollowing?()
    }
    
    @IBAction func onTappedFollowers(_ sender: Any){
        onTappedFollowers?()
    }
    
}
