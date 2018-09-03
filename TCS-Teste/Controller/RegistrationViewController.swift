//
//  ViewController.swift
//  TCS-Teste
//
//  Created by Matheus Coelho Espinasso on 26/08/18.
//  Copyright © 2018 Matheus Coelho Espinasso. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    var activityIndicator = UIActivityIndicatorView()
    var fieldset:[(field: FormField, fieldComponent: UIView, enableValidation: Bool)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareActivityIndicator(activityIndicator: activityIndicator)
        loadRegistrationFormFields()
    }
    
    // MARK: - Fetching data
    
    func loadRegistrationFormFields() {
        activityIndicator.startAnimating()
        
        FormField.fetchFromServer { (regFormfields) in
            DispatchQueue.main.async {
                
                if let regFormFields = regFormfields {
                    for field in regFormFields {
                        let fieldComp = self.createUIElement(for: field)
                        fieldComp.isHidden = field.hidden
                        
                        self.view.addSubview(fieldComp)
                        fieldComp.translatesAutoresizingMaskIntoConstraints = false
                        
                        self.fieldset.append((field: field, fieldComponent: fieldComp, enableValidation: !field.hidden))
                    }
                    
                    self.validateFormFields()
                    self.setLayoutConstraints()
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    // MARK: - Events
    
    @objc func sendAction(_ sender:UIButton!) {
        let storyboard = self.storyboard
        
        guard let successViewController = storyboard?.instantiateViewController(withIdentifier: "RegistrationSuccessViewController") as? RegistrationSuccessViewController else {
            return
        }
        
        self.navigationController?.pushViewController(successViewController, animated: true)
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch) {
        for fieldTuple in fieldset {
            if let foundSwitch = fieldTuple.fieldComponent as? UISwitch {
                if (foundSwitch.isEqual(sender)) {
                    
                    // Checks if the switch is related to the visibility of another field
                    if let fieldId = fieldTuple.field.show {
                        showField(withId: fieldId, sender.isOn)
                        validateFormFields()
                    }
                }
            }
        }
        
        validateFormFields()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        validateFormFields()
    }
    
    // Changes field visibility according to its' ID
    func showField(withId id: Int, _ show: Bool) {
        fieldset[0].enableValidation = true
        
        for (index, fieldTuple) in fieldset.enumerated() {
            if fieldTuple.field.id == id {
                fieldTuple.fieldComponent.isHidden = !show
                fieldset[index].enableValidation = show
                setLayoutConstraints()
            }
        }
    }
    
    // MARK: - Validation
    
    func validateFormFields() {
        var isValid = true
        
        for fieldTuple in fieldset {
            if fieldTuple.field.type == .field && fieldTuple.enableValidation {
                let textField = fieldTuple.fieldComponent as! UITextField
                
                isValid = isValid && FormField.validateField(formField: fieldTuple.field, fieldContent: textField.text)
            }
        }
        
        enableSendButton(enable: isValid)
    }
    
    func enableSendButton(enable: Bool) {
        for fieldTuple in fieldset {
            if fieldTuple.field.type == .send {
                let button = fieldTuple.fieldComponent as! UIButton
                
                if enable {
                    button.backgroundColor = UIColor.blue
                    button.tintColor = UIColor.white
                    button.isEnabled = true
                } else {
                    button.backgroundColor = UIColor.lightGray
                    button.tintColor = UIColor.gray
                    button.isEnabled = false
                }
                
            }
        }
    }
    
    // MARK: - Setting layout constraints
    
    func createUIElement(for field: FormField) -> UIView {
        let fieldComp: UIView
        
        switch field.type {
        case .field:
            
            let textField = UITextField()
            textField.borderStyle = .roundedRect
            textField.placeholder = field.message
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            
            if let typeField = field.typefield {
                switch(typeField) {
                case .telNumber:
                    textField.textContentType = .telephoneNumber
                    textField.keyboardType = .phonePad
                    
                    break
                case .email:
                    textField.textContentType = .emailAddress
                    textField.keyboardType = .emailAddress
                    textField.autocorrectionType = .no
                    textField.spellCheckingType = .no
                    
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
            button.addTarget(self, action: #selector(self.sendAction(_:)), for: .touchUpInside)
            
            fieldComp = button
            
            break
        }
        
        return fieldComp
    }
    
    // Configures layout constraints for every field fectched from the server
    func setLayoutConstraints() {
        // If there's no previous, the main view is the baseline for constraints
        var previousField: UIView = self.view
        
        for fieldTuple in fieldset {
            var heightOffset: CGFloat = 25
            let field = fieldTuple.field
            let fieldComponent = fieldTuple.fieldComponent
            
            fieldComponent.removeFromSuperview()
            self.view.addSubview(fieldComponent)
            
            if (!previousField.isEqual(self.view)) {
                heightOffset = previousField.bounds.height
            }
            
            if (field.type == .checkbox) {
                let switchLabel = UILabel()
                switchLabel.text = field.message
                
                self.view.addSubview(switchLabel)
                switchLabel.translatesAutoresizingMaskIntoConstraints = false
                
                switchLabel.topAnchor.constraint(equalTo: previousField.topAnchor, constant: CGFloat(field.topSpacing) + heightOffset).isActive = true
                switchLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
                
                fieldComponent.topAnchor.constraint(equalTo: previousField.topAnchor, constant: CGFloat(field.topSpacing) + heightOffset).isActive = true
                fieldComponent.leftAnchor.constraint(equalTo: switchLabel.rightAnchor, constant: 16).isActive = true
                fieldComponent.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
                
            } else {
                fieldComponent.bounds.size.width = self.view.bounds.size.width - 32
                fieldComponent.bounds.size.height = 30
                fieldComponent.topAnchor.constraint(equalTo: previousField.topAnchor, constant: CGFloat(field.topSpacing) + heightOffset).isActive = true
                fieldComponent.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
                fieldComponent.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
            }
            
            if !fieldComponent.isHidden {
                previousField = fieldComponent
            }
        }
    }
}

