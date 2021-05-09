//
//  BasicLightCell.swift
//  LIFX Controller
//
//  Created by Alexander Lester on 4/23/20.
//  Copyright © 2020 Alexander Lester. All rights reserved.
//

import Foundation
import UIKit

import LIFXHTTPKit

class LightCell: UICollectionViewCell {
	
	var observer: LightTargetObserver?
	var lightTarget: LightTarget!
	
	@IBOutlet weak var label: UILabel!
	
	@IBOutlet weak var button: UIButton!
	@IBAction func buttonAction(_ sender: Any) {
		if self.lightTarget.power {
			self.lightTarget.setPower(false)
			// self.button.setImage(UIImage(named: "lightbulb"), for: .normal)
		}
		else {
			self.lightTarget.setPower(true)
			// self.button.setImage(UIImage(named: "lightbulb.fill"), for: .normal)
		}
	}
	
	func setupObserver() {
		self.observer = lightTarget.addObserver({
			DispatchQueue.main.async {
				self.layer.backgroundColor = self.lightTarget.color.toUIColor().cgColor
				
//				if self.lightTarget.power { self.button.setImage(UIImage(named: "lightbulb.fill"), for: .normal) }
//				else { self.button.setImage(UIImage(named: "lightbulb"), for: .normal) }
			}
		})
	}

	deinit { if let observer = self.observer { lightTarget.removeObserver(observer) } }
}
