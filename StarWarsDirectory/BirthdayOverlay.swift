//
//  BirthdayOverlay.swift
//  StarWarsDirectory
//
//  Created by Dan Leonard on 4/19/18.
//  Copyright © 2018 MacMeDan. All rights reserved.
//

import Foundation
import UIKit
import Material

class BirthdayOverlay: UIView {
    
    let datePicker: UIDatePicker = UIDatePicker()
    let saveBirthdayButton: UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension BirthdayOverlay {
    
    func prepareView() {
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.9)
        isHidden = true // Hidden by default
        prepareDatePicker()
        prepareSaveBirthdayButton()
    }
    
    func prepareSaveBirthdayButton() {
        saveBirthdayButton.setTitle("Save Birthday", for: UIControlState())
        saveBirthdayButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        
        layout(saveBirthdayButton).right(20).centerVertically(offset: datePicker.frame.height/2)
    }
    
    func prepareDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.setValue(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), forKeyPath: "textColor")
        datePicker.setDate(Date(timeIntervalSinceNow: -30000), animated: false)
        datePicker.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        datePicker.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.8)
        
        layout(datePicker).center().left(20).right(20)
    }
    
}
