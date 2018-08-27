//
//  ViewController.swift
//  TCS-Teste
//
//  Created by Matheus Coelho Espinasso on 26/08/18.
//  Copyright © 2018 Matheus Coelho Espinasso. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    var fieldset:[(field: RegistrationForm, fieldComponent: UIView)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRegistrationFormFields()
    }
    
    func loadRegistrationFormFields() {
        RegistrationForm.fetchFromServer { (regFormfields) in
            DispatchQueue.main.async {
                
                if let regFormFields = regFormfields {
                    // If there's no previous, the main view is the baseline
                    var previousField: UIView = self.view
                    
                    for field in regFormFields {
                        var heightOffset: CGFloat = 30
                        
                        if (!previousField.isEqual(self.view)) {
                            heightOffset = previousField.bounds.height
                        }
                        
                        let fieldComp = self.createUIElement(for: field, constraintBaseline: previousField)
                        fieldComp.isHidden = field.hidden
                        
                        self.view.addSubview(fieldComp)
                        fieldComp.translatesAutoresizingMaskIntoConstraints = false
                        
                        if (field.type == .checkbox) {
                            let label = UILabel()
                            label.text = field.message
                            
                            self.view.addSubview(label)
                            label.translatesAutoresizingMaskIntoConstraints = false
                            
                            label.topAnchor.constraint(equalTo: previousField.topAnchor, constant: CGFloat(field.topSpacing) + heightOffset).isActive = true
                            label.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
                            
                            fieldComp.topAnchor.constraint(equalTo: previousField.topAnchor, constant: CGFloat(field.topSpacing) + heightOffset).isActive = true
                            fieldComp.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 16).isActive = true
                            fieldComp.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
                            
                            
                        } else {
                            fieldComp.bounds.size.width = self.view.bounds.size.width - 32
                            fieldComp.bounds.size.height = 30
                            fieldComp.topAnchor.constraint(equalTo: previousField.topAnchor, constant: CGFloat(field.topSpacing) + heightOffset).isActive = true
                            fieldComp.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
                            fieldComp.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
                        }
                        
                        self.fieldset.append((field: field, fieldComponent: fieldComp))
                        previousField = fieldComp
                    }
                }
            }
        }
    }
    
    // Switch value changed
    @objc func switchValueDidChange(_ sender: UISwitch) {
        for fieldTuple in fieldset {
            if let foundSwitch = fieldTuple.fieldComponent as? UISwitch {
                if (foundSwitch.isEqual(sender)) {
                    
                    // Checks if the switch is related to the visibility of another field
                    if let fieldId = fieldTuple.field.show {
                        showField(withId: fieldId, sender.isOn)
                    }
                }
            }
        }
    }
    
    // Changes field visibility according to its' ID
    func showField(withId id: Int, _ show: Bool) {
        for fieldTuple in fieldset {
            if fieldTuple.field.id == id {
                fieldTuple.fieldComponent.isHidden = !show
            }
        }
    }
    
    func createUIElement(for field: RegistrationForm, constraintBaseline: UIView) -> UIView {
        let fieldComp: UIView
        
        switch field.type {
        case .field:
            
            let textField = UITextField()
            textField.borderStyle = .roundedRect
            textField.placeholder = field.message
            
            if let typeField = field.typefield {
                switch(typeField) {
                case .telNumber:
                    textField.textContentType = .telephoneNumber
                    textField.keyboardType = .phonePad
                    
                    break
                case .email:
                    textField.textContentType = .emailAddress
                    textField.keyboardType = .emailAddress
                    
                    break
                case .text:
                    textField.keyboardType = .default
                    
                    break
                }
            }
            
            fieldComp = textField
            
            break
        case .text:
            
            let label = UILabel()
            label.text = field.message
            
            fieldComp = label
            
            break
        case .image:
            
            let imageView = UIImageView()
            
            fieldComp = imageView
            
            break
        case .checkbox:
            
            let valueSwitch = UISwitch()
            valueSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
            
            
            
            fieldComp = valueSwitch
            
            break
        case .send:
            
            let button = UIButton()
            button.setTitle(field.message, for: .normal)
            button.backgroundColor = UIColor.blue
            
            fieldComp = button
            
            break
        }
        
        return fieldComp
    }
}

