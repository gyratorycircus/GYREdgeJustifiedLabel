//
//  EdgeJustifiedLabel.swift
//  Created by Tom Jendrzejek on January 3, 2018.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2018 Tom Jendrzejek <mailto:gyratorycircus@icloud.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

/// The style of truncation to be applied to an EdgeJustifiedLabel
@objc public enum TruncationStyle: Int {
    /// No truncation applied; left and right text may overlap.
    case none = -1
    
    /// Equal amounts of truncation is applied to the left tail and right head.
    case bothCenter = 0
    
    /// All right text is shown, and left text is tail truncated.
    case leftTail = 1
    
    /// All left text is shown, and right text is tail truncated.
    case rightTail = 2
    
    /// All left text is shown, and right text is head truncated.
    case rightHead = 3
    
    /// Left and right text is tail truncated equal amounts.
    case bothTails = 4
    
    /// Left and right text is head truncated equal amounts.
    case bothHeads =  5
}

/// This class allows two single-line strings to be shown left and right justified, and equally scaled or truncated to fit the label bounds.
/// This capability is not possible using two separate UILabels and autolayout, as one will always scale before the other, nor is it possible via NSAttributedString, which does not allow left and right justified text to be displayed on a single line.
@objc @IBDesignable public class EdgeJustifiedLabel: UILabel {

    /// The text to be shown left justified.
    @IBInspectable public var leftText: String? {
        didSet {
            // Set the `text` property to hook into automatic intrinsic content sizing.
            super.text = (leftText ?? "") + (rightText ?? "")
            setNeedsDisplay()
        }
    }
    /// The text to be shown right justified.
    @IBInspectable public var rightText: String? {
        didSet {
            // Set the `text` property to hook into automatic intrinsic content sizing.
            super.text = (leftText ?? "") + (rightText ?? "")
            setNeedsDisplay()
        }
    }
    
    /// Color used to draw the left text. Defaults to using `textColor` if nil.
    @IBInspectable public var leftTextColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    /// Color used to draw the right text. Defaults to using `textColor` if nil.
    @IBInspectable public var rightTextColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// Color used to draw the left text when highlighted. Defaults to using `textColor` if nil.
    @IBInspectable public var leftHighlightedTextColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    /// Color used to draw the right text when highlighted. Defaults to using `textColor` if nil.
    @IBInspectable public var rightHighlightedTextColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// A minimum spacing value between the left and right text.
    @IBInspectable public var minimumSpacing: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    /// The style of truncation that should be applied if the label runs out of space.
    @objc public var truncationStyle: TruncationStyle = .none {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // Need a wrapper around the `truncationStyle` enum to have an @IBInspectable property.
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'truncationStyle' instead.")
    @IBInspectable var iBTruncationStyle: Int = 0 {
        willSet {
            if let ts = TruncationStyle(rawValue: newValue) {
                truncationStyle = ts
            }
            else {
                print("Unsupport value set to \(#function): value: \(newValue)")
            }
        }
    }
    
    @available(*, unavailable, message: "EdgeJustifiedLabel ignores `text`; please use `leftText` and `rightText` instead.")
    override public var text: String? {
        didSet {}
    }
    
    override public var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += minimumSpacing
        return size
    }
    
