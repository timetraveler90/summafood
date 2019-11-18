//
//  MenuViewController.swift
//  Foody
//
//  Created by Petar Stanisic on 10/22/19.
//  Copyright © 2019 Petar Stanisic. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

	@IBOutlet weak var tableView: UITableView!
	let userId = UserDefaults.standard.string(forKey: "userID") ?? ""
	private var availableFood = [Order]()

	struct Order: Codable {
		let permission: String
		let check: Int
		let availableFood: AvailableFood

		enum CodingKeys: String, CodingKey {
			case permission, check
			case availableFood = "available_food"
		}
	}

	// MARK: - AvailableFood
	struct AvailableFood: Codable {
		let wednesday, tuesday, thursday, monday: [Day]
		let friday: [Day]

		enum CodingKeys: String, CodingKey {
			case wednesday = "Wednesday"
			case tuesday = "Tuesday"
			case thursday = "Thursday"
			case monday = "Monday"
			case friday = "Friday"
		}
	}

	// MARK: - Day
	struct Day: Codable {
		let name: String
		let id: Int
	}


	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 10
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath) as! MenuCollectionViewCell
		return cell
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 5
	}


	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = UIView()
		headerView.backgroundColor = UIColor.clear
		let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width:
			   tableView.bounds.size.width, height: 28))
		   headerLabel.textColor = UIColor.black
		   headerLabel.text = "\(section)"
		   headerLabel.textAlignment = .center
		   headerView.addSubview(headerLabel)
		return headerView
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 30
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.separatorStyle = .none
		fetchJSON()
		submit()
    }

	fileprivate func submit() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(orderTheFood))
	}

	@objc func orderTheFood() {
		let alert = UIAlertController(title: "Submited", message: "Submiting the form", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}


	fileprivate func fetchJSON() {
		let urlString = "http://uc-dev.voiceworks.com:4000/external/available_food/\(userId)"
		guard let url = URL(string: urlString) else { return }

		URLSession.shared.dataTask(with: url) { (data, _, err) in
			DispatchQueue.main.async {
				if let err = err {
					print("Failed to get data from URL: ", err)
					return
				}

				guard let data = data else { return }
				let decoder = JSONDecoder()

				do {
					self.availableFood = try [decoder.decode(Order.self, from: data)]
					dump(self.availableFood)
				} catch let jsonErr {
					print("Failed to decode: ", jsonErr)
				}

			}
		}.resume()
	}



}
