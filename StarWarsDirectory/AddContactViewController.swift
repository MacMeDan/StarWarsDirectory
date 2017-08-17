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
    var scrollView  =   UIScrollView()
    var contentView =   UIStackView()
    var activeField:    UITextField?
    var firstNameField: TextField!
    var lastNameField:  TextField!
    var zipField:       TextField!
    var phoneField:     TextField!
    var forceField:     View!
    var birthdayButton: FlatButton!
    var overlay:        View!
    let datePicker =    UIDatePicker()
    
    let forceSwitch =   Switch()
    var forceSensitive: Bool = false
    var birthDate:      String?
    var pictureData:    Data?
    var affiliation:    String?
    var zip:            Int?
    var phoneNumber:    Int?
    var contactImage:   FABButton!
    let saveButton:     FlatButton = FlatButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.frame = view.frame
        view = scrollView
        prepareNavigation()
        prepareFields()
        prepareForceField()
        prepareBirthdayButton()
        prepareView()
        prepareImageSelector()
        prepareSaveButton()
        prepareBirthdayOverlay()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func prepareView() {
        hideKeyboardWhenTappedAround()
        view = StarsOverlay(frame: view.frame)
        contentView = UIStackView(arrangedSubviews: [firstNameField, lastNameField, zipField, phoneField, birthdayButton, forceField])
        contentView.axis = .vertical
        contentView.spacing = 25
        contentView.distribution = .fill
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.layout(contentView).top(180).left(30).right(20)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Keeps the stars form colliding
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 0.0
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Ensures view is visiable when imagePicker is dismissed
        self.view.alpha = 1.0
    }
    
    func prepareNavigation() {
        navigationController?.navigationBar.tintColor = .white
    }
    
    func prepareFields() {
        firstNameField = getStyledTextFeild(placeHolderText: "First Name")
        lastNameField = getStyledTextFeild(placeHolderText: "Last Name")
        prepareZipFeild()
        preparePhoneFeild()
    }
    
    func prepareZipFeild() {
        zipField = getStyledTextFeild(placeHolderText: "Zip")
        zipField.keyboardType = .namePhonePad
        //Give visual feedback on weither or not the input is valid
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: zipField, queue: OperationQueue.main) { (Notification) in
            guard let text = self.zipField.text else { return }
            self.zipField.dividerActiveColor = text.rangeOfCharacter(from: CharacterSet.letters) == nil ? Color.blue.base : Color.red.base
        }
    }
    
    func preparePhoneFeild() {
        phoneField = getStyledTextFeild(placeHolderText: "Phone Number")
        phoneField.keyboardType = .namePhonePad
        //Give visual feedback on weither or not the input is valid
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: phoneField, queue: OperationQueue.main) { (Notification) in
            guard let text = self.phoneField.text else { return }
            self.phoneField.dividerActiveColor = text.rangeOfCharacter(from: CharacterSet.letters) == nil ? Color.blue.base : Color.red.base
            self.phoneField.placeholderActiveColor = text.rangeOfCharacter(from: CharacterSet.letters) == nil ? Color.blue.base : Color.red.base
        }
    }
    
    func formatPhoneNumber(phoneNumber: String?) -> String? {
        if let number = phoneNumber {
            if number.characters.count > 10 || number.characters.count < 6 {
                return number
            }
            
            let areaCode = number.substring(with: number.startIndex..<number.index(number.startIndex, offsetBy: 3))
            let firstThree = number.substring(with: number.index(number.startIndex, offsetBy: 4)..<number.index(number.startIndex, offsetBy: 6))
            let lastFour = number.substring(with: number.index(number.startIndex, offsetBy: 6)..<number.endIndex)
            
            return "(\(areaCode)) \(firstThree)-\(lastFour)"
        }
        return phoneNumber
    }
    
    func prepareForceField() {
        forceField = View(frame: CGRect(x: 0, y: 0, width: view.width, height: 40))
        forceField.backgroundColor = UIColor.clear
        forceSwitch.buttonOnColor = Color.yellow.base
        forceSwitch.trackOnColor = Color.yellow.lighten4
        forceField.layout(forceSwitch).centerVertically().right(10)
        let label = UILabel(frame: .zero)
        label.text = "Force Sensitive"
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        forceField.layout(label).centerVertically().left(10).right(50)
        forceSwitch.addTarget(self, action: #selector(forceSwitchAction), for: .valueChanged)
    }
    
    func forceSwitchAction() {
        forceSensitive = forceSwitch.isOn
    }
    
    func prepareBirthdayButton() {
        birthdayButton = FlatButton(title: "Add Birthday", titleColor: UIColor.white.withAlphaComponent(0.7))
        birthdayButton.backgroundColor = .clear
        birthdayButton.addTarget(self, action: #selector(addBirthdayAction), for: .touchUpInside)
    }
    
    func addBirthdayAction() {
        overlay.isHidden = !overlay.isHidden
    }
    
    func prepareBirthdayOverlay() {
        overlay = View(frame: view.frame)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        overlay.layout(datePicker).center().left(20).right(20)
        datePicker.datePickerMode = .date
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.setDate(Date(timeIntervalSinceNow: -30000), animated: false)
        datePicker.tintColor = .white
        datePicker.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        let saveBirthdayButton = FlatButton(title: "Save Birthday")
        saveBirthdayButton.addTarget(self, action: #selector(saveBirthdayAction), for: .touchUpInside)
        overlay.layout(saveBirthdayButton).right(20).centerVertically(offset: datePicker.height/2)
        saveBirthdayButton.setTitleColor(.white, for: .normal)
        view.layout(overlay).top().bottom().left().right()
        overlay.isHidden = true
    }
    
    func saveBirthdayAction() {
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .short
        birthDate = dateFormater.string(from: datePicker.date)
        birthdayButton.setTitle("Birthdate :  \(dateFormater.string(from: datePicker.date))", for: .normal)
        overlay.isHidden = true
    }
    
    func prepareImageSelector() {
        contactImage = FABButton()
        contactImage.setTitle("Add Image", for: .normal)
        contactImage.titleColor = .white
        contactImage.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        contactImage.addTarget(self, action: #selector(pickPhoto), for: .touchUpInside)
        view.layout(contactImage).centerHorizontally().top(50).width(100).height(100)
        contactImage.clipsToBounds = true
        contactImage.cornerRadius = contactImage.height/2
    }
    
    func getStyledTextFeild(placeHolderText: String) -> TextField {
        let feild = TextField(frame: CGRect(x: 0, y: 0, width: view.width, height: 40))
        feild.dividerNormalColor = Color.grey.lighten2.withAlphaComponent(0.4)
        feild.placeholderNormalColor = Color.white.withAlphaComponent(0.7)
        feild.textColor = .white
        feild.placeholder = placeHolderText
        feild.delegate = self
        feild.translatesAutoresizingMaskIntoConstraints = false
        return feild
    }
    
    func prepareSaveButton() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleColor = Color.yellow.base
        saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        view.layout(saveButton).bottom(20).right(30)
    }
    
    func saveAction() {
        let contact = Contact(firstName: firstNameField.text!, lastName: lastNameField.text!, birthDate: birthDate, forceSensitive: forceSensitive, pictureURL: "", picture: pictureData, affiliation: nil, zip: zip, phoneNumber: phoneNumber)
        
        try? PersistedData.shared?.add(contact: contact)

        navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "newEntry")))
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
 
    // MARK: - Keyboard offset methods
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
            
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            
            var aRect : CGRect = self.view.frame
            aRect.size.height -= keyboardSize.height
            if let activeField = self.activeField {
                if (!aRect.contains(activeField.frame.origin)){
                    self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize.height, 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            self.view.endEditing(true)
            self.scrollView.isScrollEnabled = false
        }
    }
}

