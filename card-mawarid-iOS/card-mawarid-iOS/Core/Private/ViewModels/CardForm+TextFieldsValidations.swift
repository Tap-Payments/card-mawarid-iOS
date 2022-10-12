//
//  CardFormViewModel.swift
//  card-mawarid-iOS
//
//  Created by Osama Rabie on 12/10/2022.
//

import Foundation
import TapCardVlidatorKit_iOS


/// View modelt o handle the logic and data for the card view
extension MawaridCardView {
    
    //MARK: Card number text field validations methods
    
    /**
     Detects which brand is it it
     - parameter cardNumber: The number you want to check which brand is it
     - returns: The defined card brand with the validation status if any
     */
    internal func detectBrand(cardNumber:String) -> DefinedCardBrand? {
        return CardValidator.validate(cardNumber: cardNumber, preferredBrands: dataSource)
        
    }
    
    /**
     Defines the correct text to be displayed in the card number field after a user change
     */
    internal func correctText(cardNumber:String?) -> String {
        var nonNullCardNumber:String = cardNumber ?? ""
        nonNullCardNumber = nonNullCardNumber.onlyDigits()
        // first we check if there is a valid brand detected or not
        guard let validate = detectBrand(cardNumber: nonNullCardNumber),
              validate.cardBrand != .unknown else {
            self.cardNumber = ""
            return ""
        }
        // If status is invald, we ignore the latest change :)
        if validate.validationState == .invalid {
            nonNullCardNumber = String(nonNullCardNumber.dropLast())
        }
        // If there is a detected brand then we space the text based on the card brand scheme
        let spacing = CardValidator.cardSpacing(cardNumber: nonNullCardNumber)
        self.cardNumber = nonNullCardNumber
        return nonNullCardNumber.cardFormat(with: spacing)
    }
    
    
    //MARK: Card name text field validations methods
    /**
     Defines the correct text to be displayed in the card cvv field after a user change
     */
    internal func correctText(cardName:String?) -> String {
        var nonNullCardName:String = cardName ?? ""
        nonNullCardName = nonNullCardName.alphabetOnly()
        // we limit to the maximum length allowed
        
        nonNullCardName = String(nonNullCardName.prefix(26)).uppercased()
        self.cardName = nonNullCardName
        return nonNullCardName
    }
    
    //MARK: Card cvv text field validations methods
    /**
     Defines the correct text to be displayed in the card cvv field after a user change
     */
    internal func correctText(cvv:String?) -> String {
        var nonNullCVV:String = cvv ?? ""
        nonNullCVV = nonNullCVV.onlyDigits()
        // first we check if there is a valid brand detected or not
        guard let validate = detectBrand(cardNumber: cardNumber),
              validate.cardBrand != .unknown else {
            cardCVV = ""
            return "" }
        // Then we need to make sure that the CVV has a max of the allowed CVV length for the detected brand
        nonNullCVV = String(nonNullCVV.prefix(CardValidator.cvvLength(for: validate.cardBrand)))
        cardCVV = nonNullCVV
        return nonNullCVV
    }
    
    //MARK: Form validation methods
    
    /// Checks if the card name entered matches all needed requirements
    internal func cardNameIsValid() -> Bool {
        return cardName.alphabetOnly().lowercased() == cardName.lowercased() &&
        cardName.count > 2 &&
        cardName.count <= 26
    }
    
    /// Checks if the card number entered matches all needed requirements
    internal func cardNumberIsValid() -> Bool {
        guard let definedBrand = detectBrand(cardNumber: cardNumber),
              definedBrand.validationState == .valid,
              definedBrand.cardBrand != .unknown else {
            return false
        }
        return true
    }
    
    /// Checks if the card cvv entered matches all needed requirements
    internal func cardCVVValid() -> Bool {
        guard let definedBrand = detectBrand(cardNumber: cardNumber),
              cardNameIsValid(),
              cardCVV.onlyDigits() == cardCVV,
              cardCVV.count == CardValidator.cvvLength(for: definedBrand.cardBrand) else {
            return false
        }
        return true
    }
    
    /// Checks the overall form validation status. Meaning if all the fields are fully valid entered
    internal func formValidationStatus() -> CardKitValidationStatusEnum {
        if cardNameIsValid(),
           cardCVVValid(),
           cardNameIsValid() {
            formValidation = .Valid
            return .Valid
        }
        formValidation = .Invalid
        return .Invalid
    }
}
