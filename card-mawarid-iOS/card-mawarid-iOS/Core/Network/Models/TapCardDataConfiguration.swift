//
//  TapCardDataConfiguration.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 22/03/2022.
//

import Foundation
import CommonDataModelsKit_iOS
import LocalisationManagerKit_iOS

/// The datasource configiation required so the card kit can perform Init call api
@objc public class TapCardDataConfiguration: NSObject {
    
    /**
     The datasource configiation required so the card kit can perform Init call api
     - Parameter sdkMode: Represents the mode of the sdk . Whether sandbox or production
     - Parameter localeIdentifier : The ISO 639-1 Code language identefier, please note if the passed locale is wrong or not found in the localisation files, we will show the keys instead of the values
     - Parameter secretKey: The secret keys providede to your business from TAP.
     */
    @objc public init(sdkMode: SDKMode = .sandbox, localeIdentifier: String = "en", secretKey: SecretKey = .init(sandbox: "", production: "")) {
        self.sdkMode = sdkMode
        self.localeIdentifier = localeIdentifier
        self.secretKey = secretKey
        SharedCommongDataModels.sharedCommongDataModels.sdkMode = sdkMode
    }
    
    
    // MARK: Public shared values
    
    
    
    // MARK: - Private shared values
    
    /// Represents the mode of the sdk . Whether sandbox or production
    internal var sdkMode:SDKMode = .sandbox{
        didSet{
            SharedCommongDataModels.sharedCommongDataModels.sdkMode = sdkMode
        }
    }
    internal var merchantID:String = ""
    /// The ISO 639-1 Code language identefier, please note if the passed locale is wrong or not found in the localisation files, we will show the keys instead of the values
    internal var localeIdentifier:String = "en"{
        didSet{
            TapLocalisationManager.shared.localisationLocale = localeIdentifier
        }
    }
    /// The secret keys providede to your business from TAP.
    internal var secretKey:SecretKey = .init(sandbox: "", production: "")
    
    /// The currency you want to show the card brands that accepts it. Default is KWD
    internal var transactionCurrency: TapCurrencyCode = .KWD
    /// The attached customer passed for this transaction (e.g. save card)
    internal var transactionCustomer: TapCustomer?
    /// Metdata object will be a representation of [String:String] dictionary to be used whenever such a common model needed
    internal var metadata:TapMetadata? = nil
    /// Should we always ask for 3ds while saving the card. Default is true
    internal var enfroce3DS:Bool = true
    /// Holding the latest SDK settings model to fetch requierd data when needed like session token or encryption key
    internal var sdkSettings:SDKSettings?
    /// Holding the latest init model response
    internal var initModel:TapInitResponseModel?
    /// Holding the allowed card brands to process for the logged in merchant
    internal var paymentOptions:[PaymentOption]?
    
    /// Holding the latest Config response from the middleware
    internal var configModelResponse: TapConfigResponseModel?
    
    /// Holding the latest look up response from the middleware
    internal var tapBinLookUpResponse: TapBinResponseModel?
    
    /// Holding the latest card verify response from the middleware
    internal var cardVerify: TapCreateCardVerificationResponseModel?
    
    /// a block to eecute upon card save is done
    internal var onResponeSaveCardReady: (TapCreateCardVerificationResponseModel) -> () = {_ in}
    
    /// a block to eecute upon card save fails
    internal var onErrorSaveCardOccured: (Error?,TapCreateCardVerificationResponseModel?)->() = { _,_ in}
}