    override public func drawText(in rect: CGRect) {
        let nonNilLeftText = (leftText ?? "") as NSString
        let nonNilRightText = (rightText ?? "") as NSString
        
        var workingFont = font!
        var leftSize = nonNilLeftText.naturalRect(workingFont).size
        var rightSize = nonNilRightText.naturalRect(workingFont).size
        
        // Use the first height for comparisions against the max scale factor.
        let originalHeight = CGFloat.maximum(leftSize.height, rightSize.height)

        // Lower this flag to stop adjustments
        var adjustsFontSize = adjustsFontSizeToFitWidth && minimumScaleFactor > 0
        
        while adjustsFontSize && rect.width < leftSize.width + rightSize.width + minimumSpacing {
            workingFont = UIFont(name: workingFont.fontName, size: workingFont.pointSize - 0.5)!
            
            leftSize = nonNilLeftText.naturalRect(workingFont).size
            rightSize = nonNilRightText.naturalRect(workingFont).size
            
            if CGFloat.maximum(leftSize.height, rightSize.height) < originalHeight * minimumScaleFactor {
                adjustsFontSize = false
            }
        }

        // Truncate as necessary if the text still does not fit.
        let missingWidth = minimumSpacing + leftSize.width + rightSize.width + -rect.width
        
        if missingWidth > 0 {
            switch (truncationStyle) {
            case .bothCenter, .bothTails, .bothHeads:
                leftSize.width -= missingWidth * 0.5
                rightSize.width -= missingWidth * 0.5
            case .leftTail:
                leftSize.width -= missingWidth
            case .rightHead, .rightTail:
                rightSize.width -= missingWidth
            case .none:
                break
            }
        }
        
        let leftColor = isHighlighted
            ? leftHighlightedTextColor ?? highlightedTextColor ?? leftTextColor ?? textColor!
            : leftTextColor ?? textColor!
        let rightColor = isHighlighted
            ? rightHighlightedTextColor ?? highlightedTextColor ?? rightTextColor ?? textColor!
            : rightTextColor ?? textColor!
        
        #if swift(>=4.0)
            let leftAttrs: [NSAttributedStringKey : Any] = [
                .font: workingFont,
                .paragraphStyle: leftParagraphStyle(),
                .foregroundColor: leftColor
            ]
            let rightAttrs: [NSAttributedStringKey : Any] = [
                .font: workingFont,
                .paragraphStyle: rightParagraphStyle(),
                .foregroundColor: rightColor
            ]
        #else
            let leftAttrs: [String : Any] = [
                NSFontAttributeName: workingFont,
                NSParagraphStyleAttributeName: leftParagraphStyle(),
                NSForegroundColorAttributeName: leftColor
            ]
            let rightAttrs: [String : Any] =  [
                NSFontAttributeName: workingFont,
                NSParagraphStyleAttributeName: rightParagraphStyle(),
                NSForegroundColorAttributeName: rightColor
            ]
        #endif
        
        // The origin location depends on the baseline alignment.
        var originY: CGFloat = 0
        
        switch (baselineAdjustment) {
        case .alignBaselines:
            // UIFont.ascender is the height from the baseline to the top, conveniently also the Y position of the baseline.
            let originalBaselineY = font!.ascender
            let currentBaselineY = workingFont.ascender
            originY = originalBaselineY - currentBaselineY
        
        case .alignCenters:
            originY = (rect.height - workingFont.lineHeight) / 2
            
        case .none:
            break
        }
        
        let leftRect = CGRect(origin: CGPoint(x: 0, y: originY), size: leftSize)
        let rightRect = CGRect(origin: CGPoint(x: rect.width - rightSize.width, y: originY), size: rightSize)
        
        nonNilLeftText.draw(in: leftRect, withAttributes: leftAttrs)
        nonNilRightText.draw(in: rightRect, withAttributes: rightAttrs)
    }
    
    /// Convenience to create a NSParagraphStyle used to draw the left justfied text.
    private func leftParagraphStyle() -> NSParagraphStyle {
        let ps = NSMutableParagraphStyle()
        ps.alignment = .left
        if let lineBreakMode = truncationStyle.leftLineBreakMode() {
            ps.lineBreakMode = lineBreakMode
        }
        
        return ps
    }
    
    /// Convenience to create a NSParagraphStyle used to draw the right justfied text.
    private func rightParagraphStyle() -> NSParagraphStyle {
        let ps = NSMutableParagraphStyle()
        ps.alignment = .right
        if let lineBreakMode = truncationStyle.rightLineBreakMode() {
            ps.lineBreakMode = lineBreakMode
        }
        
        return ps
    }
}

private extension TruncationStyle {
    /// Convenience to determine the NSLineBreakMode for the left justified text.
    func leftLineBreakMode() -> NSLineBreakMode? {
        switch self {
        case .leftTail, .bothTails, .bothCenter:
            return .byTruncatingTail
        case .bothHeads:
            return .byTruncatingHead
        default:
            return nil
        }
    }
    
    /// Convenience to determine the NSLineBreakMode for the right justified text.
    func rightLineBreakMode() -> NSLineBreakMode? {
        switch self {
        case .rightTail, .bothTails:
            return .byTruncatingTail
        case .rightHead, .bothCenter, .bothHeads:
            return .byTruncatingHead
        default:
            return nil
        }
    }
}

private extension NSString {
    /// Convenience to get the size of a string with a font.
    func naturalRect(_ font: UIFont) -> CGRect {
        #if swift(>=4.0)
            let attrs: [NSAttributedStringKey: Any] = [.font: font]
        #else
            let attrs = [NSFontAttributeName: font]
        #endif

        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let rect = self.boundingRect(with: maxSize, options: [], attributes: attrs, context: nil)
        return rect
    }
}
