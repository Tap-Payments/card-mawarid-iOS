//
//  NetworkManagerApiCallsExtension.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 22/03/2022.
//

import Foundation
import CommonDataModelsKit_iOS
import TapCardVlidatorKit_iOS
import TapNetworkKit_iOS

internal extension NetworkManager {
    
    
    typealias Completion<Response: Decodable> = (Response?, TapSDKError?) -> Void
    
    /// Responsible for making the network calls needed to boot the SDK like init and payment options
    /// - Parameter onCheckoutRead: A block to execure upon completion
    /// - Parameter onErrorOccured: A block to execure upon error
    func configSDK(onCheckOutReady: @escaping () -> () = {},onErrorOccured: @escaping(Error?)->() = {_ in}) {
        
        // As per the backend logic, we will have to hit CheckoutProfileApi
        
        // let us create the tokenize card request
        let tapPaymentOptionsRequestModel:TapPaymentOptionsRequestModel = TapPaymentOptionsRequestModel(transactionMode: .cardTokenization, amount: 1, items: [.init(title: "MAWARID", description: "CARD TOKENIZE", price: 1, quantity: 1, discount: nil, currency: self.dataConfig.transactionCurrency)], shipping: nil, taxes: nil, currency: self.dataConfig.transactionCurrency, merchantID: self.dataConfig.merchantID, customer: self.dataConfig.transactionCustomer, destinationGroup: nil, paymentType: .All, totalAmount: 1, topup: nil, reference: nil, supportedCurrencies:nil, supportedPaymentMethods: nil)
        
        // Change the model into a dictionary
        guard let bodyDictionary = NetworkManager.convertModelToDictionary(tapPaymentOptionsRequestModel, callingCompletionOnFailure: { error in
            return
        }) else { return }
        
        
        sharedNetworkManager.makeApiCall(routing: .CheckoutProfileApi, resultType: TapInitResponseModel.self, body: .init(body: bodyDictionary), httpMethod: .POST) { [weak self] (session, result, error) in
            guard let paymentOptionsResponse:TapInitResponseModel = result as? TapInitResponseModel else { self?.handleError(error: "Unexpected error when parsing into TapConfigResponseModel")
                return }
            // Let us now load the payment options
            
            self?.handleInitResponse(initModel: paymentOptionsResponse)
            self?.handlePaymentOptionsResponse(paymentOptionsModel: paymentOptionsResponse.paymentOptions)
            onCheckOutReady()
        } onError: { (session, result, errorr) in
            onErrorOccured(errorr)
            self.handleError(error: errorr)
        }
    }
    
    /*/// Responsible for making the network calls needed to boot the SDK like init and payment options
    /// /// - Parameter onCheckoutRead: A block to execure upon completion
    /// - Parameter onErrorOccured: A block to execure upon error
    func initialiseSDKFromAPI(onCheckOutReady: @escaping () -> () = {} ,onErrorOccured: @escaping(Error?)->() = {_ in}) {
        // As per the backend logic, we will have to hit INIT
        sharedNetworkManager.makeApiCall(routing: .InitAPI, resultType: SDKSettingsMawarid.self, httpMethod: .GET) { [weak self] (session, result, error) in
            guard let initModel:SDKSettingsMawarid = result as? SDKSettingsMawarid else { self?.handleError(error: "Unexpected error when parsing into TapInitResponseModel")
                return }
            self?.handleInitResponse(initModel: initModel)
            self?.callPaymentOptionsAPI(onCheckOutReady: onCheckOutReady)
        } onError: { (session, result, errorr) in
            onErrorOccured(errorr)
            self.handleError(error: errorr)
        }
    }*/
    
    
    /**
     Respinsiboe for calling create token for a card api
     - Parameter cardTokenRequest: The cardToken request model to be called with
     - Parameter onResponseReady: A block to call when getting the response
     - Parameter onErrorOccured: A block to call when an error occured
     */
    func callCardTokenAPI(cardTokenRequestModel:TapCreateTokenRequest, onResponeReady: @escaping (Token) -> () = {_ in}, onErrorOccured: @escaping(Error)->() = {_ in}) {
        
        // Change the model into a dictionary
        guard let bodyDictionary = NetworkManager.convertModelToDictionary(cardTokenRequestModel, callingCompletionOnFailure: { error in
            onErrorOccured(error.debugDescription)
            return
        }) else { return }
        
        // Call the corresponding api based on the transaction mode
        // Perform the retrieve request with the computed data
        sharedNetworkManager.makeApiCall(routing: .tokens, resultType: Token.self, body: .init(body: bodyDictionary),httpMethod: .POST, urlModel: .none) { (session, result, error) in
            // Double check all went fine
            guard let parsedResponse:Token = result as? Token else {
                onErrorOccured("Unexpected error parsing into token")
                return
            }
            // Execute the on complete block
            onResponeReady(parsedResponse)
        } onError: { (session, result, errorr) in
            // In case of an error we execute the on error block
            onErrorOccured(errorr.debugDescription)
        }
    }
    
