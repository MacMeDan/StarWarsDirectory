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
    var birthdayOverlay: BirthdayOverlay!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareBirthdayOverlay()
        hideKeyboardWhenTappedAround()
        prepareNavigation()
        bindView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        birthdayOverlay.isHidden = !birthdayOverlay.isHidden
    }
    
    func prepareBirthdayOverlay() {
        birthdayOverlay = BirthdayOverlay(frame: view.frame)
        view.layout(birthdayOverlay).edges()
    }
    
    func bindView() {
        contentView.saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        contentView.birthdayButton.addTarget(self, action: #selector(addBirthdayAction), for: .touchUpInside)
        contentView.contactImage.addTarget(self, action: #selector(newImgTapped), for: .touchUpInside)
        birthdayOverlay.saveBirthdayButton.addTarget(self, action: #selector(saveBirthdayAction), for: .touchUpInside)
        
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
        let rawNumber = contentView.phoneField.text ?? ""
        let phoneNumber = Format.PhoneNumber.phoneNumberString(for: rawNumber)
        let zip = contentView.zipField.text == "" ? nil : contentView.zipField.text
        let contact = Contact(firstName: contentView.firstNameField.text!,
                              lastName: contentView.lastNameField.text!,
                              birthDate: contentView.birthDate,
                              forceSensitive: contentView.forceSensitive,
                              pictureURL: "",
                              zip: zip,
                              phoneNumber: phoneNumber)
        
        do {
            try PersistedData.shared?.add(contact: contact)
        } catch {
            Log.error(error, logs: [.views])
        }
        
        navigationController?.popViewController(animated: true)
       
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
        contentView.birthDate = dateFormater.string(from: birthdayOverlay.datePicker.date)
        contentView.birthdayButton.setTitle("Birthdate :  \(dateFormater.string(from: birthdayOverlay.datePicker.date))", for: .normal)
        birthdayOverlay.isHidden = true
    }
    
}

extension AddContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// - Tag: ImagePicker
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    @objc func showPhotoMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let takePhotoAction = UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.takePhotoWithCamera()
        })
        let chooseFromLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
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
    
    @objc func newImgTapped() {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if status == AVAuthorizationStatus.denied {
            
            let changeSetting = UIAlertController(title: "Update Settings", message: "You will need to change this in setting in order to proceed", preferredStyle: .alert)
            changeSetting.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (UIAlertAction) -> Void in
                guard let url = URL(string: UIApplicationOpenSettingsURLString) else {return}
                UIApplication.shared.open(url)
            }))
            changeSetting.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            changeSetting.presentOnTop()
            
        } else {
            let Alert = UIAlertController(title: "Select Source?", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            Alert.popoverPresentationController?.sourceRect = contentView.contactImage.bounds
            Alert.popoverPresentationController?.sourceView = contentView.contactImage
            
            imgPicker.allowsEditing = true
            imgPicker.modalPresentationStyle = UIModalPresentationStyle.popover
            imgPicker.popoverPresentationController?.sourceView = contentView.contactImage
            imgPicker.popoverPresentationController?.sourceRect = contentView.contactImage.bounds
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                Alert.addAction(UIAlertAction(title: "Camera", style: .default) { (camera) -> Void in
                    imgPicker.sourceType = .camera
                    self.present(imgPicker, animated: true, completion: nil)
                })}
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                Alert.addAction(UIAlertAction(title: " Library", style: .default) { (Photolibrary) -> Void in
                    imgPicker.sourceType = .photoLibrary
                    self.present(imgPicker, animated: true, completion: nil)
                })}
            Alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            Alert.presentOnTop()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            contentView.contactImage.setImage(image, for: .normal)
            if let url: URL = info[UIImagePickerControllerImageURL] as? URL, let data: Data = try? Data(contentsOf: url) {
                contentView.pictureData = data
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
}
