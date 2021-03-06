//
//  OrderViewController.swift
//  Foody
//
//  Created by Petar Stanisic on 10/23/19.
//  Copyright © 2019 Petar Stanisic. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices

class OrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!
	let userId = UserDefaults.standard.string(forKey: "userID") ?? ""
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

		// date formating and displaying in the title
		let dateFormat = DateFormatter()
		dateFormat.dateFormat = "dd-MM-yy"
		let nextWeek = Date.today().next(.monday)
		let nextWeekFormated = dateFormat.string(from: nextWeek)

		self.title = "Orders for: \(nextWeekFormated)"
		self.navigationController?.title = "Orders"

    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		fetchJSON()
		tableView.reloadData()
	}

	fileprivate func fetchJSON() {
		let urlString = "http://uc-dev.voiceworks.com:4000/external/ordered_food/\(userId)"
		guard let url = URL(string: urlString) else { return }

		Alamofire.request(url, method: .get).validate().responseJSON { response in

			guard let data = response.data else { return }
				let decoder = JSONDecoder()

				do {
					self.orders = try [decoder.decode(Order.self, from: data)]

					self.tableView.reloadData()
				} catch let jsonErr {
					print("Failed to decode: ", jsonErr)
				}
		}
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

		let food = orders[indexPath.row]

		if indexPath.section == 0 {
			let filteredStringMonday = food.monday.replaceBlankWithPlus().replacingOccurrences(of: "š", with: "s")
																		.replacingOccurrences(of: "ć", with: "c")
																		.replacingOccurrences(of: "č", with: "c")
																		.replacingOccurrences(of: "ž", with: "z")
																		.replacingOccurrences(of: "đ", with: "dj")
			guard let mondayUrl = URL(string: "https://www.google.com/search?q=\(filteredStringMonday)") else { return }
			let vc = SFSafariViewController(url: mondayUrl)
			present(vc, animated: true, completion: nil)
		} else if indexPath.section == 1 {
			let filteredStringTuesday = food.tuesday.replaceBlankWithPlus().replacingOccurrences(of: "š", with: "s")
																			.replacingOccurrences(of: "ć", with: "c")
																			.replacingOccurrences(of: "č", with: "c")
																			.replacingOccurrences(of: "ž", with: "z")
																			.replacingOccurrences(of: "đ", with: "dj")
			guard let tuesdayUrl = URL(string: "https://www.google.com/search?q=\(filteredStringTuesday)") else { return }
			let vc = SFSafariViewController(url: tuesdayUrl)
			present(vc, animated: true, completion: nil)
		} else if indexPath.section == 2 {
			let filteredStringWednesday = food.wednesday.replaceBlankWithPlus().replacingOccurrences(of: "š", with: "s")
																			.replacingOccurrences(of: "ć", with: "c")
																			.replacingOccurrences(of: "č", with: "c")
																			.replacingOccurrences(of: "ž", with: "z")
																			.replacingOccurrences(of: "đ", with: "dj")
			guard let wednesdayUrl = URL(string: "https://www.google.com/search?q=\(filteredStringWednesday)") else { return }
			let vc = SFSafariViewController(url: wednesdayUrl)
			present(vc, animated: true, completion: nil)
		} else if indexPath.section == 3 {
			let filteredStringThursday = food.thursday.replaceBlankWithPlus().replacingOccurrences(of: "š", with: "s")
																			.replacingOccurrences(of: "ć", with: "c")
																			.replacingOccurrences(of: "č", with: "c")
																			.replacingOccurrences(of: "ž", with: "z")
																			.replacingOccurrences(of: "đ", with: "dj")
			guard let thursdayUrl = URL(string: "https://www.google.com/search?q=\(filteredStringThursday)") else { return }
			let vc = SFSafariViewController(url: thursdayUrl)
			present(vc, animated: true, completion: nil)
		} else if indexPath.section == 4 {
			let filteredStringFriday = food.friday.replaceBlankWithPlus().replacingOccurrences(of: "š", with: "s")
																		.replacingOccurrences(of: "ć", with: "c")
																		.replacingOccurrences(of: "č", with: "c")
																		.replacingOccurrences(of: "ž", with: "z")
																		.replacingOccurrences(of: "đ", with: "dj")
			guard let fridayUrl = URL(string: "https://www.google.com/search?q=\(filteredStringFriday)") else { return }
			let vc = SFSafariViewController(url: fridayUrl)
			present(vc, animated: true, completion: nil)
		}
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
			case 0: return "Monday"
			case 1: return "Tuesday"
			case 2: return "Wednesday"
			case 3: return "Thursday"
			case 4: return "Friday"
			default: return ""
		}
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 25
	}

}

extension Date {

  static func today() -> Date {
      return Date()
  }

  func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.next,
               weekday,
               considerToday: considerToday)
  }

  func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.previous,
               weekday,
               considerToday: considerToday)
  }

  func get(_ direction: SearchDirection,
           _ weekDay: Weekday,
           considerToday consider: Bool = false) -> Date {

    let dayName = weekDay.rawValue

    let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }

    assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")

    let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1

    let calendar = Calendar(identifier: .gregorian)

    if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
      return self
    }

    var nextDateComponent = calendar.dateComponents([], from: self)
    nextDateComponent.weekday = searchWeekdayIndex

    let date = calendar.nextDate(after: self,
                                 matching: nextDateComponent,
                                 matchingPolicy: .nextTime,
                                 direction: direction.calendarSearchDirection)


    return date!
  }

}

// MARK: Helper methods
extension Date {
  func getWeekDaysInEnglish() -> [String] {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "en_US_POSIX")
    return calendar.weekdaySymbols
  }

  enum Weekday: String {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
  }

  enum SearchDirection {
    case next
    case previous

    var calendarSearchDirection: Calendar.SearchDirection {
      switch self {
      case .next:
        return .forward
      case .previous:
        return .backward
      }
    }
  }
}

extension String {
   func replace(string:String, replacement:String) -> String {
	   return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
   }

   func replaceBlankWithPlus() -> String {
	   return self.replace(string: " ", replacement: "+")
   }
 }
