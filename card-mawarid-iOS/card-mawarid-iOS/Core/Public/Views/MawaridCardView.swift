//
//  MawaridCardView.swift
//  card-mawarid-iOS
//
//  Created by Osama Rabie on 11/10/2022.
//

import UIKit
import TapThemeManager2020
import LocalisationManagerKit_iOS
import CommonDataModelsKit_iOS
import SwiftyPickerPopover
import TapUIKit_iOS
import TapCardVlidatorKit_iOS

/// The UI for collecting the card data
@objc public class MawaridCardView: UIView {

    //MARK: Init methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    //MARK: Public attributes
    /// We will need to know the presenting view controller to display things like date picker
    @objc public var presentingViewController:UIViewController = .init()
    
    //MARK: Internal attributes
    internal let themePath:String = "cardView"
    /// Holds the expiration date for the card
    internal var expiryDate:Date? {
        didSet {
            postCardExpiryDate()
        }
    }
    /// Holds the card number till now
    internal var cardNumber:String = "" {
        didSet{
            postCardNumberChange()
        }
    }
    
    /// Holds the card CVV till now
    internal var cardCVV:String = "" {
        didSet{
            postCardCVVChange()
        }
    }
    
    
    /// Holds the card name till now
    internal var cardName:String = "" {
        didSet{
            postCardNameChange()
        }
    }
    
    /// Holds the last style theme applied
    private var lastUserInterfaceStyle:UIUserInterfaceStyle = .light
    /// Holds the state of save card checkbox
    internal var isSaveCardChecked:Bool = false
    /// Represents the data source for the card brands bar
    internal var dataSource:[CardBrand] {
        var totalBrands:[CardBrand] = []
        
        sharedNetworkManager.dataConfig.paymentOptions?.forEach({ option in
            var optionBrands:[CardBrand] = []
            optionBrands.append(option.brand)
            optionBrands.append(contentsOf: option.supportedCardBrands)
            
            totalBrands.append(contentsOf: optionBrands.filter{ !totalBrands.contains($0) })
        })
        
        return totalBrands
    }
    
    
    
    //MARK: UIView outlets
    /// The view that holds all sub views
    @IBOutlet var contentView: UIView!
    /// The title label
    @IBOutlet weak var titleLabel: UILabel!
    /// Textfield to collect the card holder name
    @IBOutlet weak var cardHolderNameTextField: UITextField!
    /// Textfield to collect the card number
    @IBOutlet weak var cardNumberTextField: UITextField!
    /// Textfield to collect the card CVV
    @IBOutlet weak var cardCVVTextField: UITextField!
    /// Textfield to collect the card expiry
    @IBOutlet weak var cardExpiryTextField: UITextField!
    /// The checkbox button for save card
    @IBOutlet weak var checkBoxImageView: UIImageView!
    /// The card placeholder icon image view
    @IBOutlet weak var cardIconImageView: UIImageView!
    /// The title displayed to save a card
    @IBOutlet weak var saveCardLabel: UILabel!
    /// Holds the views that need to be localised to provide RTL support
    @IBOutlet var toBeLocalizedViews: [UIView]!
    /// Holds all the textfieelds for card data input
    @IBOutlet var cardFields: [UITextField]!
    @IBOutlet weak var saveCardButton: UIButton!
    @IBOutlet weak var expiryButton: UIButton!
    
    
    //MARK: UI fired events handling
    /// Handles the click handler for the expiry date selection
    @IBAction func CardExpiryButtonClicked(_ sender: Any) {
        // The default localisation file location
        let defaultLocalisationFilePath:URL = TapCommonConstants.pathForDefaultLocalisation()
        
        // The font for the picker components
        let labelsFont:UIFont = TapThemeManager.fontValue(for: "\(themePath).titleLabel.font", shouldLocalise: false) ?? .systemFont(ofSize: 20)
        // The color of the labels in the picker components
        let labelsColor:UIColor = TapThemeManager.colorValue(for: "\(themePath).titleLabel.textColor") ?? .systemGray6
        // Define the picker components data Months/Years
        ColumnStringPickerPopover(title: TapLocalisationManager.shared.localisedValue(for: "cardExpiryPlaceholder", with: defaultLocalisationFilePath),
                                  choices: [["01", "02", "03","04","05","06","07","08","09","10","11","12"],generateExpiryDateYears()],
                                  selectedRows: [0,0], columnPercents: [0.5, 0.5])
        .setCancelButton(title: TapLocalisationManager.shared.localisedValue(for: "cancel", with: defaultLocalisationFilePath), font: nil, color: nil, action: nil)
        .setDoneButton(title: TapLocalisationManager.shared.localisedValue(for: "done", with: defaultLocalisationFilePath), font: nil, color: nil, action: { popover, selectedRows, selectedStrings in
            print("selected rows \(selectedRows) strings \(selectedStrings)")
        })
        .setSelectedRows(selectedDateParts())
        .setFontColors([.black,.black])
        .setDimmedBackgroundView(enabled: true)
        .setFonts([labelsFont,labelsFont])
        .appear(originView: sender as! UIButton, baseViewController: presentingViewController)
    }
    
