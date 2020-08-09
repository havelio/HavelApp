//
//  Date.swift
//  HavelApp
//
//  Created by Havelio Henar on 08/08/20.
//  Copyright © 2020 Havelio Henar. All rights reserved.
//

import Foundation

extension Date {
    static func from(string: String, format: String = "dd-MMM-yy") -> Date {
        /*  Convert string to date, convenience method */
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string) ?? Date()
    }

    func toString(format: String = "d-MMM-yy", locale: String = "en_US") -> String {
        /* Convert date instance to string with US locale */
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: locale)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    static func fromTimestamp(_ timestamp: Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(timestamp))
    }
}
