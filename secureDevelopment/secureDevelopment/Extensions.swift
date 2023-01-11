//
//  Extensions.swift
//  secureDevelopment
//
//  Created by Antonio Jesús on 12/10/22.
//

import Foundation
import UIKit

extension String {
    
    var clear:String {
        let okeyChars:Set<Character> = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_©#")
        return self.filter { okeyChars.contains ($0) }
    }
    
    var urlEncoded: String {
        let customAllowedSet = CharacterSet(charactersIn: "abcdefghijkImnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-.~")
        return self.addingPercentEncoding (withAllowedCharacters: customAllowedSet)!
    }
}

extension UIImage {
    func resize(newWith: CGFloat) -> UIImage? {
        
        let scale = newWith / size.width
        let newHeight = size.height * scale
        let newSize = CGSize(width: newWith, height: newHeight)
        
        UIGraphicsBeginImageContext(newSize)
        draw(in: CGRect(origin: .zero, size: newSize) )
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
