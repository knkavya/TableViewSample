//
//  LocalizationString.swift
//  TableViewSample
//
//  Created by Kavya on 09/05/18.
//  Copyright © 2018 Kavya. All rights reserved.
//

import Foundation

extension String {
    
    static func localizedValueForKey(key : String) -> String {
        let value: String = NSLocalizedString(key, comment: key)
        return value
    }
    
}
