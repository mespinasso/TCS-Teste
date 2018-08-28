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
        return true
    }
    
    func isValidPhone() -> Bool {
        return true
    }
}
