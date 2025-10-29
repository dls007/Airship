/* Copyright Airship and Contributors */

import SwiftUI

struct TextView: View {
    let textInfo: InAppMessageTextInfo
    let textTheme: InAppMessageTheme.Text

    var body: some View {
        Text(textInfo.text)
            .foregroundColor(textInfo.color?.color ?? Color.black) /// Should never default to black
            .multilineTextAlignment(alignment(for: textInfo.alignment))
            .applyTextStyling(textInfo: textInfo)
            .applyTextTheme(textTheme)
    }

    private func alignment(for alignment: InAppMessageTextInfo.Alignment?) -> TextAlignment {
        switch alignment {
        case .left:
            return .leading
        case .center:
            return .center
        case .right:
            return .trailing
        case .none:
            return .center /// Default alignment
        }
    }
}

extension View {
    func applyTextStyling(textInfo:InAppMessageTextInfo) -> some View {
        return self.modifier(TextStyleViewModifier(textInfo: textInfo))
    }
}

struct TextStyleViewModifier: ViewModifier {
    // Needed for dynamic font size
    @Environment(\.sizeCategory) var sizeCategory
    let textInfo: InAppMessageTextInfo

    @ViewBuilder
    func body(content: Content) -> some View {
        content.font(UIFont.resolve(self.textInfo))
    }
}

fileprivate extension UIFont {
    static func resolve(
        _ textInfo: InAppMessageTextInfo
    ) -> Font {
        var font: Font
        let scaledSize = UIFontMetrics.default.scaledValue(for: textInfo.size ?? 14)
        
        font = Font.system(size: scaledSize)
        
        // 判断返回的 airship 后台返回的字体苹果是否支持
        let fontFamilies = UIFont.familyNames
        var allFontNames = [String]()
        var customFont = ""

        for family in fontFamilies {
            // 解包可选数组，如果为 nil 则使用空数组 []
            let fontNames = UIFont.fontNames(forFamilyName: family)
            allFontNames.append(contentsOf: fontNames)
        }

        // 遍历 textInfo.fontFamilies，确保是 String 类型并检查是否支持
        
        for fontFamily in textInfo.fontFamilies ?? []{
            let fontFamilyString = fontFamily
            if allFontNames.contains(fontFamilyString) {
                customFont = fontFamilyString
                break // 找到第一个匹配的字体后退出循环（可选）
            }
        }
        
        // 1. 尝试使用自定义字体（如果存在）
        if !customFont.isEmpty {
            var attributes: [UIFontDescriptor.AttributeName: Any] = [
                .name: customFont
            ]
            
            let fontDescriptor = UIFontDescriptor(fontAttributes: attributes)
            
            let uiFont = UIFont(descriptor: fontDescriptor, size: scaledSize)
            font = Font(uiFont)
           
            
        }else{
            
            if let fontFamily = resolveFamily(
                families: textInfo.fontFamilies
            ) {
                font = Font.custom(
                    fontFamily,
                    fixedSize: scaledSize
                )
            } else {
                font = Font.system(size: scaledSize)
            }
        }
        
        
        if let styles = textInfo.style {
            if styles.contains(.bold) {
                font = font.bold()
            }
            if styles.contains(.italic) {
                font = font.italic()
            }
        }
        return font
    }

    static func resolveFamily(families: [String]?) -> String? {
        if let families = families {
            for family in families {
                let lowerCased = family.lowercased()

                switch lowerCased {
                case "serif":
                    return "Times New Roman"
                case "sans-serif":
                    return nil
                default:
                    if !UIFont.fontNames(forFamilyName: lowerCased).isEmpty {
                        return family
                    }
                }
            }
        }
        return nil
    }
}
