//
//  GenericTapChipViewModel.swift
//  TapUIKit-iOS
//
//  Created by Osama Rabie on 6/14/20.
//  Copyright © 2020 Tap Payments. All rights reserved.
//
import class TapApplePayKit_iOS.TapApplePayToken

/// A protocl of methods to be applied to all chips viewmodel to infom the view model with needed events
internal protocol GenericChipViewModelDelegate {
    
    /**
     The event will be fired when a successful apple pay authorization happened
     - Parameter viewModel: Represents The attached view model
     - Parameter token: Represents Tap wrapper for the generated token
     */
    func applePayAuthoized(for viewModel:ApplePayChipViewCellModel, with token:TapApplePayToken)
    /**
     The event will be fired when the user cliks on a saved card chip
     - Parameter viewModel: Represents The attached view model
     */
    func savedCard(for viewModel:SavedCardCollectionViewCellModel)
    /**
     The event will be fired when the user cliks on a gateway chip
     - Parameter viewModel: Represents The attached view model
     */
    func gateway(for viewModel:GatewayChipViewModel)
    /**
     The event will be fired when the user cliks on a goPay chip
     - Parameter viewModel: Represents The attached view model
     */
    func goPay(for viewModel:TapGoPayViewModel)
    /**
     The event will be fired when the user cliks on a currency chip
     - Parameter viewModel: Represents The attached view model
     */
    func currencyChip(for viewModel:CurrencyChipViewModel)
    
    /**
     The event will be fired when the user cliks on delete icon in the chip
     - Parameter viewModel: Represents The attached view model
     */
    func deleteChip(for viewModel:SavedCardCollectionViewCellModel)
    /**
     The event will be fired when the user cliks on logout icon in the chip
     - Parameter viewModel: Represents The attached view model
     */
    func logoutChip(for viewModel:TapLogoutChipViewModel)
}


/// A protocl of methods to be applied to all generated chip cells to infom the view model with needed events
@objc internal protocol GenericCellChipViewModelDelegate {
    /**
     Each view model should have an interface to know his cell is selected or nt. Fired from the cell itself
     - parameter status: tTrue if it was just selected and false otherwise
     */
    func changeSelection(with status:Bool)
    
    /**
     Each view model should have an interface to change its ui based on the current editing mode status
     - parameter to: True means, the editing mode is on
     */
    func changedEditMode(to:Bool)
    /**
     Each view model should have an interface to change its ui based on the current enabled/disabled mode status
     - parameter to: True means, enabled
     */
    func changedDisabledMode(to:Bool)
    
    /**
     For the saved card view model, there is a different UI it can show which is loading while deleting the card
     */
    @objc optional func showLoadingState()
    
    /**
     For the saved card view model, there is a different UI it can hide which is loading while deleting the card
     */
    @objc optional func hideLoadingState()
}

/// This is a superclass for all the chips view models created, this will make sure all have the same interface/output and ease the parametery type in methods
@objc public class GenericTapChipViewModel:NSObject,Codable {
    
    /// The title to be displayed if any in the Chip cell
    @objc public var title:String?
    /// The icon if any to be displayed in the Chip cell
    @objc public var icon:String?
    /// The disabled  icon if any, to be displayed when the chip is in disabled mode
    @objc public var disabledIcon:String?
    /// Indicates whether the view model should show the editing state or not
    @objc public var editMode:Bool = false {
        didSet{
            changedEditMode(to:editMode)
        }
    }
    
    /// Indicates if this payment chip is one of the enabled or disabled ones
    @objc public var isDisabled:Bool = false {
        didSet{
            changedDisabled(to:isDisabled)
        }
    }
    
    /// Unique identifier for the object.
    @objc public var paymentOptionIdentifier: String
    
    /// A protocl of methods to be applied to all chips viewmodel to infom the view model with needed events
    internal var viewModelDelegate:GenericChipViewModelDelegate?
    
    
    /// A correct var computation for which icon to display based on enabled/disabled status
    internal var displayIcon:String? {
        return isDisabled ? disabledIcon : icon
    }
    /**
     Creates a view model with the provided data
     - Parameter title: The title to be displayed if any in the Chip cell default is nil
     - Parameter icon:The icon if any to be displayed in the Chip cell default is nil
     - Parameter paymentOptionIdentifier:Unique identifier for the object.
     - Parameter isDisabled: Indicates if this payment chip is one of the enabled or disabled ones
     - Parameter disabledIcon: The disabled  icon if any, to be displayed when the chip is in disabled mode
     */
    @objc public init(title:String? = nil, icon:String? = nil, paymentOptionIdentifier:String = "", isDisabled:Bool = false, disabledIcon:String? = "") {
        self.title = title
        self.icon = icon
        self.paymentOptionIdentifier = paymentOptionIdentifier
        self.isDisabled = isDisabled
        self.disabledIcon = disabledIcon
    }
    
    /**
     Each Chip View Model will be responsible to create a unique identifir for himself and for the collectionviewcell attached to it
     - Returns: The identefier to be used in declaring the type and to dequeue the cells from the collectionview
     */
    func identefier() -> String {
        return ""
    }
    
    ///Each Chip View Model must have an interface to know that his assocated cell is selected to do the needed logic
    func didSelectItem() {
        return
    }
    
    ///Each Chip View Model must have an interface to know that his assocated cell is deselected to do the needed logic
    func didDeselectItem() {
        return
    }
    
    /**
     Each Chip View Model will be responsible udpate its UI based on the current editing status
     - Parameter to: If set means the editing mode is on, otherwise, editing mode is off
     */
    func changedEditMode(to:Bool) {
        return
    }
    
    /**
     Each Chip View Model will be responsible udpate its UI based on the current enabled/disabled status
     - Parameter to: If set means the disabled mode is on, otherwise, disabled mode is off
     */
    func changedDisabled(to:Bool) {
        return
    }
    
    /**
     To consolidate the code as much as possible, each view model is reponsible for casting in a generic uicollectionviewcell into his associated type. This will keep the view unaware of the inner classes
     - Returns: The correctly typed cell based on the type of the view model
     */
    func correctCellType(for cell:GenericTapChip) -> GenericTapChip {
        return cell
    }
    
    enum CodingKeys: String, CodingKey {
        case title                      = "title"
        case icon                       = "icon"
        case paymentOptionIdentifier    = "paymentOptionIdentifier"
        case isDisabled                 = "isDisabled"
        case disabledIcon               = "disabledIcon"
    }
    
    required public init(from decoder: Decoder) throws {
        let values                      = try decoder.container(keyedBy: CodingKeys.self)
        self.title                      = try values.decodeIfPresent(String.self, forKey: .title)
        self.icon                       = try values.decodeIfPresent(String.self, forKey: .icon)
        self.isDisabled                 = try values.decodeIfPresent(Bool.self, forKey: .isDisabled) ?? false
        self.disabledIcon               = try values.decodeIfPresent(String.self, forKey: .disabledIcon)
        self.paymentOptionIdentifier    = try values.decodeIfPresent(String.self, forKey: .paymentOptionIdentifier) ?? ""
    }
    
}
