//
//  SettingsCollectionViewCell.swift
//  Foody
//
//  Created by Petar Stanisic on 10/29/19.
//  Copyright © 2019 Petar Stanisic. All rights reserved.
//

import UIKit

class SettingsCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet weak var settingFoodNameLabel: UILabel!

	@IBOutlet weak var view: UIView! {
		didSet {
			view.layer.cornerRadius = 0.5 * view.bounds.size.width
			view.layer.masksToBounds = true
		}
	}
}
