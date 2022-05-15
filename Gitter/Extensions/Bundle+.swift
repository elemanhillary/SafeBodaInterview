//
//  Bundle+.swift
//  Gitter
//
//  Created by MacBook Pro on 5/15/22.
//

import Foundation

extension Bundle {
    /// Name of the app - title under the icon.
    var displayName: String? {
            return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
                object(forInfoDictionaryKey: "CFBundleName") as? String
    }
}
