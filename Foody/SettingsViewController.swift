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
                                       menu.availableFood.friday].flatMap {
                $0
            }

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
        self.title = "Select favorite food"
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        foodList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingsCollectionViewCell", for: indexPath) as! SettingsCollectionViewCell
        let label = cell.viewWithTag(10) as! UILabel
        let food = foodList[indexPath.item]
        label.text = "\(food.id): \(food.name)"

        if (model.favoriteFood.contains(food)) {
            cell.contentView.layer.borderWidth = 2
            cell.contentView.layer.borderColor = UIColor.red.cgColor
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
            cell.contentView.layer.borderWidth = 2
            cell.contentView.layer.borderColor = UIColor.red.cgColor
        } else {
            cell.contentView.layer.borderWidth = 0
        }
    }

    // MARK: Actions

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
