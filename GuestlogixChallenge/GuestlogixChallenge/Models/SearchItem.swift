//
//  SearchItem.swift
//  GuestlogixChallenge
//
//  Created by Luiz Fernando Aquino Dias on 23/04/19.
//  Copyright © 2019 Luiz Fernando Aquino Dias. All rights reserved.
//

import Foundation

class SearchItem {
    
    var attributedIATA3Code: NSMutableAttributedString?
    var allAttributedName : NSMutableAttributedString?
    
    var iata3Code: String
    
    public init(iata3Code: String) {
        self.iata3Code = iata3Code
    }
    
    public func getFormatedText() -> NSMutableAttributedString{
        allAttributedName = NSMutableAttributedString()
        allAttributedName!.append(attributedIATA3Code!)
        return allAttributedName!
    }
    
    public func getStringText() -> String{
        return "\(iata3Code)"
    }
    
}