    /// Handles the logic needed when the user clicks on save card check box
    @IBAction func SaveCheckBoxClicked(_ sender: Any) {
        // Flip the current status of save card
        isSaveCardChecked = !isSaveCardChecked
        // Show the right checkbox icon
        checkBoxImageView.tap_theme_image = .init(keyPath: "\(themePath).saveCheckBox.\(isSaveCardChecked ? "checkedIcon" : "uncheckedIcon")")
    }
    
    
    //MARK: Internal methods
    /// Used as a consolidated method to do all the needed steps upon creating the view
    private func commonInit() {
        self.contentView = setupXIB()
        matchThemeAttributes()
        setBrandsForValidator()
        cardNumber = ""
    }
    
    
    /// Sets the allowed card brands for the validator so he knows exactly what are we validating against
    internal func setBrandsForValidator() {
        
    }
    
    /// handles logic needed when the card expiry changes
    internal func postCardExpiryDate() {
        cardExpiryTextField.text = displayDate()
    }
    
    /// handles logic needed when the card cvv changes
    internal func postCardCVVChange() {
        cardCVVTextField.text = cardCVV
    }
    
    /// handles logic needed after card name changes
    internal func postCardNameChange() {
        cardHolderNameTextField.text = cardName
    }
    
    
    /// handles logic needed when the card number changes
    internal func postCardNumberChange() {
        // If valid, then we enable the expiry, CVV and Save. Disable otherwise
        let enableFields:Bool = detectBrand(cardNumber: cardNumber)?.validationState == .valid
        cardCVVTextField.isUserInteractionEnabled = enableFields
        expiryButton.isUserInteractionEnabled = enableFields
        saveCardButton.isUserInteractionEnabled = enableFields
        
        // Reset needed data
        expiryDate = .init()
        cardCVV = ""
    }
    
    /// The method that deals with mapping and applying the theming attributes to the different fields
    internal func matchThemeAttributes() {
        // We then call the logic required to apply different parts of the theme in success
        localise()
        setTextColors()
        setFonts()
        setCommonUI()
    }
    
    /// Sets the localisation
    internal func localise() {
        // The default localisation file location
        let defaultLocalisationFilePath:URL = TapCommonConstants.pathForDefaultLocalisation()
        // Assign the localisation values
        cardHolderNameTextField.attributedPlaceholder = .init(string: TapLocalisationManager.shared.localisedValue(for: "cardNamePlaceholder", with: defaultLocalisationFilePath))
        
        cardNumberTextField.attributedPlaceholder = .init(string: TapLocalisationManager.shared.localisedValue(for: "cardNumberPlaceholder", with: defaultLocalisationFilePath))
        
        cardCVVTextField.attributedPlaceholder = .init(string: TapLocalisationManager.shared.localisedValue(for: "cardCVVPlaceholder", with: defaultLocalisationFilePath))
        
        cardExpiryTextField.attributedPlaceholder = .init(string: TapLocalisationManager.shared.localisedValue(for: "cardExpiryPlaceholder", with: defaultLocalisationFilePath))
        
        saveCardLabel.text = TapLocalisationManager.shared.localisedValue(for: "saveCard", with: defaultLocalisationFilePath)
        
        titleLabel.text = TapLocalisationManager.shared.localisedValue(for: "title", with: defaultLocalisationFilePath)
        
        // Change the semantics
        toBeLocalizedViews.forEach{ $0.semanticContentAttribute = TapLocalisationManager.shared.localisationLocale == "ar" ? .forceRightToLeft : .forceLeftToRight }
        cardFields.forEach{ $0.textAlignment = TapLocalisationManager.shared.localisationLocale == "ar" ? .right : .left }
    }
    
