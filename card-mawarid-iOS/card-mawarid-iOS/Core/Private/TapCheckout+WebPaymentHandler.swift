//
//  TapCheckoutManager+WebPaymentHandler.swift
//  CheckoutSDK-iOS
//
//  Created by Osama Rabie on 6/18/21.
//  Copyright © 2021 Tap Payments. All rights reserved.
//

import Foundation
import TapUIKit_iOS
import CommonDataModelsKit_iOS
import WebKit

/// Struct to hold the constants related to control the flow of the webview by lookin ginto constants into the loaded URL
internal struct WebPaymentHandlerConstants {
    /// Whenever we find this prefix in the URL, the backend is telling we need to stop redirecting
    static let returnURL = URL(string: "gosellsdk://return_url")!
    /// Whenever we have this key inside the URL we get the ibject id to retrieve it afterwards
    static let tapIDKey = "tap_id"
    
    //@available(*, unavailable) private init() { fatalError("This struct cannot be instantiated.") }
}

/// Web Payment URL decision.
internal struct WebPaymentURLDecision {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Defines if URL should be loaded.
    internal let shouldLoad: Bool
    
    /// Defines if web payment screen should be closed.
    internal let shouldCloseWebPaymentScreen: Bool
    
    /// Defines if web payment flow redirections are finished.
    internal let redirectionFinished: Bool
    
    /// Charge or authorize identifier.
    internal let tapID: String?
}
