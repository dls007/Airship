/* Copyright Airship and Contributors */

import Foundation
import SwiftUI

@available(iOS 13.0.0, tvOS 13.0, *)
struct TextAppearanceViewModifier<Appearance: BaseTextAppearance>: ViewModifier {
    let textAppearance: Appearance

    // Needed for dynamic font size
    @Environment(\.sizeCategory) var sizeCategory

    @ViewBuilder
    func body(content: Content) -> some View {
        content.font(resolveFont())
    }
    
    private func resolveFont() -> Font {
        var font: Font
        let scaledSize = UIFontMetrics.default.scaledValue(for: self.textAppearance.fontSize)
        
        //判断返回的airship后台返回的字体苹果是否支持
        let fontFamilies = UIFont.familyNames
        var allfontNames = [String]()
        var customFont = ""
        
        for(i,_) in fontFamilies.enumerated(){
            let fontFamily = fontFamilies[i]
            let fontNames = UIFont.fontNames(forFamilyName: fontFamily)
            
            for (ii,_) in fontNames.enumerated(){
                let fontName = fontNames[ii]
                allfontNames.append(fontName)
            }
        }
        let textAppearanceFontFamilies = self.textAppearance.fontFamilies ?? [String]()
        for (_,obj) in textAppearanceFontFamilies.enumerated(){
            if allfontNames.contains(obj){
                customFont = obj
            }
        }
        
        //如果字体支持 走自定义字体方法 如果不支持 走原来的airship方法
        if customFont.count > 0 {
            font = Font.custom(
                customFont,
                size: scaledSize
            )
        }else{
            if let fontFamily = resolveFontFamily(
                families: self.textAppearance.fontFamilies
            ) {
                font = Font.custom(
                    fontFamily,
                    size: scaledSize
                )
            } else {
                font = Font.system(size: scaledSize)
            }
        }
        
        if let styles = self.textAppearance.styles {
            if (styles.contains(.bold)) {
                font = font.bold()
            }
            if (styles.contains(.italic)) {
                font = font.italic()
            }
        }
        return font
    }

    
    private func resolveFontFamily(families: [String]?) -> String? {
        if let families = families {
            for family in families {
                let lowerCased = family.lowercased()
                
                switch (lowerCased) {
                case "serif":
                    return "Times New Roman"
                case "sans-serif":
                    return nil
                default:
                    if (!UIFont.fontNames(forFamilyName: lowerCased).isEmpty) {
                        return family
                    }
                }
            }
        }
        return nil
    }
    
}

@available(iOS 13.0.0, tvOS 13.0, *)
extension Text {
    
    private func applyTextStyles(styles: [TextStyle]?) -> Text {
        var text = self
        if let styles = styles {
            if (styles.contains(.bold)) {
                text = text.bold()
            }
            
            if (styles.contains(.italic)) {
                text = text.italic()
            }
            
            if (styles.contains(.underlined)) {
                text = text.underline()
            }
        }
        return text
    }


    @ViewBuilder
    func textAppearance<Appearance: BaseTextAppearance>(_ textAppearance: Appearance?) -> some View {
        if let textAppearance = textAppearance {
            self.applyTextStyles(styles: textAppearance.styles)
                .multilineTextAlignment(textAppearance.alignment?.toSwiftTextAlignment() ?? .center)
                .modifier(TextAppearanceViewModifier(textAppearance: textAppearance))
                .foreground(textAppearance.color)
        } else {
            self
        }
    }
}

extension UIFont {
    func withTraits(traits:UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}
