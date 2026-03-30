//
//  KeyboardDismissModifier.swift
//  releva
//
//  Created by Matthias König on 01.11.2024.
//

import Foundation
import SwiftUI

struct KeyboardDismissModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(KeyboardDismissalView())
    }
}

struct KeyboardDismissalView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject {
        @objc func dismissKeyboard() {
            UIApplication.shared.endEditing()
        }
    }
}

extension View {
    func hideKeyboardOnTap() -> some View {
        self.modifier(KeyboardDismissModifier())
    }
}
