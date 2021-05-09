//
//  DesignExtension.swift
//  LIFX Controller
//
//  Created by Alexander Lester on 3/21/20.
//  Copyright © 2020 Alexander Lester. All rights reserved.
//

import UIKit

@IBDesignable class Slider: UISlider {
	@IBInspectable var rotate: Bool = false { didSet { if self.rotate { self.transform = CGAffineTransform(rotationAngle: (.pi / 2) * -1) } } }
}

@IBDesignable class SegmentedSlider: UISegmentedControl {
	@IBInspectable var rotate: Bool = false { didSet { if self.rotate { self.transform = CGAffineTransform(rotationAngle: .pi / 2) } } }
	@IBInspectable var cornerRadius: CGFloat = 0 {
		didSet {
			self.layer.cornerRadius = self.cornerRadius
		}
	}
}
