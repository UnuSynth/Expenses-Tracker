//
//  UIApplication+Extensions.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 30/5/26.
//

import UIKit

extension UIApplication {
    static var mainScreen: UIScreen? {
        let scenes = shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window?.screen
    }
    
    static var screenHeight: CGFloat {
        mainScreen?.bounds.height ?? 0
    }
}
