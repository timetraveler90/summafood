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
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension MenuTableViewCell {
	func setCollectionViewDataSourceDelegate <D: UICollectionViewDelegate & UICollectionViewDataSource> (_ dataSourceDelegate: D, forRow row: Int) {
		clCollectionView.delegate = dataSourceDelegate
		clCollectionView.dataSource = dataSourceDelegate

		clCollectionView.reloadData()
	}
}
