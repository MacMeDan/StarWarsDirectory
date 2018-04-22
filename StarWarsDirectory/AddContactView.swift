//
//  AddContactView.swift
//  StarWarsDirectory
//
//  Created by Dan Leonard on 4/19/18.
//  Copyright © 2018 MacMeDan. All rights reserved.
//

import Foundation
import UIKit
import Material

class AddContactView: UIView {
    
    let mainView:       UIView = UIView()
    var starsOverlay:   StarsOverlay!
    let scrollView:     UIScrollView = UIScrollView()
    var mainStackView:  UIStackView = UIStackView()
    var activeField:    UITextField?
    var firstNameField: TextField = TextField()
    var lastNameField:  TextField = TextField()
    var zipField:       TextField = TextField()
    var phoneField:     TextField = TextField()
    let forceField:     View = View(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
    let theme = Theme()
    let birthdayButton: FlatButton = FlatButton(title: "Add Birthday", titleColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).withAlphaComponent(0.7))
    let forceSwitch =   Switch()
    var forceSensitive: Bool = false
    var birthDate:      String?
    var affiliation:    String?
    var pictureData:    Data?
    let saveButton:     FlatButton = FlatButton()
    
    convenience init() {
        self.init(frame: .zero)
        prepareView()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private extension making all functions contained within are private as well.
private extension AddContactView {
    
    func prepareView() {
        addSubview(mainView)
        layout(mainView).edges()
        scrollView.frame = self.frame
        mainView.addSubview(scrollView)
        prepareFields()
        prepareForceField()
        prepareBirthdayButton()
        prepareSaveButton()
        starsOverlay = StarsOverlay(frame: mainView.frame)
        mainView.addSubview(starsOverlay)
        mainView.layout(starsOverlay).edges()
        prepareMainStack()
    }
    
    func prepareMainStack() {
        mainStackView = UIStackView(arrangedSubviews: [firstNameField, lastNameField, zipField, phoneField, birthdayButton, forceField])
        mainStackView.axis = .vertical
        mainStackView.spacing = 25
        mainStackView.distribution = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainView.layout(mainStackView).top(180).left(30).right(20)
    }
    
    func prepareForceField() {
        forceField.backgroundColor = UIColor.clear
        forceSwitch.buttonOnColor = theme.primary
        forceSwitch.trackOnColor = Color.yellow.lighten4
        forceField.layout(forceSwitch).centerVertically().right(10)
        let label = UILabel()
        label.text = "Force Sensitive"
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        forceField.layout(label).centerVertically().left(10).right(50).height(20)
        forceSwitch.addTarget(self, action: #selector(forceSwitchAction), for: .valueChanged)
    }
    
    @objc func forceSwitchAction() {
        forceSensitive = forceSwitch.isOn
    }
    
    func prepareBirthdayButton() {
        birthdayButton.backgroundColor = .clear
    }
    
    func getStyledTextField(placeHolderText: String) -> TextField {
        let field = TextField(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
        field.dividerNormalColor = Color.grey.lighten2.withAlphaComponent(0.4)
        field.placeholderNormalColor = theme.secondary.withAlphaComponent(0.7)
        field.textColor = theme.secondary
        field.placeholder = placeHolderText
        field.delegate = self
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }
    
    func prepareSaveButton() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(theme.nutralLight, for: .disabled)
        saveButton.setTitleColor(theme.primary, for: .normal)
        self.saveButton.isEnabled = false
        mainView.layout(saveButton).bottom(20).right(30)
    }
    
    func prepareFields() {
        prepareFirstNameField()
        lastNameField = getStyledTextField(placeHolderText: "Last Name")
        prepareZipField()
        preparePhoneField()
    }
    
    func prepareFirstNameField() {
        firstNameField = getStyledTextField(placeHolderText: "First Name")
        NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: firstNameField, queue: .main) { (Notification) in
            guard let text = self.firstNameField.text else { return }
            self.saveButton.isEnabled = text.count > 0
        }
    }
    
    func prepareZipField() {
        zipField = getStyledTextField(placeHolderText: "Zip")
        zipField.keyboardType = .numberPad
        // Give visual feedback on weither or not the input is valid
        NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: zipField, queue: .main) { (Notification) in
            guard let text = self.zipField.text else { return }
            self.zipField.dividerActiveColor = text.rangeOfCharacter(from: .decimalDigits) != nil ? #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1) : #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
    }
    
    func preparePhoneField() {
        phoneField = getStyledTextField(placeHolderText: "Phone Number")
        phoneField.keyboardType = .numberPad
        // Give visual feedback on weither or not the input is valid
        NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: phoneField, queue: .main) { (Notification) in
            guard let text = self.phoneField.text else { return }
            self.phoneField.dividerActiveColor = text.rangeOfCharacter(from: .decimalDigits) != nil ? #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1) : #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            self.phoneField.placeholderActiveColor = text.rangeOfCharacter(from: .decimalDigits) != nil ? #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1) : #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
    }
    
}

extension AddContactView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
}
