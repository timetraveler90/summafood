//
//  SettingsTableViewCell.swift
//  Foody
//
//  Created by Petar Stanisic on 10/29/19.
//  Copyright © 2019 Petar Stanisic. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

	@IBOutlet weak var sCollectionView: UICollectionView!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//extension SettingsTableViewCell {
//	func setCollectionViewDataSourceDelegate<D: UICollectionViewDelegate & UICollectionViewDataSource> (_ dataSourceDelegate: D, forRow row: Int) {
//		sCollectionView.delegate = dataSourceDelegate
//		sCollectionView.dataSource = dataSourceDelegate
//
//		sCollectionView.reloadData()
//	}
//}
