//
//  LoginViewController.swift
//  Foody
//
//  Created by Petar Stanisic on 10/22/19.
//  Copyright © 2019 Petar Stanisic. All rights reserved.
//

import UIKit
import KeychainSwift

class LoginViewController: UIViewController {

	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var showPasswordButton: UIButton!
	let keychainUsername = "sopho_username"
	let keychainPassword = "sopho_password"

	@IBAction func loginButtonPressed(_ sender: Any) {

		guard let username = usernameTextField?.text,
		      let password = passwordTextField?.text else { return }

		self.usernameTextField?.resignFirstResponder()
		self.passwordTextField?.resignFirstResponder()
		self.view.layoutIfNeeded()

		let keychain = KeychainSwift()
		if keychain.set(username.replacingOccurrences(of: " ", with: ""), forKey: keychainUsername, withAccess: .accessibleAlways) {

		} else {
			print("we had a problem saving your username in the keychain")
		}
		if keychain.set(password.replacingOccurrences(of: " ", with: ""), forKey: keychainPassword, withAccess: .accessibleAlways) {

		} else {
			print("we had a problem saving your password in the keychain")
		}

		self.performSegue(withIdentifier: "tabBarSegue", sender: nil)
	}

	@IBAction func showPasswordPressed(_ sender: UIButton) {
		sender.isSelected = !sender.isSelected
		if sender.isSelected {
			self.passwordTextField?.isSecureTextEntry = false
		} else {
			self.passwordTextField?.isSecureTextEntry = true
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

		usernameTextField.textContentType = .username
		usernameTextField.keyboardType = .emailAddress
		usernameTextField.keyboardAppearance = .dark
		usernameTextField.clearButtonMode = .whileEditing
		usernameTextField.layer.cornerRadius = 15
		usernameTextField.layer.borderColor = UIColor.blue.cgColor
		usernameTextField.layer.borderWidth = 1
		usernameTextField.clipsToBounds = true

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
				imageView.isHidden = true
			}
		}
	}

	@objc func keyboardWillHideNotification(notification: NSNotification) {
		if self.view.frame.origin.y != 0 {
			self.view.frame.origin.y = 0
			imageView.isHidden = false
		}
	}

}
