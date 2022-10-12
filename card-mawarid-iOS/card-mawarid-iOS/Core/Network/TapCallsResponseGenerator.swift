//
//  TapCallsResponseGenerator.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 28/07/2022.
//

import Foundation
import CommonDataModelsKit_iOS

extension NetworkManager {
    
    
    /**
     Create a card verification api request
     - Parameter for token: The token generated from the previous step which is tokenizing the card
     - Returns: The Card verification api request model
     */
    func createCardVerificationRequestModel(for token:Token) -> TapCreateCardVerificationRequestModel? {
        
        guard let customer = sharedNetworkManager.dataConfig.transactionCustomer else {
            return nil
        }
        
        let requires3DSecure    = sharedNetworkManager.dataConfig.enfroce3DS
        let shouldSaveCard      = true
        let metadata            = sharedNetworkManager.dataConfig.metadata
        let source              = SourceRequest(token: token)
        let redirect            = TrackingURL(url: WebPaymentHandlerConstants.returnURL)
        let currency            = sharedNetworkManager.dataConfig.transactionCurrency
        
        
        return TapCreateCardVerificationRequestModel                    (is3DSecureRequired:    requires3DSecure,
                                                                         shouldSaveCard:         shouldSaveCard,
                                                                         metadata:               metadata,
                                                                         customer:               customer,
                                                                         currency:               currency,
                                                                         source:                 source,
                                                                         redirect:               redirect)
        
        
    }
    
    
}
