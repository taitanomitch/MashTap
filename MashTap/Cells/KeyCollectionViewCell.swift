//
//  KeyCollectionViewCell.swift
//  MashTap
//
//  Created by Mitchell Taitano on 12/27/17.
//  Copyright © 2017 Mitchell Taitano. All rights reserved.
//

import UIKit

class KeyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var colorView: UIView!
    
    
    func setUpCell(color: MasterViewController.Color) {
        
        var backgroundColor: MasterViewController.ColorValue

        switch color {
        case MasterViewController.Color.Blue:
            backgroundColor = MasterViewController.ColorValue.Blue
        case MasterViewController.Color.Green:
            backgroundColor = MasterViewController.ColorValue.Green
        case MasterViewController.Color.Orange:
            backgroundColor = MasterViewController.ColorValue.Orange
        case MasterViewController.Color.Purple:
            backgroundColor = MasterViewController.ColorValue.Purple
        case MasterViewController.Color.Red:
            backgroundColor = MasterViewController.ColorValue.Red
        case MasterViewController.Color.Yellow:
            backgroundColor = MasterViewController.ColorValue.Yellow
        case MasterViewController.Color.NoColor:
            backgroundColor = MasterViewController.ColorValue.NoColor
        }

        colorView.backgroundColor = hexStringToUIColor(hex:backgroundColor.rawValue)
        colorView.layer.cornerRadius = colorView.frame.width / 2
        colorView.layer.masksToBounds = true
    }
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
