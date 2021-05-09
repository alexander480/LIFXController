//
//  ViewController.swift
//  LIFX Controller
//
//  Created by Alexander Lester on 3/20/20.
//  Copyright © 2020 Alexander Lester. All rights reserved.
//

import UIKit
import LIFXHTTPKit

// MARK: Client Token: c5e73926c503824643950ee0104cc9d879d1eee1108fd2279343f2cef807ab0e

class ClientTokenVC: UIViewController {
	
	@IBOutlet weak var createTokenButton: UIButton!
	@IBAction func createTokenAction(_ sender: Any) {
		
	}
	
	@IBOutlet weak var tokenField: UITextField!

	@IBOutlet weak var submitTokenButton: UIButton!
	@IBAction func submitTokenAction(_ sender: Any) {
		if self.tokenField.text?.isEmpty == false {
			guard let token = self.tokenField.text else { print("[ERROR] Unable To Validate Text From Token Field."); return }
			
			Client(accessToken: token).fetch { (error) in
				if error.isEmpty {
					print("[SUCCESS] Successfully Validated Client Object.")
					UserDefaults.standard.set(token, forKey: "clientToken")
					print("[INFO] Saved Client Token.")
					
					self.updateUserInterface({ self.performSegue(withIdentifier: "authorizedSegue", sender: self) })
				}
				else {
					print("[ERROR] Unable To Validate Client Object. [MESSAGE] \(error)")
					self.updateUserInterface({ self.presentAlert(Title: "Unable To Validate Token", Message: "Please make sure you have entered in a valid token.", Actions: nil) })
				}
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		if let _ = UserDefaults.standard.string(forKey: "clientToken") {
			print("[INFO] Client Token Already Saved.")
			self.updateUserInterface({ self.performSegue(withIdentifier: "authorizedSegue", sender: self) })
		}
	}
	
}

