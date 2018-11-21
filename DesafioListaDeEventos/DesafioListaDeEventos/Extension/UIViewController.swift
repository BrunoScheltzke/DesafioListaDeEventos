//
//  UIViewController.swift
//  DesafioListaDeEventos
//
//  Created by Bruno Fontenele Scheltzke on 21/11/18.
//  Copyright © 2018 Bruno Fontenele Scheltzke. All rights reserved.
//

import UIKit

extension UIViewController {
    func present(message: String) {
        let alert = UIAlertController(title: "Desafio Lista de Eventos", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func present(error: Error) {
        present(message: error.localizedDescription)
    }
    
    func addHideKeyboardOnTouch() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
