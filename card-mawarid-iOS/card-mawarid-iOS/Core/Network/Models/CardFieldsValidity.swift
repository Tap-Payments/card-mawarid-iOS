//
//  CardFieldsValidity.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 02/08/2022.
//

import Foundation

/// Holds the validity of each field in the card form
@objc public class CardFieldsValidity: NSObject {
    
    
    /// The validay of the card number field
    @objc public let cardNumberValidationStatus:Bool
    /// The validay of the card expiry  field
    @objc public let cardExpiryValidationStatus:Bool
    /// The validay of the card cvv field
    @objc public let cardCVVValidationStatus:Bool
    /// The validay of the card name field
    @objc public let cardNameValidationStatus:Bool
    
    
    /// Indicates whether all fields are valid
    @objc public func allValid() -> Bool {
        return cardNumberValidationStatus && cardExpiryValidationStatus && cardCVVValidationStatus && cardNameValidationStatus
    }
    
    /**
     Holds the validity of each field in the card form
     - Parameter cardNumberValidationStatus: The validay of the card number field
     - Parameter cardExpiryValidationStatus: The validay of the card expiry  field
     - Parameter cardCVVValidationStatus: The validay of the card cvv field
     - Parameter cardNameValidationStatus: The validay of the card name field
     */
    internal init(cardNumberValidationStatus: Bool, cardExpiryValidationStatus: Bool, cardCVVValidationStatus: Bool, cardNameValidationStatus: Bool) {
        self.cardNumberValidationStatus = cardNumberValidationStatus
        self.cardExpiryValidationStatus = cardExpiryValidationStatus
        self.cardCVVValidationStatus = cardCVVValidationStatus
        self.cardNameValidationStatus = cardNameValidationStatus
    }
    
}
