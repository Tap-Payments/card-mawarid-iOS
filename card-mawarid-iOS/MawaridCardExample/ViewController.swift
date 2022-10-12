//
//  ViewController.swift
//  MawaridCardExample
//
//  Created by Osama Rabie on 11/10/2022.
//

import UIKit
import TapThemeManager2020
import card_mawarid_iOS

class ViewController: UIViewController {

    @IBOutlet weak var mawaridCardView: MawaridCardView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var eventsTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mawaridCardView.presentingViewController = self
        mawaridCardView.delegate = self
        loadingIndicator.isHidden = true
    }
}


extension ViewController:MawaridCardDelegate {
    func cardValidationStatusChanged(to: CardKitValidationStatusEnum) {
        switch to {
        case .Valid:
            eventsTextView.text = "\(eventsTextView.text ?? "")\nCard Form is : VALID"
            print("VALID")
        case .Invalid:
            eventsTextView.text = "\(eventsTextView.text ?? "")\nCard Form is : INVALID"
        }
    }
    
    
}

