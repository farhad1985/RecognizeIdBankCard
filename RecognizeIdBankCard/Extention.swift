//
//  Util.swift
//  ScanCard
//
//  Created by Farhad Faramarzi on 8/17/19.
//  Copyright © 2019 Farhad. All rights reserved.
//

import UIKit

extension String {
    func seperateDash() -> String {
        var text = ""
        var index = 1
        
        for i in self {
            text += String(i)
            
            if index % 4 == 0 {
                text += "-"
            }
            index += 1
        }
        if text.count > 0 {
            text.removeLast()
        }
        return text
    }
    
    func correctNumber(bundle: Bundle) -> String {
        var text = ""
        guard let pathSource = bundle.path(forResource: "datasourceLanguage",
                                           ofType: "plist")
            else { return "" }
        
        guard let datasource = NSDictionary(contentsOfFile: pathSource) else {return ""}
        
        for i in self {
            if let char = datasource[String(i)] as? String {
                text += char
            }
        }
        return text
    }
    
}

extension UIImage {
    func getScannedImage() -> UIImage? {
        
        let openGLContext = EAGLContext(api: .openGLES2)
        let context = CIContext(eaglContext: openGLContext!)
        
        let filter = CIFilter(name: "CIColorControls")
        let coreImage = CIImage(image: self)
        
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        //Key value are changable according to your need.
        filter?.setValue(4, forKey: kCIInputContrastKey)
        filter?.setValue(4, forKey: kCIInputSaturationKey)
        filter?.setValue(1.5, forKey: kCIInputBrightnessKey)
        
        if let outputImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let output = context.createCGImage(outputImage, from: outputImage.extent)
            return UIImage(cgImage: output!)
        }
        return nil
    }
}
