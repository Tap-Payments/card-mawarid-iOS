//
//  CardKitValidationStatusEnum.swift
//  card-mawarid-iOS
//
//  Created by Osama Rabie on 12/10/2022.
//

import Foundation

/// An enum to list validation status values foe the card kit as a whole
@objc public enum CardKitValidationStatusEnum: Int {
    /// Means the card kit is valid and ready to process (e.g. tokenize or save the card.)
    case Valid
    /// Means the card kit is invalid and not ready to process (e.g. tokenize or save the card.)
    case Invalid
}
