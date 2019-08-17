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
