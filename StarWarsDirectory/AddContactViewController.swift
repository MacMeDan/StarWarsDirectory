//
//  AddContactViewController.swift
//  StarWarsDirectory
//
//  Created by Dan Leonard on 8/10/17.
//  Copyright © 2017 MacMeDan. All rights reserved.
//

import UIKit
import Material
import AVFoundation

class AddContactViewController: UIViewController {
    var contentView: AddContactView = AddContactView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        prepareNavigation()
        bindView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Keeps the stars form colliding
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 0.0
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Ensures view is visiable when imagePicker is dismissed
        self.view.alpha = 1.0
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    private func prepareNavigation() {
        navigationController?.navigationBar.tintColor = .white
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @objc func addBirthdayAction() {
        contentView.overlay.isHidden = !contentView.overlay.isHidden
    }
    
    func bindView() {
        contentView.saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        contentView.birthdayButton.addTarget(self, action: #selector(addBirthdayAction), for: .touchUpInside)
        contentView.saveBirthdayButton.addTarget(self, action: #selector(saveBirthdayAction), for: .touchUpInside)
    }
 
    // MARK: - Keyboard offset methods
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
            
            contentView.scrollView.contentInset = contentInsets
            contentView.scrollView.scrollIndicatorInsets = contentInsets
            
            var aRect : CGRect = self.view.frame
            aRect.size.height -= keyboardSize.height
            if let activeField = contentView.activeField {
                if (!aRect.contains(activeField.frame.origin)){
                    contentView.scrollView.scrollRectToVisible(activeField.frame, animated: true)
                }
            }
        }
    }
    
    @objc func saveAction() {
        let phoneNumber = contentView.phoneField.text == "" ? nil : formatPhoneNumber(phoneNumber: contentView.phoneField.text)
        let zip = contentView.zipField.text == "" ? nil : contentView.zipField.text
        let contact = Contact(firstName: contentView.firstNameField.text!,
                              lastName: contentView.lastNameField.text!,
                              birthDate: contentView.birthDate,
                              forceSensitive: contentView.forceSensitive,
                              pictureURL: "",
                              zip: zip,
                              phoneNumber: phoneNumber)
        
        try? PersistedData.shared?.add(contact: contact)
        
        navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "newEntry")))
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize.height, 0.0)
            contentView.scrollView.contentInset = contentInsets
            contentView.scrollView.scrollIndicatorInsets = contentInsets
            view.endEditing(true)
            contentView.scrollView.isScrollEnabled = false
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        contentView.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func saveBirthdayAction() {
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .short
        contentView.birthDate = dateFormater.string(from: contentView.datePicker.date)
        contentView.birthdayButton.setTitle("Birthdate :  \(dateFormater.string(from: contentView.datePicker.date))", for: .normal)
        contentView.overlay.isHidden = true
    }
    
    func formatPhoneNumber(phoneNumber: String?) -> String? {
        if let number = phoneNumber {
            if number.count > 10 || number.count < 6 {
                return number
            }
            
            let areaCode = number[number.startIndex...number.index(number.startIndex, offsetBy: 4)]
            let firstThree = number[number.index(number.startIndex, offsetBy: 4)...number.index(number.startIndex, offsetBy: 6)]
            let lastFour = number[number.index(number.startIndex, offsetBy: 6)...]
            
            return "(\(areaCode)) \(firstThree)-\(lastFour)"
        }
        return phoneNumber
    }
}
