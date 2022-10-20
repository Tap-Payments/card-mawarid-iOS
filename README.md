# Brief

A dedicated card collection UIView for Mawarid, while being PCI compliant.

# Requirements

1. Swift 4.0+
  
2. iOS 13.0+
  

# Installation

You can install with cocoapods by adding this `card-mawarid-iOS` to the pod file. Then run the following command

```tremor
pod install
```

# Adding UIView

1. From `storyboard` you can drag and drop a `UIView`.
  
2. From the `inspector` set the class to `MawaridCardView`.
  
3. Set the `height` to `330`.
  

![](file:///Users/osamarabie/Desktop/Screen%20Shot%202022-10-20%20at%2011.00.04%20PM.png?msec=1666299613956)

# Initialisation

To init the card kit, you will need to pass required data `before` showing the card view.

```swift

/**
     The datasource configiation required so the card kit can perform Init call api
     - Parameter sdkMode: Represents the mode of the sdk . Whether sandbox or production
     - Parameter localeIdentifier : The ISO 639-1 Code language identefier, please note if the passed locale is wrong or not found in the localisation files, we will show the keys instead of the values
     - Parameter secretKey: The secret keys providede to your business from TAP.
     */
let cardDataConfig:TapCardDataConfiguration = .init(sdkMode: .sandbox, localeIdentifier: "en", secretKey: .init(sandbox: "sk_test_yKOxBvwq3oLlcGS6DagZYHM2", production: "sk_live_V4UDhitI0r7sFwHCfNB6xMKp"))
        /**
     Populate the card forum configuration with the required data.
     - Parameter dataConfig: The data configured by you as a merchant (e.g. secret key, locale, etc.). Required
     - Parameter cusomTheme: The theme object which contains the path to the local or to the remote custom light and dark themes. Optional
     - Parameter customLocalisation: The localisation object which contains the path to the local or to the remote custom localisation files. Optional
     - Parameter transactionCurrency: The currency you want to show the card brands that accepts it. Default is KWD
     - Parameter merchantID: The tap merchant id.
     - Parameter customer: Tap customer if any.
     - Parameter onCheckoutRead: A block to execure upon completion
     - Parameter onErrorOccured: A block to execure upon error
     */
        TapCardForumConfiguration.shared.configure(dataConfig: cardDataConfig,customTheme: .init(with: "lightTheme", and: "darkTheme", from: .LocalJsonFile),customLocalisation: .init(with: Bundle.main.url(forResource: "cardlocalisation", withExtension: "json"), from: .LocalJsonFile, shouldFlip: false, localeIdentifier: "en"), transactionCurrency: .SAR) {
            //  All went good, show the UIViewcontroller that has the card kit uiview
        } onErrorOccured: { error in

            // Something is wrong, please need the required action
        }
        
```

# Tokenization

On demand, you can start the tokenzation process.

```swift
/// A storyboard reference to the card view added as indicated before
@IBOutlet weak var mawaridCardView: MawaridCardView!
.
.
.
// Whenever needed start the tokenization process as follows
mawaridCardView.tokenizeCard { [weak self] token in
            // Store the token for further usage
        } onErrorOccured: { [weak self] error, cardFieldsValidity in
            print(error)
            // Something wrong happened. Do the needful logic
        }
```

# MawaridCardDelegate

The pod utilises the protocol scheme to passback callbacks for special events.

```swift
/// A storyboard reference to the card view added as indicated before
@IBOutlet weak var mawaridCardView: MawaridCardView!
.
.
.
// Assign the delegate
mawaridCardView.delegate = self
extension ViewController:MawaridCardDelegate {
    /// Will be fired when the validation status of the form changes. And will let you know if the card form is ready to do be processed or not
    @objc func cardValidationStatusChanged(to:CardKitValidationStatusEnum)
    /// Will be fired once the card form faces any error
    @objc func errorOccured(with error:CardKitErrorType, message:String)
    /**
     Be updated by listening to events fired from the card kit
     - Parameter with event: The event just fired
     */
    @objc func eventHappened(with event:CardKitEventType)
    
    /// Will be fired to indicate whether the user wants to save the card or not
    @objc func saveCardCheckBoxChanged(to:Bool)
}
```

# Theme & Localisation

Please add the following files to the main bundle of the project:

## lightTheme.json

```json
{
    "cardView":{
        "containter":{
            "backgroundColor":"#ffffff"
        },
        "textFields":{
            "textColor":"#000000",
            "font":"Tajawal-Light,14",
            "placeholderColor":"#000000"
        },
        "titleLabel":{
            "textColor":"#000000",
            "font":"Tajawal-Regular,20"
        },
        "saveLabel":{
            "textColor":"#000000",
            "font":"Tajawal-Regular,20"
        },
        "saveCheckBox":{
            "uncheckedIcon":"uncheck",
            "checkedIcon":"check"
        },
        "cardIcon":"card-icon"
    }
}
```

## darkTheme.json

```json
{
    "cardView":{
        "containter":{
            "backgroundColor":"#000000"
        },
        "textFields":{
            "textColor":"#ffffff",
            "font":"Tajawal-Light,14",
            "placeholderColor":"#ffffff99"
        },
        "titleLabel":{
            "textColor":"#ffffff",
            "font":"Tajawal-Regular,20"
        },
        "saveLabel":{
            "textColor":"#ffffff",
            "font":"Tajawal-Regular,20"
        },
        "saveCheckBox":{
            "uncheckedIcon":"uncheck",
            "checkedIcon":"check"
        },
        "cardIcon":"card-icon"
    }
}
```

## cardlocalisation.json

```json
{
    "en":{
        "title":"Mawarid enter the card details",
        "cardNamePlaceholder":"Card holder name",
        "cardNumberPlaceholder":"Card number",
        "cardExpiryPlaceholder":"Card expiry",
        "cardCVVPlaceholder":"CVV",
        "saveCard":"Save card for next transactions",
        "cancel":"Cancel",
        "done":"Done"
    },
    "ar":{
        "title":"من فضلك أدخل بيانات البطاقة",
        "cardNamePlaceholder":"اسم صاحب البطاقة",
        "cardNumberPlaceholder":"رقم البطاقة",
        "cardExpiryPlaceholder":"تاريخ الإنتهاء",
        "cardCVVPlaceholder":"رمز الأمان",
        "saveCard":"حفظ البطاقة للمعاملات القادمة",
        "cancel":"إلغاء",
        "done":"تم"
    }
}
```

# Example project

please download the example project at [GitHub - Tap-Payments/card-mawarid-iOS](https://github.com/Tap-Payments/card-mawarid-iOS)
