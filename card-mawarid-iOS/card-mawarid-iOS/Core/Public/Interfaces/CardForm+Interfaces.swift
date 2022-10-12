//
//  CardForm+Interfaces.swift
//  card-mawarid-iOS
//
//  Created by Osama Rabie on 12/10/2022.
//

import Foundation
import CommonDataModelsKit_iOS

extension MawaridCardView {
    
    /**
     Handles tokenizing the current card data.
     - Parameter onResponeReady: A callback to listen when a token is successfully generated
     - Parameter onErrorOccured: A callback to listen when tokenization fails with error message and the validity of all the card fields for your own interest
     */
    @objc public func tokenizeCard(onResponeReady: @escaping (Token) -> () = {_ in}, onErrorOccured: @escaping(Error,CardFieldsValidity)->() = {_,_  in}) {
        // get the validity of all fields
        let cardFieldsValidity = CardFieldsValidity(cardNumberValidationStatus: cardNumberIsValid(), cardExpiryValidationStatus: true, cardCVVValidationStatus: cardCVVValid(), cardNameValidationStatus: cardNumberIsValid())
        
        // Check that the card kit is already initilzed
        guard let _ = sharedNetworkManager.dataConfig.sdkSettings else {
            onErrorOccured("You have to call the initCardForm method first. This allows the card form to get the data needed to communicate with Tap's backend apis.",cardFieldsValidity)
            return
        }
        
        // Check that the user entered a valid card data first
        guard formValidationStatus() == .Valid,
              let nonNullTokenizeCard:CreateTokenCard = try? .init(card: currentTapCard, address: nil) else {
            onErrorOccured("The user didn't enter a valid card data to tokenize. Please prompt the user to do so first.",cardFieldsValidity)
            return
        }
        delegate?.eventHappened(with: .TokenizeStarted)
        sharedNetworkManager.callCardTokenAPI(cardTokenRequestModel: TapCreateTokenWithCardDataRequest(card: nonNullTokenizeCard)) { [weak self] token in
            self?.delegate?.eventHappened(with: .TokenizeEnded)
            onResponeReady(token)
        } onErrorOccured: { [weak self] error in
            self?.delegate?.eventHappened(with: .TokenizeEnded)
            onErrorOccured(error, cardFieldsValidity)
        }
        
    }
}
