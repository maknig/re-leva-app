//
//  UIApplication_Extensions.swift
//  releva
//
//  Created by Matthias König on 01.11.2024.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
