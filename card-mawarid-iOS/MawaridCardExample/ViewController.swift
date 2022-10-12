//
//  ViewController.swift
//  MawaridCardExample
//
//  Created by Osama Rabie on 11/10/2022.
//

import UIKit
import TapThemeManager2020
import card_mawarid_iOS

class ViewController: UIViewController {

    @IBOutlet weak var mawaridCardView: MawaridCardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mawaridCardView.presentingViewController = self
    }


}

