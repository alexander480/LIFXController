//
//  LightControllerVC.swift
//  LIFX Controller
//
//  Created by Alexander Lester on 4/24/20.
//  Copyright © 2020 Alexander Lester. All rights reserved.
//

import Foundation
import UIKit

import LIFXHTTPKit

class LightControllerVC: UIViewController {
	
	var observer: LightTargetObserver?
	var lightTarget: LightTarget!
	
	@IBOutlet weak var imageView: UIImageView!
	
	@IBOutlet weak var brightnessStepper: UIStepper!
	@IBAction func brightnessStepperAction(_ sender: Any) {
		let currentStep = self.brightnessStepper.value
		self.lightTarget.setBrightness(currentStep)
	}
	
	@IBOutlet weak var kelvinControl: UISegmentedControl!
	@IBAction func kelvinControlAction(_ sender: Any) {
		let idx = self.kelvinControl.selectedSegmentIndex
		if idx == 0 {
			let color = Color(hue: 0.0, saturation: 1.0, kelvin: 0)
			self.lightTarget.setColor(color)
		}
		else if idx == 1 {
			let color = Color(hue: 120.0, saturation: 1.0, kelvin: 0)
			self.lightTarget.setColor(color)
		}
		else if idx == 2 {
			let color = Color(hue: 240.0, saturation: 1.0, kelvin: 0)
			self.lightTarget.setColor(color)
		}
	}
	
	
	@IBOutlet weak var selectColorButton: UIButton!
	@IBAction func selectColorAction(_ sender: Any) {
		
	}
	
	override func viewDidLoad() {
		
	}
	
	private func setupObserver() { self.observer = lightTarget.addObserver({ DispatchQueue.main.async { self.updateUserInterface() } }) }
	
	private func updateUserInterface() {
		let brightness = self.lightTarget.brightness
		self.brightnessStepper.value = brightness
	}

	deinit { if let observer = self.observer { lightTarget.removeObserver(observer) } }
}


