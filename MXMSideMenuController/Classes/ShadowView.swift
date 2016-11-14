//
// Created by Maxim Pervushin on 14/11/2016.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

@IBDesignable public class ShadowView: UIView {

    @IBInspectable var horizontal: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var shadowStartColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var shadowEndColor: UIColor = .clear {
        didSet {
            setNeedsDisplay()
        }
    }

    override public func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            context.saveGState()

            let colorSpace = CGColorSpaceCreateDeviceRGB()

            var startComponents: [CGFloat] = [0.0, 0.0, 0.0, 0.0]
            shadowStartColor.getRed(&startComponents[0], green: &startComponents[1], blue: &startComponents[2], alpha: &startComponents[3])

            var endComponents: [CGFloat] = [0.0, 0.0, 0.0, 0.0]
            shadowEndColor.getRed(&endComponents[0], green: &endComponents[1], blue: &endComponents[2], alpha: &endComponents[3])

            let colorComponents = [
                    startComponents[0],
                    startComponents[1],
                    startComponents[2],
                    startComponents[3],
                    endComponents[0],
                    endComponents[1],
                    endComponents[2],
                    endComponents[3]
            ]

            let locations: [CGFloat] = [0.0, 1.0]

            guard let gradient = CGGradient(colorSpace: colorSpace, colorComponents: colorComponents, locations: locations, count: 2) else {
                return
            }

            if horizontal {
                let startPoint = CGPoint(x: 0, y: 0)
                let endPoint = CGPoint(x: frame.width, y: 0)
                context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
            } else {
                let startPoint = CGPoint(x: 0, y: 0)
                let endPoint = CGPoint(x: 0, y: frame.height)
                context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
            }

            context.restoreGState()
        }
    }
}
