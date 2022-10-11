//
//  MawaridCardView.swift
//  card-mawarid-iOS
//
//  Created by Osama Rabie on 11/10/2022.
//

import UIKit

/// The UI for collecting the card data
@objc public class MawaridCardView: UIView {

    /// The view that holds all sub views
    @IBOutlet var contentView: UIView!
    /// The title label
    @IBOutlet weak var titleLabel: UILabel!
    /// Textfield to collect the card holder name
    @IBOutlet weak var cardHolderNameTextField: UITextField!
    /// Textfield to collect the card number
    @IBOutlet weak var cardNumberTextField: UITextField!
    /// Textfield to collect the card CVV
    @IBOutlet weak var cardCVVTextField: UITextField!
    /// Textfield to collect the card expiry
    @IBOutlet weak var cardExpiryTextField: UITextField!
    /// The checkbox button for save card
    @IBOutlet weak var saveCheckBoxButton: UIButton!
    /// The title displayed to save a card
    @IBOutlet weak var saveCardLabel: UILabel!
    
    
    @IBOutlet var toBeLocalizedViews: [UIView]!
    
    /// Handles the click handler for the expiry date selection
    @IBAction func CardExpiryButtonClicked(_ sender: Any) {
    }
    
    @IBAction func SaveCheckBoxClicked(_ sender: Any) {
    }
    /*
     
     // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