    /// Helper method to match the common theming values to the view from the theme file
    internal func setCommonUI() {
        // background color
        self.backgroundColor = .clear
        contentView.tap_theme_backgroundColor = .init(keyPath: "\(themePath).containter.backgroundColor")
        // title label theme
        titleLabel.tap_theme_textColor = .init(keyPath: "\(themePath).titleLabel.textColor")
        titleLabel.tap_theme_font = ThemeFontSelector.init(stringLiteral: "\(themePath).titleLabel.font",shouldLocalise: true)
        // Save card label theme
        saveCardLabel.tap_theme_textColor = .init(keyPath: "\(themePath).saveLabel.textColor")
        saveCardLabel.tap_theme_font = ThemeFontSelector.init(stringLiteral: "\(themePath).saveLabel.font",shouldLocalise: true)
        // Set the icons
        checkBoxImageView.tap_theme_image = .selectorWithKeyPath("\(themePath).saveCheckBox.uncheckedIcon")
        cardIconImageView.tap_theme_image = .selectorWithKeyPath("\(themePath).cardIcon")
        
    }
    
    /// Helper method to set the font color for all text fields
    internal func setTextColors() {
        cardFields.forEach{ $0.tap_theme_textColor = .init(keyPath: "\(themePath).textFields.textColor") }
        
        cardFields.forEach{ $0.attributedPlaceholder =  NSAttributedString(string: $0.attributedPlaceholder?.string ?? "", attributes: [.foregroundColor : TapThemeManager.colorValue(for: "\(themePath).textFields.placeholderColor") ?? .black]) }
    }
    
    /// Helper method to set the font for all text fields
    internal func setFonts() {
        cardFields.forEach{ $0.tap_theme_font = ThemeFontSelector.init(stringLiteral: "\(themePath).textFields.font",shouldLocalise: true) }
        cardFields.forEach{ $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged) }

    }
    
    /// Helper method to set the delegates for all text fields
    internal func setDelegates() {
        // Listen to text changes
        cardFields.forEach{ $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged) }
        
    }
    
    /// Handles the logic needed to be performed upong text changes in one of the card form text fields
    @objc internal func textFieldDidChange(_ textField: UITextField) {
        // We need to know which text field it is, to perform the correct post changes logic
        print(textField.text ?? "")
        if textField == cardNumberTextField {
            cardNumberTextField.text = correctText(cardNumber: cardNumberTextField.text)
        }else if textField == cardCVVTextField {
            let _ = correctText(cvv: cardCVVTextField.text)
        }else if textField == cardHolderNameTextField {
            let _ = correctText(cardName: cardHolderNameTextField.text)
        }
    }
    
    
    /// Returns the selectable years of expiration. From current Year + 10
    internal func generateExpiryDateYears() -> [String] {
        let minYear = Calendar.current.component(.year, from: Date())
        let maxYear = minYear + 10
        return (minYear...maxYear).map{ "\($0)" }
    }
    
    /// Returns a displayable string in the format of MM/YY
    internal func displayDate() -> String {
        guard let expiryDate = expiryDate else { return "" }
        return "\(expiryDate.tap_month)/\(expiryDate.tap_year)"
    }
    
    /// Returns which date components should be selected
    internal func selectedDateParts() -> [Int] {
        let date = Date()
        let calendar = NSCalendar.current
        
        let year:Int =  calendar.component(.year, from: date)
        let month:Int = calendar.component(.month, from: date)
        
        return [(month-1),generateExpiryDateYears().firstIndex(of: "\(year)") ?? 0]
    }
    
    /// Listen to light/dark mde changes and apply the correct theme based on the new style
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        TapThemeManager.changeThemeDisplay(for: self.traitCollection.userInterfaceStyle)
        
        guard lastUserInterfaceStyle != self.traitCollection.userInterfaceStyle else {
            return
        }
        lastUserInterfaceStyle = self.traitCollection.userInterfaceStyle
        matchThemeAttributes()
    }
}


extension MawaridCardView: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
