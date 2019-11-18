//
//  LoginViewController.swift
//  Foody
//
//  Created by Petar Stanisic on 10/22/19.
//  Copyright © 2019 Petar Stanisic. All rights reserved.
//

import UIKit
import KeychainSwift
import Alamofire

class LoginViewController: UIViewController {

	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var showPasswordButton: UIButton!
	let keychainUsername = "sopho_username"
	let keychainPassword = "sopho_password"
	let url = "http://uc-dev.voiceworks.com:4000/external/signin"


	typealias WebServerResponse = ([[String:Any]]?, Error?) -> Void

	@IBAction func loginButtonPressed(_ sender: Any) {
		
		guard let username = usernameTextField?.text,
		      let password = passwordTextField?.text else { return }

		let params = [ "username" : username,
		"password": password]

		self.usernameTextField?.resignFirstResponder()
		self.passwordTextField?.resignFirstResponder()
		self.view.layoutIfNeeded()

		let keychain = KeychainSwift()
		keychain.set(username.replacingOccurrences(of: " ", with: ""), forKey: keychainUsername, withAccess: .accessibleAlways)
		keychain.set(password.replacingOccurrences(of: " ", with: ""), forKey: keychainPassword, withAccess: .accessibleAlways)

		Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.prettyPrinted).responseJSON { response in

			switch response.result {
			case .success:

				//taking user id from the response of the server and putting it in userdefaults
				let responseString = response.description
				let userId = responseString.digits
				UserDefaults.standard.set(userId, forKey: "userID")

				self.performSegue(withIdentifier: "tabBarSegue", sender: nil)
			case .failure:
				let alert = UIAlertController(title: "Error", message: "Looks like your username or password is wrong or the fields are empty. \n Please try again!", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
				self.present(alert, animated: true, completion: nil)
			}
		}
	}

	@IBAction func showPasswordPressed(_ sender: UIButton) {
		sender.isSelected = !sender.isSelected
		if sender.isSelected {
			self.passwordTextField?.isSecureTextEntry = false
			showPasswordButton.setTitle("Hide", for: .normal)
		} else {
			self.passwordTextField?.isSecureTextEntry = true
			showPasswordButton.setTitle("Show", for: .normal)
		}
	}

  override func viewDidLoad() {
		super.viewDidLoad()
		prepareKeyboardInteractions()
		prepareUI()

		let tapToDismissKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(
			target: self,
			action: #selector(LoginViewController.dismissKeyboard)
		)
		view.addGestureRecognizer(tapToDismissKeyboard)
	}

	func prepareUI() {

		usernameTextField.delegate = self
		usernameTextField.textContentType = .username
		usernameTextField.keyboardType = .emailAddress
		usernameTextField.keyboardAppearance = .dark
		usernameTextField.clearButtonMode = .whileEditing
		usernameTextField.layer.cornerRadius = 15
		usernameTextField.layer.borderColor = UIColor.blue.cgColor
		usernameTextField.layer.borderWidth = 1
		usernameTextField.clipsToBounds = true

		passwordTextField.delegate = self
		passwordTextField.textContentType = .password
		passwordTextField.layer.cornerRadius = 15
		passwordTextField.clipsToBounds = true
		passwordTextField.layer.borderColor = UIColor.blue.cgColor
		passwordTextField.layer.borderWidth = 1
		passwordTextField.borderStyle = .roundedRect
		passwordTextField.keyboardAppearance = .dark

		loginButton.layer.borderColor = UIColor.blue.cgColor
		loginButton.layer.borderWidth = 1
		loginButton.layer.cornerRadius = 15

		imageView.layer.borderWidth = 1
		imageView.layer.borderColor = UIColor.blue.cgColor
		imageView.layer.cornerRadius = 15

	}

	private func prepareKeyboardInteractions() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillShowNotification(notification:)),
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillHideNotification(notification:)),
			name: UIResponder.keyboardWillHideNotification,
			object: nil
		)
	}

	@objc func dismissKeyboard() {
		DispatchQueue.main.async {
			self.usernameTextField?.resignFirstResponder()
			self.passwordTextField?.resignFirstResponder()
			self.view.layoutIfNeeded()
		}
	}

	@objc func keyboardWillShowNotification(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view.frame.origin.y == 0 {
				self.view.frame.origin.y -= keyboardSize.height
				UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations:{
					self.imageView.isHidden = true
				})
			}
		}
	}

	@objc func keyboardWillHideNotification(notification: NSNotification) {
		if self.view.frame.origin.y != 0 {
			self.view.frame.origin.y = 0
			UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations:{
				self.imageView.isHidden = false
			})
		}
	}

}

extension LoginViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {

		if textField == self.usernameTextField {
			DispatchQueue.main.async {
				self.passwordTextField?.becomeFirstResponder()
			}
			self.view.layoutIfNeeded()
		} else if textField == self.passwordTextField {
			loginButtonPressed(textField)
		}

		return true
	}
}

extension String {
    private static var digits = UnicodeScalar("0")..."9"
    var digits: String {
        return String(unicodeScalars.filter(String.digits.contains))
    }
}
