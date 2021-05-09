//
//  Extensions.swift
//  LIFX Controller
//
//  Created by Alexander Lester on 3/26/20.
//  Copyright © 2020 Alexander Lester. All rights reserved.
//

import Foundation
import LIFXHTTPKit
import UIKit

extension UIViewController {
	func presentAlert(Title: String, Message: String?, Actions: [UIAlertAction]?) {
		let alert = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
		if let actions = Actions { for action in actions { alert.addAction(action) } }
		else { alert.addAction(UIAlertAction(title: "Okay", style: .cancel) { (action) in alert.dismiss(animated: true, completion: nil) }) }
		self.present(alert, animated: true, completion: nil)
	}
	
	func updateUserInterface(_ function: @escaping () -> ()) { DispatchQueue.main.async { function() } }
}

extension Color {
	// Based on https://github.com/LIFX/LIFXKit/blob/master/LIFXKit/Extensions/Categories-UIKit/UIColor+LFXExtensions.m
	// which was based on http://www.tannerhelland.com/4435/convert-temperature-rgb-algorithm-code/
	public func toUIColor() -> UIColor {
		if isWhite {
			var red: Float = 0.0
			var green: Float = 0.0
			var blue: Float = 0.0

			if kelvin <= 6600 {
				red = 1.0
			} else {
				red = Float(1.292936186062745) * powf(Float(kelvin) / Float(100.0) - Float(60.0), Float(-0.1332047592))
			}

			if kelvin <= 6600 {
				green = Float(0.39008157876902) * logf(Float(kelvin) / Float(100.0)) - Float(0.631841443788627)
			} else {
				green = Float(1.129890860895294) * powf(Float(kelvin) / Float(100.0) - Float(60.0), Float(-0.0755148492))
			}

			if kelvin >= 6600 {
				blue = 1.0
			} else {
				if kelvin <= 1900 {
					blue = 0.0
				} else {
					blue = Float(0.543206789110196) * logf(Float(kelvin) / Float(100.0) - Float(10.0)) - Float(1.19625408914)
				}
			}

			if red < 0.0 {
				red = 0.0
			} else if red > 1.0 {
				red = 1.0
			}
			if green < 0.0 {
				green = 0.0
			} else if green > 1.0 {
				green = 1.0
			}
			if blue < 0.0 {
				blue = 0.0
			} else if blue > 1.0 {
				blue = 1.0
			}

			return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0)
		} else {
			return UIColor(hue: CGFloat(hue) / 360.0, saturation: CGFloat(saturation), brightness: 1.0, alpha: 1.0)
		}
	}
}

extension UIColor {
	func blendColors(colorOne: UIColor, colorTwo: UIColor) -> UIColor {
		return self.addColor(colorOne, with: colorTwo)
	}
	
	func addColor(_ color1: UIColor, with color2: UIColor) -> UIColor {
		var (r1, g1, b1, a1) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
		var (r2, g2, b2, a2) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))

		color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
		color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

		// add the components, but don't let them go above 1.0
		return UIColor(red: min(r1 + r2, 1), green: min(g1 + g2, 1), blue: min(b1 + b2, 1), alpha: (a1 + a2) / 2)
	}

	func multiplyColor(_ color: UIColor, by multiplier: CGFloat) -> UIColor {
		var (r, g, b, a) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
		color.getRed(&r, green: &g, blue: &b, alpha: &a)
		return UIColor(red: r * multiplier, green: g * multiplier, blue: b * multiplier, alpha: a)
	}
}
