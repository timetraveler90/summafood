//
//  FoodDetailsViewController.swift
//  Foody
//
//  Created by Petar Stanisic on 10/28/19.
//  Copyright © 2019 Petar Stanisic. All rights reserved.
//

import UIKit

class FoodDetailsViewController: UIViewController {

	@IBOutlet weak var foodImageView: UIImageView!
	@IBOutlet weak var foodNameLabel: UILabel!

	override func viewDidLoad() {
        super.viewDidLoad()

		foodNameLabel.text = "Kurcina"
    }



}
