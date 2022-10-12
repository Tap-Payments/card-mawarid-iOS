//
//  Extensions.swift
//  card-mawarid-iOS
//
//  Created by Osama Rabie on 11/10/2022.
//

import Foundation
import UIKit
import LocalisationManagerKit_iOS

internal extension UIView {
    /**
     Load a XIB file into a UIView
     - Parameter bundle: The bundle to load the XIB from, default is the XIB containing the UIView
     - Parameter identefier: The name of the XIB, default is the name of the UIView
     - Parameter addAsSubView: Indicates whether the method should add the loaded XIB into the UIView, default is true
     */
    func setupXIB(from bundle:Bundle? = nil, with identefier: String? = nil, then addAsSubView:Bool = true) -> UIView {
        
        // Whether we use the passed bundle if any, or by default we use the bundle that contains the caller UIView
        let bundle = bundle ?? Bundle(for: Self.self)
        // Whether we use the passed identefier if any, or by default we use the default identefier for self
        let identefier = identefier ??  String(describing: type(of: self))
        
        // Load the XIB file
        guard let nibs = bundle.loadNibNamed(identefier, owner: self, options: nil),
              nibs.count > 0, let loadedView:UIView = nibs[0] as? UIView else { fatalError("Couldn't load Xib \(identefier)") }
        
        let newContainerView = loadedView
        
        //Set the bounds for the container view
        newContainerView.frame = bounds
        newContainerView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        // Check if needed to add it as subview
        if addAsSubView {
            addSubview(newContainerView)
        }
        newContainerView.semanticContentAttribute = TapLocalisationManager.shared.localisationLocale == "ar" ? .forceRightToLeft : .forceLeftToRight
        return newContainerView
    }
}


internal extension Bundle {
    static var current: Bundle {
        class __ { }
        return Bundle(for: __.self)
    }
}



internal extension String {
    /**
     Returns all the charachters that are only digits
     - Returns: A string that has only digits from the provided string
     */
    func onlyDigits() -> String {
        return self.filter { "0123456789".contains($0) }
    }
    
    /**
     Returns all the charachters that are only digits and spaces
     - Returns: A string that has only digits and spaces from the provided string
     */
    func digitsWithSpaces() -> String {
        return self.filter { "0123456789 ".contains($0) }
    }
    
    /**
     Returns all the charachters that are only alphabet
     - Returns: A lowercase string that has only alphabet from the provided string
     */
    func alphabetOnly() -> String {
        return self.lowercased().filter { "abcdefghijklmnopqrstuvwxyz ".contains($0) }
    }
    
    /**
     Returns a formatted credit card number with the spaces in the correct palces
     - Parameter spaces: List of indices where you want to put the spaces in
     - Returns: Formatted string where a space is added at the provided indices
     */
    func cardFormat(with spaces:[Int]) -> String {
        // Create a regexx template that will decide where to put the spaces afterwards
        let regex: NSRegularExpression
        
        do {
            var pattern = ""
            var first = true
            for group in spaces {
                // For every spacing index, we will create a regex pattern of DIGTS with the length of the index provided
                pattern += "(\\d{1,\(group)})"
                if !first {
                    pattern += "?"
                }
                first = false
            }
            regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options())
        } catch {
            fatalError("Error when creating regular expression: \(error)")
        }
        
        return NSArray(array: self.onlyDigits().split(with: regex)).componentsJoined(by: " ")
    }
    
    private func split(with regex: NSRegularExpression) -> [String] {
        let matches = regex.matches(in: self, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, self.count))
        var result = [String]()
        
        matches.forEach {
            for i in 1..<$0.numberOfRanges {
                let range = $0.range(at: i)
                
                if range.length > 0 {
                    result.append(NSString(string: self).substring(with: range))
                }
            }
        }
        
        return result
    }
    
}
