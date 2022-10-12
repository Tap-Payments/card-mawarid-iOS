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
        
        nonNullCardName = String(nonNullCardName.prefix(26))
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
    
    //MARK: Card expiry text field validations methods
    
    
}



fileprivate extension String {
    /**
     Returns all the charachters that are only digits
     - Returns: A string that has only digits from the provided string
     */
    func onlyDigits() -> String {
        return self.filter { "0123456789".contains($0) }
    }
    
    /**
     Returns all the charachters that are only digits and spaces
     - Returns: A string that has only digits and spaces from the provided string
     */
    func digitsWithSpaces() -> String {
        return self.filter { "0123456789 ".contains($0) }
    }
    
    /**
     Returns all the charachters that are only alphabet
     - Returns: A lowercase string that has only alphabet from the provided string
     */
    func alphabetOnly() -> String {
        return self.lowercased().filter { "abcdefghijklmnopqrstuvwxyz ".contains($0) }
    }
    
    /**
     Returns a formatted credit card number with the spaces in the correct palces
     - Parameter spaces: List of indices where you want to put the spaces in
     - Returns: Formatted string where a space is added at the provided indices
     */
    func cardFormat(with spaces:[Int]) -> String {
        // Create a regexx template that will decide where to put the spaces afterwards
        let regex: NSRegularExpression
        
        do {
            var pattern = ""
            var first = true
            for group in spaces {
                // For every spacing index, we will create a regex pattern of DIGTS with the length of the index provided
                pattern += "(\\d{1,\(group)})"
                if !first {
                    pattern += "?"
                }
                first = false
            }
            regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options())
        } catch {
            fatalError("Error when creating regular expression: \(error)")
        }
        
        return NSArray(array: self.onlyDigits().split(with: regex)).componentsJoined(by: " ")
    }
    
    private func split(with regex: NSRegularExpression) -> [String] {
        let matches = regex.matches(in: self, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, self.count))
        var result = [String]()
        
        matches.forEach {
            for i in 1..<$0.numberOfRanges {
                let range = $0.range(at: i)
                
                if range.length > 0 {
                    result.append(NSString(string: self).substring(with: range))
                }
            }
        }
        
        return result
    }
    
}
