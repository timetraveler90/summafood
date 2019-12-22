//
//  SettingsViewController.swift
//  Foody
//
//  Created by Petar Stanisic on 10/23/19.
//  Copyright © 2019 Petar Stanisic. All rights reserved.
//

import UIKit
import KeychainSwift

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {


	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var logoutButton: UIButton!
	let keychainUsername = "username"
	let keychainPassword = "password"

	@IBAction func logoutButtonPressed(_ sender: Any) {
		// removing of userId after logout
		UserDefaults.standard.setValue(nil, forKey: "userID")

		let keychain = KeychainSwift()
		keychain.delete(keychainUsername)
		keychain.delete(keychainPassword)
		keychain.clear()

		let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
		let loginVC = mainStoryBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
		let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
		appDel.window?.rootViewController = loginVC 

	}

	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.tableFooterView = UIView(frame: .zero)
    }

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell") as! SettingsTableViewCell
		cell.sCollectionView.delegate = self
		cell.sCollectionView.dataSource = self
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 10
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingsCollectionViewCell", for: indexPath) as! SettingsCollectionViewCell

		cell.settingFoodNameLabel.text = "ParalelopitetParalelopitetParalelopitetParalelopitet"
		return cell
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Select favorite food"
	}




}
