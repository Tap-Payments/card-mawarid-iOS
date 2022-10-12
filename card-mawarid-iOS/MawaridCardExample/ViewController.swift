//
//  ViewController.swift
//  MawaridCardExample
//
//  Created by Osama Rabie on 11/10/2022.
//

import UIKit
import TapThemeManager2020
import card_mawarid_iOS
import CommonDataModelsKit_iOS

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
    
    @IBAction func tokenizeClicked(_ sender: Any) {
        self.view.isUserInteractionEnabled = false
        loadingIndicator.isHidden = false
        mawaridCardView.tokenizeCard { [weak self] token in
            self?.view.isUserInteractionEnabled = true
            print(token.card)
            self?.loadingIndicator.isHidden = true
            self?.showAlert(title: "Tokenized", message: token.identifier)
        } onErrorOccured: { [weak self] error, cardFieldsValidity in
            print(error)
            self?.loadingIndicator.isHidden = true
            self?.view.isUserInteractionEnabled = true
            self?.showAlert(title: "Error", message: "\(error.localizedDescription)\nAlso, tap card indicated the validity of the fields as follows :\nNumber: \(cardFieldsValidity.cardNumberValidationStatus)\nExpiry: \(cardFieldsValidity.cardExpiryValidationStatus)\nCVV: \(cardFieldsValidity.cardCVVValidationStatus)\nName: \(cardFieldsValidity.cardNameValidationStatus)")
        }
    }
    
    func showAlert(title:String, message:String) {
        DispatchQueue.main.async { [weak self] in
            let alert:UIAlertController = .init(title: title, message: message, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .cancel))
            self?.present(alert, animated: true)
        }
    }
    
}


extension ViewController:MawaridCardDelegate {
    func errorOccured(with error: CardKitErrorType, message: String) {
        eventsTextView.text = "\(eventsTextView.text ?? "")\n\(error.description) -- \(message)"
    }
    
    func eventHappened(with event: CardKitEventType) {
        eventsTextView.text = "\(eventsTextView.text ?? "")\n\(event.description)"
    }
    
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

