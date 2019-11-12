//
//  OrderViewController.swift
//  Foody
//
//  Created by Petar Stanisic on 10/23/19.
//  Copyright © 2019 Petar Stanisic. All rights reserved.
//

import UIKit
import Alamofire

class OrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!
	let url = "http://uc-dev.voiceworks.com:4000/external/ordered_food/12"
	private var orders = [Order]()


	struct Order: Codable {
		let monday, tuesday, wednesday, thursday, friday: String


		enum CodingKeys: String, CodingKey {
			case wednesday = "Wednesday"
			case tuesday = "Tuesday"
			case thursday = "Thursday"
			case monday = "Monday"
			case friday = "Friday"
		}
	}

	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.tableFooterView = UIView(frame: .zero)
		fetchJSON()
    }

	fileprivate func fetchJSON() {
		let urlString = "http://uc-dev.voiceworks.com:4000/external/ordered_food/12"
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
					self.orders = try [decoder.decode(Order.self, from: data)]
					print(self.orders.capacity)

					self.tableView.reloadData()
				} catch let jsonErr {
					print("Failed to decode: ", jsonErr)
				}

			}
		}.resume()
	}

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 5
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return orders.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell") as! OrderTableViewCell

		let food = orders[indexPath.row]

		if indexPath.section == 0 {
			cell.textLabel?.text = food.monday
		} else if indexPath.section == 1 {
			cell.textLabel?.text = food.tuesday
		} else if indexPath.section == 2 {
			cell.textLabel?.text = food.wednesday
		} else if indexPath.section == 3 {
			cell.textLabel?.text = food.thursday
		} else if indexPath.section == 4 {
			cell.textLabel?.text = food.friday
		}


		return cell
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.performSegue(withIdentifier: "foodDetailsSegue", sender: nil)
	}

}
