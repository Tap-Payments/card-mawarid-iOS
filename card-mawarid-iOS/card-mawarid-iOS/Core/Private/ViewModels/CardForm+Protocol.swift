//
//  CardForm+Protocol.swift
//  card-mawarid-iOS
//
//  Created by Osama Rabie on 12/10/2022.
//

import Foundation
import CommonDataModelsKit_iOS

/// A delegate callbacks to get information from the card form itself
@objc public protocol MawaridCardDelegate {
    
    /// Will be fired when the validation status of the form changes. And will let you know if the card form is ready to do be processed or not
    @objc func cardValidationStatusChanged(to:CardKitValidationStatusEnum)
    /// Will be fired once the card form faces any error
    @objc func errorOccured(with error:CardKitErrorType, message:String)
    /**
     Be updated by listening to events fired from the card kit
     - Parameter with event: The event just fired
     */
    @objc func eventHappened(with event:CardKitEventType)
    
    /// Will be fired to indicate whether the user wants to save the card or not
    @objc func saveCardCheckBoxChanged(to:Bool)
    
}
