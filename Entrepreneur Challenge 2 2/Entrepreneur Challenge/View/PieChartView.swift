//
//  PieChartView.swift
//
//  Created by Vito Bellini on 03/01/15.
//  Copyright (c) 2015 Vito Bellini. All rights reserved.
//

import UIKit

class PieChartItem {
    var color: UIColor
    var value: Float
    
    init(value: Float = 0, color: UIColor) {
        self.color = color
        self.value = value
    }
}

class PieChartView: UIView {
    var items: [PieChartItem] = [PieChartItem]()
    var sum: Float = 0
    
    var gradientFillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)

    var gradientStart: Float = 0.3
    var gradientEnd: Float = 1

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
      //  fatalError("init(coder:) has not been implemented")

    }
    
         func clearItems() {
        items.removeAll(keepingCapacity: true)
        sum = 0
    }
    
    func addItem(value: Float, color: UIColor) {
        let item = PieChartItem(value: value, color: color)
        
        items.append(item)
        sum += value
    }

    

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    func drawRect(rect: CGRect) {
        
        func createCircleMaskUsingCenterPoint(point: CGPoint, radius: Float) -> UIImage {
            UIGraphicsBeginImageContext( self.bounds.size )
            let ctx2: CGContext = UIGraphicsGetCurrentContext()!
            ctx2.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0 )
            ctx2.fill(self.bounds)
            ctx2.setFillColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0 )
            ctx2.move(to: CGPoint(x: point.x, y: point.y))
            ctx2.addArc(center: CGPoint(x: point.x, y: point.y), radius: CGFloat(radius), startAngle: 0.0, endAngle: (360.0)*CGFloat(M_PI)/180.0, clockwise: false)
            ctx2.closePath()
            ctx2.fillPath()
            let maskImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsPopContext()
            
            return maskImage;
        }
        
        func createGradientImageUsingRect(rect: CGRect) -> UIImage {
            let color = gradientFillColor
            let cgColor = color.cgColor
            
            let numComponents = cgColor.numberOfComponents
            
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            
            if (numComponents == 4) {
                let components = cgColor.components
                red = (components?[0])!
                green = (components?[1])!
                blue = (components?[2])!
                alpha = (components?[3])!
            }
            
            UIGraphicsBeginImageContext( rect.size );
            let ctx3 = UIGraphicsGetCurrentContext();
            
            let locationsCount: UInt = 2
            let locations: [CGFloat] = [ 1.0-CGFloat(gradientStart), 1.0-CGFloat(gradientEnd) ]
            let components: [CGFloat] = [0, 0, 0, 0, red, green, blue, alpha]
            
            let rgbColorspace = CGColorSpaceCreateDeviceRGB();
            let gradient = CGGradient(colorSpace: rgbColorspace, colorComponents: components, locations: locations, count: Int(locationsCount));
            
            let currentBounds = rect
            let topCenterPoint = CGPoint(x: currentBounds.midX, y: currentBounds.midY)
            let bottomCenterPoint = CGPoint(x: currentBounds.midX, y: currentBounds.midY)
            ctx3!.drawLinearGradient(gradient!, start: topCenterPoint, end: bottomCenterPoint, options: CGGradientDrawingOptions(rawValue: 0))

            
            let gradientImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
            UIGraphicsPopContext();
            
            return gradientImage;
        }
        
        func maskImage(image: UIImage, maskImage: UIImage) -> UIImage {
            
            let maskRef: CGImage = maskImage.cgImage!
            
            let mask: CGImage = CGImage(maskWidth: maskRef.width,
                                        height: maskRef.height,
                                        bitsPerComponent: maskRef.bitsPerComponent,
                                        bitsPerPixel: maskRef.bitsPerPixel,
                                        bytesPerRow: maskRef.bytesPerRow,
                                        provider: maskRef.dataProvider!, decode: nil, shouldInterpolate: false)!;
            
            let masked: CGImage = image.cgImage!.masking(mask)!
            
            let ret = UIImage(cgImage: masked)
            return ret
        }

        // Drawing code
        
        var startDeg: Float = 0
        var endDeg: Float = 0
        
        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        ctx.setStrokeColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        ctx.setLineWidth(1.0)

        let x: CGFloat = self.center.x
        let y: CGFloat = self.center.y
        let r: CGFloat = (self.bounds.size.width > self.bounds.size.height ? self.bounds.size.height : self.bounds.size.width)/2 * 0.8
        
        // Draw a thin line around the circle
        ctx.addArc(center: CGPoint(x:x ,y: y), radius: r, startAngle: 0.0, endAngle: CGFloat(360.0 * M_PI / 180.0), clockwise: false)
        
       // CGContextAddArc(ctx, x, y, r, 0.0, CGFloat(360.0 * M_PI / 180.0), 0)
        ctx.closePath()
        ctx.drawPath(using: .stroke)
        
        // Loop through all the values and draw the graph
        startDeg = 0;
        
        for item in self.items {
            let numComponents = item.color.cgColor.numberOfComponents
            
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            
            if (numComponents == 4) {
                let components = item.color.cgColor.components
                red = (components?[0])!
                green = (components?[1])!
                blue = (components?[2])!
                alpha = (components?[3])!
            }
            
            let currentValue: Float = item.value;
            
            let theta: Float = (360.0 * (currentValue/sum));
            
            if(theta > 0.0) {
                endDeg += theta;
                
                if( startDeg != endDeg ) {
                    ctx.setFillColor(red: red, green: green, blue: blue, alpha: alpha )
                    ctx.move(to: CGPoint(x: x, y: y))
                    
                    let startAngle : CGFloat = (CGFloat(startDeg)) - (90.0) * CGFloat(M_PI) / (180.0)
                    let endAngle: CGFloat = (CGFloat(endDeg)) - (90.0) * CGFloat(M_PI) / (180.0)
                    ctx.addArc(center: CGPoint(x: x , y: y), radius: r, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                    ctx.closePath()
                    ctx.fillPath()
                }
                
            }
            
            startDeg = endDeg;
        }
        
        // Gradient overlay
        let center = CGPoint(x: x, y: y)
        
        let maskImg: UIImage = createCircleMaskUsingCenterPoint(point: center, radius: Float(r))
        let gradientImage = createGradientImageUsingRect(rect: self.bounds)
        _ = maskImage(image: gradientImage, maskImage: maskImg)

        // Shadows
        self.layer.shadowRadius = 3;
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.6;
        self.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)

    }

}
