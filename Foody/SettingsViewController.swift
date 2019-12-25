//
//  SettingsViewController.swift
//  Foody
//
//  Created by Petar Stanisic on 10/23/19.
//  Copyright © 2019 Petar Stanisic. All rights reserved.
//

import UIKit
import KeychainSwift

class SettingsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var logoutButton: UIButton!
    let keychainUsername = "username"
    let keychainPassword = "password"

    lazy var foodList: [FoodName] = {
        if let menu = model.menu {
            let allDays: [FoodName] = [menu.availableFood.monday,
                                       menu.availableFood.tuesday,
                                       menu.availableFood.wednesday,
                                       menu.availableFood.thursday,
                                       menu.availableFood.friday].flatMap { $0 }

			let uniqueFoodSet = Set(allDays)
            let uniqueFoodSorted = Array(uniqueFoodSet).sorted { (f1: FoodName, f2: FoodName) in
                f1.id < f2.id
            }
			return uniqueFoodSorted
        }
        return []
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationController?.title = "Favorite food"
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        foodList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingsCollectionViewCell", for: indexPath) as! SettingsCollectionViewCell
        let label = cell.viewWithTag(10) as! UILabel
        let food = foodList[indexPath.item]
        label.text = "\(food.name)"

        if (model.favoriteFood.contains(food)) {
            cell.contentView.layer.borderWidth = 4
			cell.contentView.layer.borderColor = #colorLiteral(red: 0.6588235294, green: 0.9294117647, blue: 0.9176470588, alpha: 1)
        } else {
            cell.contentView.layer.borderWidth = 0
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedFood = foodList[indexPath.item]

        if (model.favoriteFood.contains(selectedFood)) {
            model.favoriteFood.remove(selectedFood)
        } else {
            model.favoriteFood.insert(selectedFood)
        }

        let cell = collectionView.cellForItem(at: indexPath) as! SettingsCollectionViewCell
        if (model.favoriteFood.contains(selectedFood)) {
            cell.contentView.layer.borderWidth = 4
            cell.contentView.layer.borderColor = #colorLiteral(red: 0.9960784314, green: 0.8392156863, blue: 0.8901960784, alpha: 1)
        } else {
            cell.contentView.layer.borderWidth = 0
        }
    }

    @IBAction func logoutButtonPressed(_ sender: Any) {
        // removing of userId after logout
        UserDefaults.standard.setValue(nil, forKey: "userID")

        let keychain = KeychainSwift()
        keychain.delete(keychainUsername)
        keychain.delete(keychainPassword)
        keychain.clear()

        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = mainStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDel.window?.rootViewController = loginVC

    }

}

class GradientButton: UIButton {
    override func awakeFromNib() {

        layoutIfNeeded()

        let gradientBorder = CAGradientLayer()
        gradientBorder.frame = bounds
        gradientBorder.startPoint = CGPoint(x: 0, y: 0.5)
        gradientBorder.endPoint = CGPoint(x: 1, y: 0.5)
		let color1 = #colorLiteral(red: 0.1882352941, green: 0.8117647059, blue: 0.8156862745, alpha: 1).cgColor
		let color2 = #colorLiteral(red: 0.2, green: 0.03137254902, blue: 0.4039215686, alpha: 1).cgColor
        gradientBorder.colors = [color1, color2]

        let shape = CAShapeLayer()
        shape.lineWidth = 2
        shape.path = UIBezierPath(rect: bounds).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradientBorder.mask = shape

        layer.addSublayer(gradientBorder)

        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.colors = [color1, color2]

        layer.insertSublayer(gradient, at: 0)

        let overlayView = UIView(frame: bounds)
        overlayView.isUserInteractionEnabled = false
        overlayView.layer.insertSublayer(gradient, at: 0)
        overlayView.mask = titleLabel

        addSubview(overlayView)
    }
}