extension AddContactViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - ImagePickerControllerDelegate

extension AddContactViewController: UIImagePickerControllerDelegate {
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.takePhotoWithCamera()
        })
        let chooseFromLibraryAction = UIAlertAction(title: "Choose From Library", style: .default, handler: { _ in
            self.choosePhotoFromLibrary()
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(chooseFromLibraryAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func newImgTapped(sender: FABButton) {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if status == AVAuthorizationStatus.denied {
            
            let changeYourSettingsAlert = UIAlertController(title: "You do not have permissions enabled for this.", message: "Would you like to change them in settings?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) -> Void in
                guard let url = URL(string: UIApplicationOpenSettingsURLString) else {return}
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            changeYourSettingsAlert.addAction(okAction)
            changeYourSettingsAlert.addAction(cancelAction)
            presentAlert(sender: changeYourSettingsAlert)
            
        } else {
            let Alert = UIAlertController(title: "Where would you like to get photos from?", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            Alert.popoverPresentationController?.sourceRect = sender.bounds
            Alert.popoverPresentationController?.sourceView = sender
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            imgPicker.allowsEditing = false
            imgPicker.modalPresentationStyle = UIModalPresentationStyle.popover
            imgPicker.popoverPresentationController?.sourceView = sender
            imgPicker.popoverPresentationController?.sourceRect = sender.bounds
            
            presentAlert(sender: Alert)
            
            let camera = UIAlertAction(title: "Take a Photo", style: .default) { (camera) -> Void in
                imgPicker.sourceType = .camera
                self.present(imgPicker, animated: true, completion: nil)
            }
            
            let photoLibrary = UIAlertAction(title: "Choose from Library", style: .default) { (Photolibrary) -> Void in
                imgPicker.sourceType = .photoLibrary
                self.present(imgPicker, animated: true, completion: nil)
            }
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                Alert.addAction(camera)
            }
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                Alert.addAction(photoLibrary)
            }
            
            Alert.addAction(cancelAction)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.contactImage.setImage(image, for: .normal)
            self.pictureData = UIImagePNGRepresentation(image)
        } else{
            assertionFailure("Error with imagePicker")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func presentAlert(sender: UIAlertController) {
        present(sender, animated: false, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

