//
//  ControllerVC.swift
//  LIFX Controller
//
//  Created by Alexander Lester on 3/21/20.
//  Copyright © 2020 Alexander Lester. All rights reserved.
//

import Foundation
import UIKit

import LIFXHTTPKit

class ControllerVC: UIViewController {
	
	var client: Client!
	var allLightTarget: LightTarget!
	
	var observer: LightTargetObserver?
	
	var selectedLightTarget: LightTarget!
	
	var didSetupCollectionView = false
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		
		let token = UserDefaults.standard.string(forKey: "clientToken") ?? ""
		print("[TOKEN] \(token)")
		
		client = Client(accessToken: token)
		client.fetchLights { (error) in
			if let err = error { print("[ERROR] Unable To Fetch Lights. [MESSAGE] \(err.localizedDescription)") }
			else {
				self.allLightTarget = self.client.allLightTarget()
				self.addLightObserver()
				print("[COUNT] \(self.allLightTarget.count)")
				
				DispatchQueue.main.async { self.collectionView.reloadData() }
			}
		}
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.collectionView.delegate = self
		self.collectionView.dataSource = self
	}
	
	func addLightObserver() {
		self.observer = self.allLightTarget.addObserver { [unowned self] in
			DispatchQueue.main.async {
				// print("[COUNT] \(self.allLightTarget.count)")
				// self.collectionView.reloadData()
			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ControllerSegue" {
			if let vc = segue.destination as? LightControllerVC {
				vc.lightTarget = self.selectedLightTarget
			}
		}
	}
}

extension ControllerVC: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.allLightTarget?.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let target = self.allLightTarget.toLightTargets()[indexPath.row]
		let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "LightCell", for: indexPath) as! LightCell
			cell.lightTarget = target
			cell.label.text = target.label
			cell.setupObserver()
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		self.selectedLightTarget = self.allLightTarget.toLightTargets()[indexPath.row]
		self.performSegue(withIdentifier: "ControllerSegue", sender: self)
	}
}


/*
import Foundation
import LIFXHTTPKit
import NotificationCenter
import UIKit

class ControllerVC: UIViewController {
	
	@IBOutlet var mainView: UIView!
	
	var client: Client?
	var all: LightTarget?
	var lights: [LightTarget]?
	
	var observer: LightTargetObserver?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let token = UserDefaults.standard.string(forKey: "clientToken") else { print("[ERROR] Unable To Validate Saved Token."); return }
		let client = Client(accessToken: token)
		self.client = client

		client.fetch { (errorArr) in
			if errorArr.isEmpty {
				let all = client.allLightTarget()
				self.all = client.allLightTarget()
				
				let lights = all.toLightTargets()
				self.lights = lights
				
				print("[INFO] Found \(lights.count) Lights.")
				
				self.mainView.backgroundColor = all.color.toUIColor()
				self.setupObserver(all)
			}
			else {
				for err in errorArr {
					print("[ERROR] \(err)")
				}
			}
		}
	}
	
	func setupObserver(_ target: LightTarget) {
		self.observer = target.addObserver({
			if target.power {
				self.mainView?.backgroundColor = target.color.toUIColor()
				self.button.titleLabel?.text = "Off"
			}
			else {
				self.button.titleLabel?.text = "On"
			}
		})
	}
	
	deinit { if let observer = self.observer { self.all?.removeObserver(observer) } }
}
*/
