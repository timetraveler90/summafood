//
//  MenuViewController.swift
//  Foody
//
//  Created by Petar Stanisic on 10/22/19.
//  Copyright © 2019 Petar Stanisic. All rights reserved.
//

import UIKit
import Alamofire

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

	@IBOutlet weak var tableView: UITableView!
	let userId = UserDefaults.standard.string(forKey: "userID") ?? ""
	private var menu: Menu?

	var selectedFood = [Int:Int]()

	// MARK: - Menu
	struct Menu: Codable {
		let availableFood: AvailableFood

		enum CodingKeys: String, CodingKey {
			case availableFood = "available_food"
		}
	}

	// MARK: - AvailableFood
	struct AvailableFood: Codable {
		let wednesday, tuesday, thursday, monday, friday: [FoodName]

		enum CodingKeys: String, CodingKey {
			case wednesday = "Wednesday"
			case tuesday = "Tuesday"
			case thursday = "Thursday"
			case monday = "Monday"
			case friday = "Friday"
		}
	}

	// MARK: - Day
	struct FoodName: Codable {
		let name: String
		let id: Int
	}


	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
		cell.clCollectionView.dataSource = self
		cell.clCollectionView.delegate = self
		cell.clCollectionView.tag = indexPath.section
		cell.clCollectionView.reloadData()
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if let menu = menu {
			if collectionView.tag == 0 {
				return menu.availableFood.monday.count
			} else if collectionView.tag == 1 {
				return menu.availableFood.tuesday.count
			} else if collectionView.tag == 2 {
				return menu.availableFood.wednesday.count
			} else if collectionView.tag == 3 {
				return menu.availableFood.thursday.count
			} else if collectionView.tag == 4 {
				return menu.availableFood.friday.count
			}
		}
		return 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath) as! MenuCollectionViewCell
		cell.layer.cornerRadius = 8

		if let menu = menu {
			let allDays = [menu.availableFood.monday, menu.availableFood.tuesday, menu.availableFood.wednesday, menu.availableFood.thursday, menu.availableFood.friday]
			let food = allDays[collectionView.tag][indexPath.item] as FoodName
			cell.foodNameLabel.text = food.name

			if(selectedFood[collectionView.tag] == food.id) {
				cell.contentView.layer.borderColor = UIColor.red.cgColor
				cell.contentView.layer.borderWidth = 5
			}else{
				cell.contentView.layer.borderWidth = 0
			}

//			if collectionView.tag == 0 {
//				let foodName = menu.availableFood.monday[indexPath.item]
//				cell.foodNameLabel.text = foodName.name
//			} else if collectionView.tag == 1 {
//				let foodName = menu.availableFood.tuesday[indexPath.item]
//				cell.foodNameLabel.text = foodName.name
//			} else if collectionView.tag == 2 {
//				let foodName = menu.availableFood.wednesday[indexPath.item]
//				cell.foodNameLabel.text = foodName.name
//			} else if collectionView.tag == 3 {
//				let foodName = menu.availableFood.thursday[indexPath.item]
//				cell.foodNameLabel.text = foodName.name
//			} else if collectionView.tag == 4 {
//				let foodName = menu.availableFood.friday[indexPath.item]
//				cell.foodNameLabel.text = foodName.name
//			}
		}



		return cell
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		if let menu = menu {
			let allDays = [menu.availableFood.monday, menu.availableFood.tuesday, menu.availableFood.wednesday, menu.availableFood.thursday, menu.availableFood.friday]
			return allDays.count
		}
		return 0
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let menu = menu {
			let allDays = [menu.availableFood.monday, menu.availableFood.tuesday, menu.availableFood.wednesday, menu.availableFood.thursday, menu.availableFood.friday]
			let selected = allDays[collectionView.tag][indexPath.item] as FoodName
			print("IZABRANA: \(selected.name)")

			if(selectedFood[collectionView.tag] == selected.id) {
				selectedFood[collectionView.tag] = nil
			}else{
				selectedFood[collectionView.tag] = selected.id
			}

			collectionView.reloadData()
		}


//		if let menu = menu {

//			if collectionView.tag == 0 {
//				selectedFood = menu.availableFood.monday[indexPath.item]
//				cell.foodNameLabel.text = foodName.name
//			} else if collectionView.tag == 1 {
//				let foodName = menu.availableFood.tuesday[indexPath.item]
//				cell.foodNameLabel.text = foodName.name
//			} else if collectionView.tag == 2 {
//				let foodName = menu.availableFood.wednesday[indexPath.item]
//				cell.foodNameLabel.text = foodName.name
//			} else if collectionView.tag == 3 {
//				let foodName = menu.availableFood.thursday[indexPath.item]
//				cell.foodNameLabel.text = foodName.name
//			} else if collectionView.tag == 4 {
//				let foodName = menu.availableFood.friday[indexPath.item]
//				cell.foodNameLabel.text = foodName.name
//			}
//		}

	}


	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = UIView()
		headerView.backgroundColor = UIColor.clear
		let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width:
			   tableView.bounds.size.width, height: 28))
		   headerLabel.textColor = UIColor.black

		if section == 0 {
			headerLabel.text = "Monday"
		} else if section == 1 {
			headerLabel.text = "Tuesday"
		} else if section == 2 {
			headerLabel.text = "Wednesday"
		} else if section == 3 {
			headerLabel.text = "Thursday"
		} else if section == 4 {
			headerLabel.text = "Friday"
		}

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
		submit()
		fetchJSON()
    }

	fileprivate func submit() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(orderTheFood))
	}

	@objc func orderTheFood() {
		let alert = UIAlertController(title: "Submited", message: "Submiting the form", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)

		let userID = UserDefaults.standard.integer(forKey: "userID")
		let url = "http://uc-dev.voiceworks.com:4000/external/user_orders"

		let parameters = [
			"user_id":userID,
			"offered_meal":[
				"monday":selectedFood[0] ?? 1,
				"tuesday":selectedFood[1] ?? 1,
				"wednesday":selectedFood[2] ?? 1,
				"thursday":selectedFood[3] ?? 1,
				"friday":selectedFood[4] ?? 1]
			] as [String : Any]

		let header = ["Content-Type": "application/json",
					  "Accept": "application/json"]

		Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header)
			.validate(statusCode: 200..<600)
			.responseJSON { response in

				switch response.result {
				case.failure(let error):
					print("Failed due to the: \(error)")
				case .success(let value):
					print("Succeded, the value is \(value)")
				}
		}
	}


	fileprivate func fetchJSON() {
		let urlString = "http://uc-dev.voiceworks.com:4000/external/available_food/\(userId)"
		guard let url = URL(string: urlString) else { return }

//		URLSession.shared.dataTask(with: url) { (data, _, err) in
		Alamofire.request(url, method: .get).responseJSON { response in
			DispatchQueue.main.async {
//				if let err = err {
//					print("Failed to get data from URL: ", err)
//					return
//				}

				guard let data = response.data else { return }
				let decoder = JSONDecoder()

				do {
					self.menu = try decoder.decode(Menu.self, from: data)
					self.tableView.reloadData()

				} catch let jsonErr {
					print("Failed to decode: ", jsonErr)
				}

			}
		}
	}



}
