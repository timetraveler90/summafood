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
//    let userId = UserDefaults.standard.string(forKey: "userID") ?? ""


    var selectedFood = [Int: Int]()


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
        if let menu = model.menu {
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

        if let menu = model.menu {
            let allDays = [menu.availableFood.monday, menu.availableFood.tuesday, menu.availableFood.wednesday, menu.availableFood.thursday, menu.availableFood.friday]

            let foodForThisDay = allDays[collectionView.tag] as [FoodName]
            let sortedFood = foodForThisDay.sorted { f1, f2 in

			   if (model.favoriteFood.contains(f1) && model.favoriteFood.contains(f2)) {
					return f1.id < f2.id
				}
				
                if (model.favoriteFood.contains(f1)) {
                    return true
                } else if (model.favoriteFood.contains(f2)) {
                    return false
				}
                return f1.id < f2.id
            }


			let food = sortedFood[indexPath.item] as FoodName
            cell.foodNameLabel.text = food.name

            if (selectedFood[collectionView.tag] == food.id) {
                cell.contentView.layer.borderColor = #colorLiteral(red: 0.6588235294, green: 0.9294117647, blue: 0.9176470588, alpha: 1)
                cell.contentView.layer.borderWidth = 8
            } else {
                cell.contentView.layer.borderWidth = 0
            }
        }

        return cell
    }



    func numberOfSections(in tableView: UITableView) -> Int {
        if let menu = model.menu {
            let allDays = [menu.availableFood.monday, menu.availableFood.tuesday, menu.availableFood.wednesday, menu.availableFood.thursday, menu.availableFood.friday]
            return allDays.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let menu = model.menu {
            let allDays = [menu.availableFood.monday, menu.availableFood.tuesday, menu.availableFood.wednesday, menu.availableFood.thursday, menu.availableFood.friday]

			let foodForThisDay = allDays[collectionView.tag] as [FoodName]
            let sortedFood = foodForThisDay.sorted { f1, f2 in

                if (model.favoriteFood.contains(f1) && model.favoriteFood.contains(f2)) {
                    return f1.id < f2.id
                }

                if (model.favoriteFood.contains(f1)) {
                    return true
                } else if (model.favoriteFood.contains(f2)) {
                    return false
                }
                return f1.id < f2.id
            }

            let selected = sortedFood[indexPath.item] as FoodName

            if (selectedFood[collectionView.tag] == selected.id) {
                selectedFood[collectionView.tag] = nil
            } else {
                selectedFood[collectionView.tag] = selected.id
            }

            collectionView.reloadData()
        }
    }


    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width:
        tableView.bounds.size.width, height: 28))
        headerLabel.textColor = UIColor.darkGray

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
		gamble()
        submit()
        model.fetchData {
            self.tableView.reloadData()
        }
		self.tabBarItem.image = UIImage(named: "menu")

		// date formating and displaying in the title
		let dateFormat = DateFormatter()
		dateFormat.dateFormat = "dd-MM-yy"
		let nextWeek = Date.today().next(.monday)
		let nextWeekFormated = dateFormat.string(from: nextWeek)

		self.title = "Orders for: \(nextWeekFormated)"
		self.navigationController?.title = "Menu"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		tableView.reloadData()
    }

	fileprivate func gamble() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "gamble"), style: .plain, target: self, action: #selector(randomizeTheFoodOrder))
    }

	@objc func randomizeTheFoodOrder() {
        let userID = UserDefaults.standard.integer(forKey: "userID")
        let url = "http://uc-dev.voiceworks.com:4000/external/user_orders"


		let alert = UIAlertController(
			title: "Food roulette!",
			message: "Are you really sure you want to gamble with your order?",
			preferredStyle: .alert
		)

		let cancel = UIAlertAction(
			title: "Cancel",
			style: .destructive,
			handler: nil)

		let gamble = UIAlertAction(
			title: "Gamble!",
			style: .default,
			handler: { _ in
				DispatchQueue.main.async {
					if let menu = model.menu {
						let numbersToSkip = [120, 25, 114, 107, 95, 88, 84, 74, 66, 49, 43, 38, 16]
						var mondayFoodString : String = ""
						var tuesdayFoodString : String = ""
						var wednesdayFoodString : String = ""
						var thursdayFoodString : String = ""
						var fridayFoodString : String = ""

						let mondayRange = 2...menu.availableFood.monday.count
						let tuesdayRange = 2...menu.availableFood.tuesday.count
						let wednesdayRange = 2...menu.availableFood.wednesday.count
						let thursdayRange = 2...menu.availableFood.thursday.count
						let fridayRange = 2...menu.availableFood.friday.count

						for n in numbersToSkip {
							if mondayRange.contains(n) {
								let mondayFood = Int.random(in: mondayRange)
								mondayFoodString = String(mondayFood)
							}
						}

						for n in numbersToSkip {
							if tuesdayRange.contains(n) {
								let mondayFood = Int.random(in: tuesdayRange)
								tuesdayFoodString = String(mondayFood)
							}
						}

						for n in numbersToSkip {
							if wednesdayRange.contains(n) {
								let mondayFood = Int.random(in: wednesdayRange)
								wednesdayFoodString = String(mondayFood)
							}
						}

						for n in numbersToSkip {
							if thursdayRange.contains(n) {
								let mondayFood = Int.random(in: thursdayRange)
								thursdayFoodString = String(mondayFood)
							}
						}

						for n in numbersToSkip {
							if fridayRange.contains(n) {
								let mondayFood = Int.random(in: fridayRange)
								fridayFoodString = String(mondayFood)
							}
						}

						let foodDict = [
							"monday": mondayFoodString,
							"tuesday": tuesdayFoodString,
							"wednesday": wednesdayFoodString,
							"thursday": thursdayFoodString,
							"friday": fridayFoodString
						]

						let parameters = [
							"user_id": userID,
							"offered_meal": foodDict
						] as [String : Any]

						Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
								.validate(statusCode: 200..<600)
								.responseJSON { response in

									print(NSString(data: (response.request?.httpBody)!, encoding: String.Encoding.utf8.rawValue)!)
									let alert = UIAlertController(title: "Success!", message: "Head to Orders tab to see what you've got!", preferredStyle: .alert)
									alert.addAction(UIAlertAction(title: "Done!", style: .default, handler: nil))
									self.present(alert, animated: true, completion: nil)
								}
					}
				}
		})

		alert.addAction(gamble)
		alert.addAction(cancel)
		alert.preferredAction = gamble
		self.present(alert, animated: true, completion: nil)

    }

    fileprivate func submit() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(orderTheFood))
    }

    @objc func orderTheFood() {
        let userID = UserDefaults.standard.integer(forKey: "userID")
        let url = "http://uc-dev.voiceworks.com:4000/external/user_orders"

		let mondayFood = selectedFood[0] ?? 1
        let mondayFoodString = String(mondayFood)

		let tuesdayFood = selectedFood[1] ?? 1
        let tuesdayFoodString = String(tuesdayFood)

		let wednesdayFood = selectedFood[2] ?? 1
        let wednesdayFoodString = String(wednesdayFood)

		let thursdayFood = selectedFood[3] ?? 1
        let thursdayFoodString = String(thursdayFood)

		let fridayFood = selectedFood[4] ?? 1
        let fridayFoodString = String(fridayFood)

        let foodDict = [
			"monday": mondayFoodString,
            "tuesday": tuesdayFoodString,
			"wednesday": wednesdayFoodString,
            "thursday": thursdayFoodString,
            "friday": fridayFoodString
        ]

        let parameters = [
            "user_id": userID,
            "offered_meal": foodDict
		] as [String : Any]

        let header = ["Content-Type": "application/json",
                      "Accept": "application/json"
        ]

        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header)
                .validate(statusCode: 200..<600)
                .responseJSON { response in

                    let alert = UIAlertController(title: "Success", message: "The form is successfully submited.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Done!", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
    }
}
