//
//  SDKSettings.swift
//  card-mawarid-iOS
//
//  Created by Osama Rabie on 20/10/2022.
//
import CommonDataModelsKit_iOS

import Foundation
/*/// goSell SDK Settings model.
internal class SDKSettingsMawarid: Decodable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Data.
    internal var data: SDKSettingsDataMawarid?
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case data = "data"
    }
}



/// goSell SDK settings data model.
internal struct SDKSettingsDataMawarid {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Payments mode.
    internal let isLiveMode: Bool
    
    /// Permissions.
    internal let permissions: Permissions
    
    /// Encryption key.
    internal let encryptionKey: String
    
    /// Unique device ID.
    // FIXME: Remove optionality here once backend is ready.
    internal let deviceID: String?
    
    /// Merchant information.
    internal var merchant: Merchant
    
    /// Internal SDK settings.
    internal let internalSettings: InternalSDKSettings
    
    /// Session token.
    internal private(set) var sessionToken: String?
    
    
    internal let verifiedApplication:Bool
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case isLiveMode             = "live_mode"
        case permissions            = "permissions"
        case encryptionKey          = "encryption_key"
        case deviceID               = "device_id"
        case merchant               = "merchant"
        case internalSettings       = "sdk_settings"
        case sessionToken           = "session_token"
        case verifiedApplication    = "verified_application"
    }
}

// MARK: - Decodable
extension SDKSettingsDataMawarid: Decodable {
    
    internal init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let isLiveMode            = try container.decode(Bool.self,                     forKey: .isLiveMode)
        let encryptionKey        = try container.decode(String.self,                 forKey: .encryptionKey)
        let merchant            = try container.decode(Merchant.self,                 forKey: .merchant)
        let verifiedApplication = try container.decode(Bool.self,                   forKey: .verifiedApplication)
        let internalSettings    = try container.decode(InternalSDKSettings.self,    forKey: .internalSettings)
        
        let permissions     = try container.decodeIfPresent(Permissions.self,    forKey: .permissions) ?? .tap_none
        let deviceID         = try container.decodeIfPresent(String.self,        forKey: .deviceID)
        let sessionToken    = try container.decodeIfPresent(String.self,        forKey: .sessionToken)
        
        if encryptionKey == "" {
            throw "TAP SDK ERROR : Empty Encryption Key"
        }
        
        SharedCommongDataModels.sharedCommongDataModels.encryptionKey = encryptionKey
        
        self.init(isLiveMode:             isLiveMode,
                  permissions:             permissions,
                  encryptionKey:         encryptionKey,
                  deviceID:             deviceID,
                  merchant:             merchant,
                  internalSettings:        internalSettings,
                  sessionToken:         sessionToken,
                  verifiedApplication:  verifiedApplication)
    }
}
*/
