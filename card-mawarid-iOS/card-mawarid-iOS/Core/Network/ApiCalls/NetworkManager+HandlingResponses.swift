//
//  NetworkManager+HandlingResponses.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 29/07/2022.
//

import Foundation
import CommonDataModelsKit_iOS
import TapCardVlidatorKit_iOS

/// Has the methods to process api calls
extension NetworkManager {
    
    
    // MARK:- Init based methods
    /**
     Handles the result of the config api by storing it in the right place to be further processed
     - Parameter configModel: The response model from backend we need to deal with
     */
    func handleConfigResponse(configModel:TapConfigResponseModel) {
        // Store the config model for further access
        sharedNetworkManager.dataConfig.configModelResponse = configModel
    }
    
    /**
     Handles the response of init api call. Stores the data for further access
     - Parameter initModel: The init response model from the latest INIT api call
     */
    func handleInitResponse(initModel: TapInitResponseModel) {
        
        sharedNetworkManager.dataConfig.sdkSettings = initModel.data
        sharedNetworkManager.dataConfig.paymentOptions = initModel.cardPaymentOptions.paymentOptions        
        sharedNetworkManager.dataConfig.paymentOptions = sharedNetworkManager.dataConfig.paymentOptions?.filter { ($0.paymentType == .Card && $0.supportedCurrencies.contains(sharedNetworkManager.dataConfig.transactionCurrency)) }
    }
    
    
    // MARK:- Card binlookup based methods
    
    /**
     Handles the response of binlookup api call. Stores the data for further access
     - Parameter binResponseModel: The bin look up response model from the latest  api call
     */
    func handleBinResponse(binResponseModel: TapBinResponseModel) {
        sharedNetworkManager.dataConfig.tapBinLookUpResponse = binResponseModel
    }
    
    
    // MARK:- Card saving based methods
    /**
     Performs the logic post verifying a card
     - Parameter with cardVerifyResponse: The cardVerifyResponse response we want to analyse and decide the next action based on it
     - Parameter onResponeReady: A callback to listen when a the save card is finished successfully. Will provide all the details about the saved card data
     - Parameter onErrorOccured: A callback to listen when tokenization fails.
     - Parameter on3DSRedirectURL: A callback to tell the UIView we need to show a web view for 3ds
     */
    func handleCardVerify(with cardVerifyResponse:TapCreateCardVerificationResponseModel,
                          on3DSRedirectURL: @escaping(URL)->() = { _ in }) {
        // Based in the card verify response we will proceed
        dataConfig.cardVerify = cardVerifyResponse
        
        let verifyStatus = cardVerifyResponse.status
        switch verifyStatus {
        case .valid:
            handleCardSaveValid(for:cardVerifyResponse)
            break
        case .invalid:
            handleCardSaveInValid(for:cardVerifyResponse)
            break
        case .initiated:
            handleCardSaveInitiated(for:cardVerifyResponse, on3DSRedirectURL: on3DSRedirectURL)
            break
        }
    }
    
    
    
    /**
     Will be called once the save card response shows that, the saving has been successfully done.
     - Parameter for cardVerifyResponse: The save card object that has all the details
     - Parameter onResponeReady: A callback to listen when a the save card is finished successfully. Will provide all the details about the saved card data
     - Parameter onErrorOccured: A callback to listen when tokenization fails.
     */
    func handleCardSaveValid(for cardVerifyResponse:TapCreateCardVerificationResponseModel) {
        // First let us inform the caller app that the save card had been done successfully
        sharedNetworkManager.dataConfig.onResponeSaveCardReady(cardVerifyResponse)
    }
    
    /**
     Will be called once the save card response shows that, the saving has failed.
     - Parameter for cardVerifyResponse: The save card object that has all the details
     - Parameter onResponeReady: A callback to listen when a the save card is finished successfully. Will provide all the details about the saved card data
     - Parameter onErrorOccured: A callback to listen when tokenization fails.
     */
    func handleCardSaveInValid(for cardVerifyResponse:TapCreateCardVerificationResponseModel) {
        // First let us inform the caller app that the save card had failed
        sharedNetworkManager.dataConfig.onErrorSaveCardOccured(nil,cardVerifyResponse)
    }
    
    /**
     Will be called once the save card response shows that, the saving has started, most probapy it has 3ds.
     - Parameter for cardVerifyResponse: The save card object that has all the details
     - Parameter onResponeReady: A callback to listen when a the save card is finished successfully. Will provide all the details about the saved card data
     - Parameter onErrorOccured: A callback to listen when tokenization fails.
     - Parameter on3DSRedirectURL: A callback to tell the UIView we need to show a web view for 3ds
     */
    func handleCardSaveInitiated(for cardVerifyResponse:TapCreateCardVerificationResponseModel,
                                 on3DSRedirectURL: @escaping(URL)->() = { _ in }) {
        // Check if we need to make a redirection
        if let redirectionURL:URL = cardVerifyResponse.transactionDetails.url {
            on3DSRedirectURL(redirectionURL)
        }
    }
    
    
    /**
     Performs the logic post tokenizing a card in a save card mode
     - Parameter with token: The token response we want to analyse and decide the next action based on it
     - Parameter onResponeReady: A callback to listen when a the save card is finished successfully. Will provide all the details about the saved card data
     - Parameter onErrorOccured: A callback to listen when tokenization fails.
     - Parameter on3DSRedirectURL: A callback to tell the UIView we need to show a web view for 3ds
     */
    func handleTokenCardSave(with token:Token,
                             on3DSRedirectURL: @escaping(URL)->() = { _ in }) {
        // If all good we need to make a call to card verify api
        guard let cardVerifyRequest:TapCreateCardVerificationRequestModel = createCardVerificationRequestModel(for: token) else {
            sharedNetworkManager.dataConfig.onErrorSaveCardOccured("Failed while creating TapCreateCardVerificationRequestModel", nil)
            return
        }
        
        // Let us hit the card verify api
        callCardVerifyAPI(cardVerifyRequestModel: cardVerifyRequest) { [weak self] cardVerifyResponse in
            DispatchQueue.main.async{
                // Process the card verify response we got from the server
                guard let nonNullSelf = self else { return }
                nonNullSelf.handleCardVerify(with: cardVerifyResponse,
                                             on3DSRedirectURL: on3DSRedirectURL)
            }
        } onErrorOccured: { [weak self] error in
            self?.handleError(error: error)
        }
    }
    
    
    /**
     Handles the logic to be executed when redirection is finished for card saving
     - Parameter with tapID: The tap id of the object (card saving) generated from the backend in the URL
     - Parameter onResponeReady: A callback to listen when a the save card is finished successfully. Will provide all the details about the saved card data
     - Parameter onErrorOccured: A callback to listen when tokenization fails.
     */
    func cardPaymentProcessFinished(with tapID:String) {
        // We need to retrieve the object using the passed id and process it afterwards
        retrieveObject(with: tapID) { [weak self] (returnVerifiedSaveCard: TapCreateCardVerificationResponseModel?, error: TapSDKError?) in
            if let error = error {
                sharedNetworkManager.dataConfig.onErrorSaveCardOccured(error,nil)
            }else if let returnVerifiedSaveCard = returnVerifiedSaveCard {
                // No errors occured we need to process the current charge or authorize
                self?.handleCardVerify(with: returnVerifiedSaveCard)
            }
        } onErrorOccured: { error in
            sharedNetworkManager.dataConfig.onErrorSaveCardOccured(error,nil)
        }
        
    }
    
}
