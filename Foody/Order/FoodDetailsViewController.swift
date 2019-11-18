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
	var gestureRecognizer: UITapGestureRecognizer!

	override func viewDidLoad() {
        super.viewDidLoad()

		foodNameLabel.text = "Testerah!"
		foodImageView.image = UIImage(imageLiteralResourceName: "foodExample")
		scrollView.minimumZoomScale = 1.0
		scrollView.maximumZoomScale = 4.0
		scrollView.addSubview(foodImageView)
		scrollView.delegate = self

		gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
		gestureRecognizer.numberOfTapsRequired = 2
		scrollView.addGestureRecognizer(gestureRecognizer)
    }

	@objc func handleDoubleTap() {
		if scrollView.zoomScale == 1 {
			scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: gestureRecognizer.location(in: gestureRecognizer.view)), animated: true)
		} else {
			scrollView.setZoomScale(1, animated: true)
			foodImageView.contentMode = .scaleAspectFill
		}
	}

	func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
		var zoomRect = CGRect.zero
		zoomRect.size.height = foodImageView.frame.size.height / scale
		zoomRect.size.width  = foodImageView.frame.size.width  / scale
		let newCenter = foodImageView.convert(center, from: scrollView)
		zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
		zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
		return zoomRect
	}

	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return foodImageView
	}


}
