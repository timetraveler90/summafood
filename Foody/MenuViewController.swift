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
                cell.contentView.layer.borderColor = UIColor.red.cgColor
                cell.contentView.layer.borderWidth = 5
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
            let selected = allDays[collectionView.tag][indexPath.item] as FoodName

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
        model.fetchData {
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    fileprivate func submit() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(orderTheFood))
    }

    @objc func orderTheFood() {
        let userID = UserDefaults.standard.integer(forKey: "userID")
        let url = "http://uc-dev.voiceworks.com:4000/external/user_orders"

        guard let mondayFood = selectedFood[0] else {
            return
        }
        let mondayFoodString = String(mondayFood)

        guard let tuesdayFood = selectedFood[1] else {
            return
        }
        let tuesdayFoodString = String(tuesdayFood)

        guard let wednesdayFood = selectedFood[2] else {
            return
        }
        let wednesdayFoodString = String(wednesdayFood)

        guard let thursdayFood = selectedFood[3] else {
            return
        }
        let thursdayFoodString = String(thursdayFood)

        guard let fridayFood = selectedFood[4] else {
            return
        }
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
        ] as [String: Any]

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
