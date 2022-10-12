//
//  TapCardForumLocalisation.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 22/03/2022.
//

import Foundation
import LocalisationManagerKit_iOS

/**
 Represents a model to pass custom localisation  files if required.
 If you want to add a custom localisation please do the following:
 * Download the original [Default localisation](https://github.com/Tap-Payments/CommonDataModelsKit-iOS/blob/master/CommonDataModelsKit-iOS/CommonDataModelsKit-iOS/Core/assets/DefaultTapLocalisation.json) and
 * Embedd them as assets inside your own project.
 * Adjust the needed values inside them
 * Pass their names in this Object
 */
@objc public class TapCardForumLocalisation: NSObject {
    /// Represents a direct provided JSON localisation data
    internal var localisationData:[String:Any]?
    /// Represents the file name of the custom provided localisation file
    internal var filePath:URL?
    /// Represents the type of the provided custom localisation, whether it is local embedded or a remote JSON file
    internal var localisationType:TapLocalisationType?
    /// Represents if the parent app wants the card forum to flip itself horizontally
    internal var shouldFlip:Bool = false
    /// The ISO 639-1 Code language identefier, please note if the passed locale is wrong or not found in the localisation files, we will show the keys instead of the values
    internal var localeIdentifier:String = "en"
    
    /**
     Represents a model to pass custom localisation  files if required.
     - Parameter filePath: The name of the light mode theme you file in your project you want to use. It is required
     - Parameter localisationType:  Represents the type of the provided custom localisation, whether it is local embedded or a remote JSON file
     - Parameter shouldFlip: Represents if the parent app wants the card forum to flip itself horizontally. Default is false
     - Parameter localeIdentifier: The ISO 639-1 Code language identefier, please note if the passed locale is wrong or not found in the localisation files, we will show the keys instead of the values
     */
    @objc public init(with filePath:URL? = nil,from localisationType:TapLocalisationType = .LocalJsonFile, shouldFlip:Bool = false, localeIdentifier:String = "en") {
        super.init()
        
        self.localisationType = localisationType
        self.filePath = filePath
        self.shouldFlip = shouldFlip
        self.localeIdentifier = localeIdentifier
    }
    
    /**
     Represents a model to pass custom localisation  files if required.
     - Parameter localisationData: Represents a direct provided JSON localisation data
     - Parameter shouldFlip: Represents if the parent app wants the card forum to flip itself horizontally. Default is false
     - Parameter localeIdentifier: The ISO 639-1 Code language identefier, please note if the passed locale is wrong or not found in the localisation files, we will show the keys instead of the values
     */
    @objc public init(with localisationData:[String:Any], shouldFlip:Bool = false, localeIdentifier:String = "en") {
        super.init()
        
        self.localisationData = localisationData
        self.localisationType = .DirectData
        self.shouldFlip = shouldFlip
        self.localeIdentifier = localeIdentifier
    }
}