    /**
     Respinsiboe for calling a get request for a retrivable object (e.g. charge, authorization, etc.) by providing its ID
     - Parameter with identifier: The id of the object we want to retrieve
     - Parameter onResponseReady: A block to call when getting the response
     - Parameter onErrorOccured: A block to call when an error occured
     */
    func retrieveObject<T: Retrievable>(with identifier: String, completion: @escaping Completion<T>, onErrorOccured: @escaping(Error)->() = {_ in}) {
        
        // Create the GET url parameter model
        let urlModel = TapURLModel.array(parameters: [identifier])
        // Fetch the retrieve route based on the type of the object the method called on
        let route = T.retrieveRoute
        
        // Perform the retrieve request with the computed data
        sharedNetworkManager.makeApiCall(routing: route, resultType: T.self, body: .none,httpMethod: .GET, urlModel: urlModel) { (session, result, error) in
            // Double check all went fine
            guard let parsedResponse:T = result as? T else {
                onErrorOccured("Unexpected error parsing into")
                return
            }
            // Execute the on complete block
            completion(parsedResponse,nil)
        } onError: { (session, result, errorr) in
            // In case of an error we execute the on error block
            onErrorOccured(errorr.debugDescription)
        }
    }
    
    
    /**
     Respinsiboe for calling card verifiy api
     - Parameter cardVerifyRequestModel: The card verificatin request model to be called with
     - Parameter onResponseReady: A block to call when getting the response
     - Parameter onErrorOccured: A block to call when an error occured
     */
    func callCardVerifyAPI(cardVerifyRequestModel:TapCreateCardVerificationRequestModel, onResponeReady: @escaping (TapCreateCardVerificationResponseModel) -> () = {_ in}, onErrorOccured: @escaping(Error)->() = {_ in}) {
        
        // Change the model into a dictionary
        guard let bodyDictionary = NetworkManager.convertModelToDictionary(cardVerifyRequestModel, callingCompletionOnFailure: { error in
            onErrorOccured(error.debugDescription)
            return
        }) else { return }
        
        // Call the corresponding api based on the transaction mode
        // Perform the retrieve request with the computed data
        sharedNetworkManager.makeApiCall(routing: TapNetworkPath.cardVerification, resultType: TapCreateCardVerificationResponseModel.self, body: .init(body: bodyDictionary),httpMethod: .POST, urlModel: .none) { (session, result, error) in
            // Double check all went fine
            guard let parsedResponse:TapCreateCardVerificationResponseModel = result as? TapCreateCardVerificationResponseModel else {
                onErrorOccured("Unexpected error parsing into TapCreateCardVerificationResponseModel")
                return
            }
            self.dataConfig.cardVerify = parsedResponse
            // Execute the on complete block
            onResponeReady(parsedResponse)
        } onError: { (session, result, errorr) in
            // In case of an error we execute the on error block
            onErrorOccured(errorr.debugDescription)
        }
    }
    
    
    
    /// Retrieves BIN number details for the given `binNumber` and calls `completion` when request finishes.
    ///
    /// - Parameters:
    ///   - binNumber: First 6 digits of the card.
    ///   - completion: Completion that will be called when request finishes.
    func callBinLookup(for binNumber: String?, onResponeReady: @escaping (TapBinResponseModel) -> () = {_ in}, onErrorOccured: @escaping(Error)->() = {_ in}) {
        // check if we have to call the api or not
        guard let nonNullbinNumber = binNumber,
              nonNullbinNumber.count >= 6 else { resetBinData()
            return }
        
        guard shouldWeCallBinLookUpAgain(with: nonNullbinNumber.tap_substring(to: 6)) else { return }
        
        let binNumber:String = nonNullbinNumber.tap_substring(to: 6)
        let bodyModel = ["bin":binNumber]
        
        // Perform the retrieve request with the computed data
        binLookUpInProcessNumber =  binNumber
        
        sharedNetworkManager.makeApiCall(routing: TapNetworkPath.bin, resultType: TapBinResponseModel.self, body: .init(body: bodyModel), httpMethod: .POST) { [weak self] (session, result, error) in
            // Double check all went fine
            guard let parsedResponse:TapBinResponseModel = result as? TapBinResponseModel else {
                onErrorOccured("Unexpected error parsing bin details")
                return
            }
            // Store it for further access
            self?.handleBinResponse(binResponseModel: parsedResponse)
            // Execute the on complete block
            onResponeReady(parsedResponse)
        } onError: { (session, result, errorr) in
            // In case of an error we execute the on error block
            onErrorOccured(errorr.debugDescription)
        }
        
    }
    
    func resetBinData() {
        binLookUpInProcessNumber = ""
        dataConfig.tapBinLookUpResponse = nil
        CardValidator.favoriteCardBrand = nil
    }
    
    /**
     Handles error occured during an api call
     - Parameter error: The occured error
     */
    func handleError(error: Error?) {
        print(error ?? "Unknown error occured")
    }
    
    
    
    
    
    /// Converts Encodable model into its dictionary representation. Calls completion closure in case of failure.
    ///
    /// - Parameters:
    ///   - model: Model to encode.
    ///   - completion: Failure completion closure.
    ///   - response: Response object in case of success. Here - always nil.
    ///   - error: Error in case of failure. If the closure is called it will never become nil.
    /// - Returns: Dictionary.
    static func convertModelToDictionary(_ model: Encodable, callingCompletionOnFailure completion: CompletionOnFailure) -> [String: Any]? {
        
        var modelDictionary: [String: Any]
        
        do {
            modelDictionary = try model.tap_asDictionary()
        }
        catch let error {
            
            completion(TapSDKKnownError(type: .serialization, error: error, response: nil, body: model))
            return nil
        }
        
        return modelDictionary
    }
    
    
    typealias CompletionOnFailure = (TapSDKError?) -> Void
    
}
