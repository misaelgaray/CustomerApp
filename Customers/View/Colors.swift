//
//  Colors.swift
//  Customers
//
//  Created by Misael Garay on 11/7/18.
//  Copyright © 2018 Misael Garay. All rights reserved.
//

import UIKit

extension UIColor {
	
	public static func GetRGBColor(r : Float, g : Float, b : Float, alpha : Float = 1) -> UIColor{
		return UIColor(displayP3Red: CGFloat(r/255), green: CGFloat(g/255), blue: CGFloat(b/255), alpha: CGFloat(alpha))
	}
	
}
