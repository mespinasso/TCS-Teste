//
//  RegistrationFormModel.swift
//  TCS-Teste
//
//  Created by Matheus Coelho Espinasso on 26/08/18.
//  Copyright © 2018 Matheus Coelho Espinasso. All rights reserved.
//

import Foundation

class FormField {
    let id: Int
    let type: Type
    let message: String
    let typefield: TypeField? // Uma das entradas do JSON, em vez de trazer o ID do tipo, traz o nome
    let hidden: Bool
    let topSpacing: Int
    let show: Int?
    let required: Bool
    
    required init(dictionary: [String : Any]) {
        id = dictionary[FieldKeys.id] as! Int
        message = dictionary[FieldKeys.message] as! String
        hidden = dictionary[FieldKeys.hidden] as! Bool
        topSpacing = dictionary[FieldKeys.topSpacing] as! Int
        show = dictionary[FieldKeys.show] as? Int
        required = dictionary[FieldKeys.required] as! Bool
        
        type = Type(rawValue: dictionary[FieldKeys.type] as! Int)!
        
        if let typefieldString = dictionary[FieldKeys.typefield] as? String {
            typefield = TypeField(rawValue: typefieldString)
        } else if let typefieldInt = dictionary[FieldKeys.typefield] as? Int {
            typefield = TypeField(rawValue: "\(typefieldInt)")
        } else {
            typefield = nil
        }
    }
    
    // JSON field names
    struct FieldKeys {
        static let id = "id"
        static let type = "type"
        static let message = "message"
        static let typefield = "typefield"
        static let hidden = "hidden"
        static let topSpacing = "topSpacing"
        static let show = "show"
        static let required = "required"
    }
}

enum Type: Int {
    case field = 1, text = 2, image = 3, checkbox = 4, send = 5
}

// Uma das entradas do JSON, em vez de trazer o ID do tipo, traz o nome
enum TypeField: String {
    case text = "1", telNumber = "telnumber", email = "3"
}

// Server API fetching
extension FormField {
    
    static let apiEndpoint = "cells.json"
    
    static func fetchFromServer(completion: @escaping ([FormField]?) -> Void) {
        let service = ServerAPIService(apiEndpoint: apiEndpoint)
        service.get { (jsonDictionary) in
            
            if let jsonDictionary = jsonDictionary {
                if let regFormArrayDic = jsonDictionary["cells"] as? [[String : Any]] {
                    
                    var registrationFormArray: [FormField] = []
                    for entry in regFormArrayDic {
                        registrationFormArray.append(FormField(dictionary: entry))
                    }
                    
                    completion(registrationFormArray)
                }
            }
        }
    }
}

// Form fields validation
extension FormField {
    
    static func validateField(formField: FormField, fieldContent: String?) -> Bool {
        
        guard formField.type == .field else {
            return true
        }
        
        if let typeField = formField.typefield, let fieldContent = fieldContent {
            switch typeField {
            case .telNumber:
                return fieldContent.isValidPhone()
            case .email:
                return fieldContent.isValidEmail()
            case .text:
                return fieldContent.isValidText()
            }
        }
        
        return false
    }
}
