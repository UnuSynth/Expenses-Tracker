//
//  AppStorageKeys.swift
//  ExpensesTrackerPackage
//
//  Created by Amantay Abdyshev on 23/6/26.
//

public enum AppStorageKeys: String {
    case languageCode = "selectedLanguageCode"
    case currency = "selectedCurrency"
    
    public var key: String {
        rawValue
    }
}
