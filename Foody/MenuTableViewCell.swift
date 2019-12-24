//
//  MenuTableViewCell.swift
//  Foody
//
//  Created by Petar Stanisic on 10/25/19.
//  Copyright © 2019 Petar Stanisic. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

	@IBOutlet weak var clCollectionView: UICollectionView!
	@IBOutlet weak var containerView: UIView! {
		didSet {
			containerView.layer.cornerRadius = 10
			containerView.layer.shadowOpacity = 1
			containerView.layer.shadowRadius = 2
			containerView.layer.shadowColor = UIColor(red: 255, green: 165, blue: 0, alpha: 1).cgColor
			containerView.layer.shadowOffset = CGSize(width: 3, height: 3)
			containerView.layer.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1).cgColor
			containerView.layer.masksToBounds = true
		}
	}

	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
