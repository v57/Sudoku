//
//  Graphics.swift
//  Sudoku
//
//  Created by Dmitry Kozlov on 19.01.15.
//  Copyright (c) 2015 Dmitry Kozlov. All rights reserved.
//

import UIKit

class ImageEditor {
    class func cutImage(image: UIImage!, width: CGFloat, height: CGFloat) -> [[UIImage]] {
        
        let scale = image.scale
        
        let iconWidth: Int = Int(image.size.width / width * scale)
        let iconHeight: Int = Int(image.size.height / height * scale)
        
        var array = [[UIImage]]()
        for i in 0...Int(width)-1 {
            var secondArray = [UIImage]()
            for j in 0...Int(height)-1 {
                let rect = CGRect(x: iconWidth * i, y: iconHeight * j, width: iconWidth, height: iconHeight)
                let cgImage = image.CGImage
                let resultCG = CGImageCreateWithImageInRect(cgImage, rect)
                let result = UIImage(CGImage: resultCG!, scale: scale, orientation: .Up)
                secondArray.append(result)
            }
            array.append(secondArray)
        }
        return array
    }
    
    class func resizeImage(image: UIImage, size: CGSize, scale: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale);
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return result;
    }
    
    class func colorImage(img: UIImage!, color: UIColor) -> UIImage! {
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        let scale = retina
        UIGraphicsBeginImageContextWithOptions(rect.size, false, scale)
        color.setFill()
        UIRectFill(rect)
        let tempColor = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let maskRef = img.CGImage
        let maskcg = CGImageMaskCreate(CGImageGetWidth(maskRef),
            CGImageGetHeight(maskRef),
            CGImageGetBitsPerComponent(maskRef),
            CGImageGetBitsPerPixel(maskRef),
            CGImageGetBytesPerRow(maskRef),
            CGImageGetDataProvider(maskRef), nil, false);
        
        let maskedcg = CGImageCreateWithMask(tempColor.CGImage, maskcg)
        let result = UIImage(CGImage: maskedcg!, scale: retina, orientation: .Up)
        
        return result
    }
    
    private class func rectToCenter(rect: CGRect, center: CGPoint) -> CGRect {
        return CGRect(x: center.x-rect.size.width/2.0, y: center.y-rect.size.height/2.0, width: rect.size.width, height: rect.size.height)
    }
    
    class func combineImages(images: [UIImage], size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, retina)
        let center = CGPoint(x: size.width/2.0, y: size.height/2.0)
        for i in 0...images.count-1 {
            let image = images[i]
            let centerRect = rectToCenter(CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height), center: center)
            if i == 0 {
                image.drawInRect(centerRect)
            } else {
                image.drawInRect(centerRect, blendMode: CGBlendMode.Normal, alpha: 1.0)
            }
        }
        let result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return result;
    }
}

class Color {
    let red: UInt8
    let green: UInt8
    let blue: UInt8
    init(red: UInt8, green: UInt8, blue: UInt8) {
        self.red = red
        self.green = green
        self.blue = blue
    }
}