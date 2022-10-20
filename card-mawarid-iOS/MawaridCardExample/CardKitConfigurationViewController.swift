//
//  CardKitConfigurationViewController.swift
//  MawaridCardExample
//
//  Created by Osama Rabie on 12/10/2022.
//

import UIKit
import card_mawarid_iOS
import BottomSheet
class CardKitConfigurationViewController: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureSDK()
    }
    
    
    private func configureSDK() {
        loadingIndicator.isHidden = false
        // Override point for customization after application launch.
        let cardDataConfig:TapCardDataConfiguration = .init(sdkMode: .sandbox, localeIdentifier: "en", secretKey: .init(sandbox: "sk_test_yKOxBvwq3oLlcGS6DagZYHM2", production: "sk_live_V4UDhitI0r7sFwHCfNB6xMKp"))
        
        TapCardForumConfiguration.shared.configure(dataConfig: cardDataConfig,customTheme: .init(with: "lightTheme", and: "darkTheme", from: .LocalJsonFile),customLocalisation: .init(with: Bundle.main.url(forResource: "cardlocalisation", withExtension: "json"), from: .LocalJsonFile, shouldFlip: false, localeIdentifier: "en"), transactionCurrency: .SAR) {
            DispatchQueue.main.async { [weak self] in
                self?.loadingIndicator.isHidden = true
                
                let viewController:ViewController = self?.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                
                self?.presentBottomSheetInsideNavigationController(
                    viewController: viewController,
                    configuration: .default
                )
            }
        } onErrorOccured: { error in
            DispatchQueue.main.async { [weak self] in
                let uiAlertController:UIAlertController = .init(title: "Error from middleware", message: error?.localizedDescription ?? "", preferredStyle: .actionSheet)
                let uiAlertAction:UIAlertAction = .init(title: "Retry", style: .destructive) { _ in
                    self?.configureSDK()
                }
                uiAlertController.addAction(uiAlertAction)
                self?.present(uiAlertController, animated: true)
            }
        }
        
    }
    
    
}

