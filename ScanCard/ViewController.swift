//
//  ViewController.swift
//  ScanCard
//
//  Created by Farhad Faramarzi on 8/13/19.
//  Copyright © 2019 Farhad. All rights reserved.
//

import UIKit
import SwiftyTesseract

class ViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lblResult: UILabel!
    
    var textScanned = "No Result" {
        didSet {
            DispatchQueue.main.async {
                self.lblResult.text = self.textScanned
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTesseract(img: #imageLiteral(resourceName: "pic11"))
    }
    
    private func setupTesseract(img: UIImage) {
        let swiftyTesseract = SwiftyTesseract(language: .custom("per"),
                                              engineMode: .tesseractOnly)
        
        swiftyTesseract.performOCR(on: img) { recognizedString in
            guard let recognizedString = recognizedString else { return }
            print(recognizedString)
            
            self.textScanned = self.getNumberCard(string: recognizedString)
        }
    }
    
    private func getNumberCard(string: String) -> String {
        let txt = String(string.reversed())
        let block = txt.components(separatedBy: "\n")
        
        let str = block
            .map { (element) -> String in
                let item = element.replacingOccurrences(of: " ", with: "")
                var idCard = ""
                let lo = NumberFormatter()
                
                lo.locale = Locale(identifier: "en")
                
                if let num = lo.number(from: item), item.count == 16 {
                    idCard = String(num.intValue)
                }
                return idCard
            }
            .filter({ (element) -> Bool in
                return !element.isEmpty
            })
            .first ?? "No Result"
        
        return str
    }
}

