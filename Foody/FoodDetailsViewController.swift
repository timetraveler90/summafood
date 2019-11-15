//
//  FoodDetailsViewController.swift
//  Foody
//
//  Created by Petar Stanisic on 10/28/19.
//  Copyright © 2019 Petar Stanisic. All rights reserved.
//

import UIKit

class FoodDetailsViewController: UIViewController, UIScrollViewDelegate {

	@IBOutlet weak var foodImageView: UIImageView!
	@IBOutlet weak var foodNameLabel: UILabel!
	@IBOutlet weak var scrollView: UIScrollView!


	override func viewDidLoad() {
        super.viewDidLoad()

		foodNameLabel.text = "Testerah!"
		foodImageView.image = UIImage(imageLiteralResourceName: "foodExample")
		scrollView.minimumZoomScale = 0.5
		scrollView.maximumZoomScale = 4.0
//		scrollView.zoomScale = 1.
		scrollView.addSubview(foodImageView)
		scrollView.delegate = self
    }

	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return foodImageView
	}
	func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
		self.scrollView.setZoomScale(1.0, animated: true)
	}


}
