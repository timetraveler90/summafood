//
//  LoginViewController.swift
//  Foody
//
//  Created by Petar Stanisic on 10/22/19.
//  Copyright © 2019 Petar Stanisic. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var showPasswordButton: UIButton!

  override func viewDidLoad() {
		super.viewDidLoad()
		prepareKeyboardInteractions()

		let tapToDismissKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(
			target: self,
			action: #selector(LoginViewController.dismissKeyboard)
		)
		view.addGestureRecognizer(tapToDismissKeyboard)
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
			if self.view.frame.origin.y == 0{
				self.view.frame.origin.y -= keyboardSize.height
			}
		}
	}

	@objc func keyboardWillHideNotification(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view.frame.origin.y != 0{
				self.view.frame.origin.y += keyboardSize.height
			}
		}
	}

}
