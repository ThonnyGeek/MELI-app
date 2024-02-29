//
//  Font+Extension.swift
//  MELI
//
//  Created by Thony Gonzalez on 28/02/24.
//

import SwiftUI

extension Font {
    static func manropeSemiBold(_ size: CGFloat) -> Font {
        return Font.custom("Manrope-SemiBold", size: size)
    }
    
    static func manropeRegular(_ size: CGFloat) -> Font {
        return Font.custom("Manrope-Regular", size: size)
    }
    
    static func manropeMedium(_ size: CGFloat) -> Font {
        return Font.custom("Manrope-Medium", size: size)
    }
    
    static func manropeExtraLight(_ size: CGFloat) -> Font {
        return Font.custom("Manrope-ExtraLight", size: size)
    }
    
    static func manropeBold(_ size: CGFloat) -> Font {
        return Font.custom("Manrope-Bold", size: size)
    }
}
