//
//  CardForm+Protocol.swift
//  card-mawarid-iOS
//
//  Created by Osama Rabie on 12/10/2022.
//

import Foundation

/// A delegate callbacks to get information from the card form itself
@objc public protocol MawaridCardDelegate {
    
    /// Will be fired when the validation status of the form changes. And will let you know if the card form is ready to do be processed or not
    @objc func cardValidationStatusChanged(to:CardKitValidationStatusEnum)
    
}
