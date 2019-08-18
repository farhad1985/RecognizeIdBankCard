//
//  ViewController.swift
//  Example
//
//  Created by Farhad Faramarzi on 8/18/19.
//  Copyright © 2019 Farhad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lblResult: UILabel!
    
    @IBAction func didTapScanCard(_ sender: Any) {
        let scanCard = RecognizeIdBankCard()
        scanCard.scanCard { (value) in
            DispatchQueue.main.async {
                self.lblResult.text = value
            }
        }
    }
    
}

