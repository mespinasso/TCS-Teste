//
//  String+Validations.swift
//  TCS-Teste
//
//  Created by Matheus Coelho Espinasso on 27/08/18.
//  Copyright © 2018 Matheus Coelho Espinasso. All rights reserved.
//

import Foundation

extension String {
    
    func isValidText() -> Bool {
        return self.count > 0
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)

        return emailTest.evaluate(with: self)
    }
    
    func isValidPhone() -> Bool {
        return true
    }
}
