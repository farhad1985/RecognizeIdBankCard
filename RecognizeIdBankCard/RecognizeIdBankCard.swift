//
//  ViewController.swift
//  ScanCard
//
//  Created by Farhad Faramarzi on 8/13/19.
//  Copyright © 2019 Farhad. All rights reserved.
//

import UIKit
import SwiftyTesseract

open class RecognizeIdBankCard: UIViewController {
    
    typealias Completion = (String) -> ()

    var completion: Completion?

    let vc = UIImagePickerController()
    
    public init(frame: CGRect) {
        super.init(nibName: nil, bundle: nil)
        view.frame = frame
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func scanCard(completion: @escaping((String) -> ())) {
        self.completion = completion
        takePicture()
    }
    
    private func takePicture() {
        DispatchQueue.main.async {
            self.vc.sourceType = .camera
            self.vc.allowsEditing = true
            self.vc.delegate = self
            self.present(self.vc, animated: true)
        }
    }
    
    private func setupTesseract(img: UIImage) {
        let swiftyTesseract = SwiftyTesseract(language: .custom("per"),
                                              engineMode: .tesseractOnly)
        
        DispatchQueue.main.async {
            var textScanned = "No Result"
            swiftyTesseract.performOCR(on: img) { recognizedString in
                print("text: \(recognizedString ?? "No Result")")

                guard let recognizedString = recognizedString else {
                    textScanned = "I can't scan Card"
                    return
                }
                textScanned = self.getNumberCard(string: recognizedString)
                
                self.completion?(textScanned)
            }
        }
    }
    
    private func getNumberCard(string: String) -> String {
        let txt = String(string.reversed())
        let block = txt.components(separatedBy: "\n")
        let bundle = Bundle(for: type(of: self))

        let str = block
            .map { (element) -> String in
                let item = element.replacingOccurrences(of: " ", with: "")
                var idCard = ""

                let cardNumber = item.correctNumber(bundle: bundle)
                
                print(cardNumber)
                if cardNumber.count == 16 {
                    idCard = String(cardNumber)
                }
                return idCard
            }
            .filter({ (element) -> Bool in
                return !element.isEmpty
            })
            .first ?? ""
        return str
    }
}

extension RecognizeIdBankCard: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let img = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        setupTesseract(img: img.getScannedImage() ?? img)
    }
}
