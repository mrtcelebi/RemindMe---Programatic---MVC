//
//  AddViewController.swift
//  RemindMe
//
//  Created by Catalina on 20.08.2020.
//  Copyright © 2020 Catalina. All rights reserved.
//

import UIKit
import TinyConstraints

class AddViewController: UIViewController {

    private let titleTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter title..."
        field.borderStyle = .roundedRect
        return field
    }()
    
    private let bodyTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter body..."
        field.borderStyle = .roundedRect
        return field
    }()
    
    private var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        return picker
    }()
    
    var completion: ((String, String, Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        titleTextField.delegate = self
        bodyTextField.delegate = self
        setupLayout()
        setupSaveBtn()
    }
    
    private func setupSaveBtn() {
        let saveBtn = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(savePressed))
        navigationItem.rightBarButtonItem = saveBtn
    }

    @objc private func savePressed() {
         if let titleText = titleTextField.text, !titleText.isEmpty,
            let bodyText = bodyTextField.text, !bodyText.isEmpty {
            let targetDate = datePicker.date
            completion?(titleText, bodyText, targetDate)
        }
    }
    
    private func setupLayout() {
        view.addSubview(titleTextField)
        titleTextField.topToSuperview(usingSafeArea: true).constant = 20
        titleTextField.leadingToSuperview().constant = 20
        titleTextField.trailingToSuperview().constant = -20
        titleTextField.height(40)
        
        view.addSubview(bodyTextField)
        bodyTextField.topToBottom(of: titleTextField).constant = 15
        bodyTextField.leadingToSuperview().constant = 20
        bodyTextField.trailingToSuperview().constant = -20
        bodyTextField.height(40)
        
        view.addSubview(datePicker)
        datePicker.topToBottom(of: bodyTextField).constant = 15
        datePicker.leadingToSuperview().constant = 20
        datePicker.trailingToSuperview().constant = -20
        datePicker.bottomToSuperview().constant = -20
    }    
}

extension AddViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
