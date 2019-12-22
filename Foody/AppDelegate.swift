//
//  AppDelegate.swift
//  Foody
//
//  Created by Petar Stanisic on 8/27/19.
//  Copyright © 2019 Petar Stanisic. All rights reserved.
//

import UIKit
import Alamofire
import KeychainSwift

var model = (UIApplication.shared.delegate as! AppDelegate).mainModel

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var mainModel = Model()
	let url = "http://uc-dev.voiceworks.com:4000/external/signin"
	private let keychain = KeychainSwift()
	let keychainUsername = "username"
	let keychainPassword = "password"



	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let username = keychain.get(keychainUsername)
		let password = keychain.get(keychainPassword)

		let params = [ "username" : username,
		"password": password]

		Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.prettyPrinted).responseJSON { response in

			switch response.result {
			case .success:
				//taking user id from the response of the server and putting it in userdefaults
				let responseString = response.description
				let userId = responseString.digits
				UserDefaults.standard.set(userId, forKey: "userID")

				let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
				let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "tabBar") as UIViewController
						self.window = UIWindow(frame: UIScreen.main.bounds)
						self.window?.rootViewController = initialViewControlleripad
						self.window?.makeKeyAndVisible()
			case .failure:
				print("Keychain doesn't have stored username and password!")
			}
		}
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}
