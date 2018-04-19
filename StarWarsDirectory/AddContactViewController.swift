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
        contentView.dismissKeyboard()
        contentView.overlay.isHidden = !contentView.overlay.isHidden
    }
    
    func bindView() {
        contentView.saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        contentView.birthdayButton.addTarget(self, action: #selector(addBirthdayAction), for: .touchUpInside)
        contentView.contactImage.addTarget(self, action: #selector(pickPhoto), for: .touchUpInside)
        contentView.saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        contentView.birthdayButton.addTarget(self, action: #selector(saveBirthdayAction), for: .touchUpInside)
        
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
                              picture: contentView.pictureData,
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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(contentView.dismissKeyboard))
        contentView.addGestureRecognizer(tap)
    }
    
    
}



// MARK: - ImagePickerControllerDelegate

extension AddContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func pickPhoto() {
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
    
    @objc func saveBirthdayAction() {
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .short
        contentView.birthDate = dateFormater.string(from: contentView.datePicker.date)
        contentView.birthdayButton.setTitle("Birthdate :  \(dateFormater.string(from: contentView.datePicker.date))", for: .normal)
        contentView.overlay.isHidden = true
    }
    
    internal func newImgTapped(sender: FABButton) {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        let status = AVCaptureDevice.authorizationStatus(for: .video)
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
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            contentView.contactImage.setImage(image, for: .normal)
            contentView.pictureData = UIImagePNGRepresentation(image)
        } else{
            assertionFailure("Error with imagePicker")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    internal func presentAlert(sender: UIAlertController) {
        present(sender, animated: false, completion: nil)
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
