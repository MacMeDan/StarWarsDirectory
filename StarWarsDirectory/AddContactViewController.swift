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
   
    var contentView =   UIStackView()
    var firstNameField: TextField!
    var lastNameField:  TextField!
    var zipField:       TextField!
    var phoneField:     TextField!
    var birthDate:      String?
    var forceSensitive: Bool = false
    var pictureData:    Data?
    var affiliation:    String?
    var zip:            Int?
    var phoneNumber:    Int?
    var contactImage:   FABButton!
    let saveButton:     FlatButton = FlatButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigation()
        prepareFeilds()
        prepareSaveButton()
        prepareImageSelector()
        prepareView()
    }

    func prepareView() {
        view = StarsOverlay(frame: view.frame)
        contentView = UIStackView(arrangedSubviews: [firstNameField, lastNameField, zipField, phoneField])
        contentView.axis = .vertical
        contentView.spacing = 25
        contentView.distribution = .fill
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.layout(contentView).top(160).left(30).right(20)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Keeps the stars form colliding
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 0.0
        })
    }
    
    func prepareNavigation() {
        navigationController?.navigationBar.tintColor = .white
    }
    
    func prepareFeilds() {
        firstNameField = getStyledTextFeild(placeHolderText: "First Name", required: true)
        lastNameField = getStyledTextFeild(placeHolderText: "Last Name", required: true)
        zipField = getStyledTextFeild(placeHolderText: "Zip")
        phoneField = getStyledTextFeild(placeHolderText: "Phone Number")
        
    }
    
    func prepareImageSelector() {
        contactImage = FABButton(title: "Add Photo")
        contactImage.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        contactImage.addTarget(self, action: #selector(pickPhoto), for: .touchUpInside)
        contactImage.translatesAutoresizingMaskIntoConstraints = false
        view.layout(contactImage).top(70).center().height(100).width(100)
    }
    
    func getStyledTextFeild(placeHolderText: String, required: Bool = false) -> TextField {
        let feild = TextField(frame: CGRect(x: 0, y: 0, width: view.width, height: 40))
        feild.dividerNormalColor = Color.grey.lighten2.withAlphaComponent(0.4)
        feild.textColor = .white
        feild.placeholderLabel.textColor = Color.white.withAlphaComponent(0.7)
        feild.placeholder = placeHolderText
        if required {
            feild.detail = "Required"
        }
        feild.translatesAutoresizingMaskIntoConstraints = false
        return feild
    }
    
    func prepareSaveButton() {
        saveButton.setTitle("Save", for: .normal)
        view.layout(saveButton).bottom(20).right(20)
    }
    
    func saveAction() {
        let contact = Contact(firstName: firstNameField.text!, lastName: lastNameField.text!, birthDate: birthDate, forceSensitive: forceSensitive, pictureURL: "", picture: pictureData, affiliation: affiliation, zip: zip, phoneNumber: phoneNumber)
        
        try? PersistedData.shared?.add(contact: contact)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let data = info[UIImagePickerControllerEditedImage] as? Data { pictureData = data }
        if let cImage = info[UIImagePickerControllerEditedImage] as? UIImage { contactImage.setImage(cImage, for: .normal) }
        dismiss(animated: true, completion: nil)
    }
    
}

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
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func newImgTapped(sender: UIButton) {
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
            
            imgPicker.allowsEditing = true
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
    
    func presentAlert(sender: UIAlertController) {
        present(sender, animated: false, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
