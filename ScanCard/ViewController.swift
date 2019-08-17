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
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lblResult: UILabel!
    
    let vc = UIImagePickerController()

    var textScanned = "No Result" {
        didSet {
            DispatchQueue.main.async {
                self.lblResult.text = self.textScanned
            }
        }
    }
    
    @IBAction func didTakePicture(_ sender: Any) {
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
        
        activity.isHidden = false
        
        DispatchQueue.main.async {
            guard let i = self.image.image else {return}
            swiftyTesseract.performOCR(on: i) { recognizedString in
                print("text: \(recognizedString ?? "No Result")")

                self.activity.isHidden = true

                guard let recognizedString = recognizedString else {
                    self.textScanned = "I can't scan Card"
                    return
                }
                self.textScanned = self.getNumberCard(string: recognizedString).seperateDash()
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

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let img = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        print(img.size)
        image.image = img
        setupTesseract(img: img)
    }
}
