//
//  UINavigationBar+Appearance.swift
//  Nutrition
//
//  Created by Richard Segerblom on 2020-12-22.
//

import UIKit
import SwiftUI

extension UINavigationBar {    
    private class var opaqueAppearance: UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        return appearance
    }
    
    private class var transparentAppearance: UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        return appearance
    }
    
    class func setTransparentBackground() {
        setAppearance(appearance: transparentAppearance)
    }
    
    class func setOpaqueBackground(color: Color = Color(#colorLiteral(red: 0.9537998028, green: 0.9537998028, blue: 0.9537998028, alpha: 1))) {
        let appearance = opaqueAppearance
        appearance.backgroundColor = UIColor(color)
        
        setAppearance(appearance: appearance)
    }
    
    private class func setAppearance(appearance: UINavigationBarAppearance) {
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
    }
}
