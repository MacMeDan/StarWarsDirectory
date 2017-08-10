//
//  ContactTableViewCell.swift
//  StarWarsDirectory
//
//  Created by P D Leonard on 7/8/17.
//  Copyright © 2017 MacMeDan. All rights reserved.
//

import UIKit
import SnapKit

class ContactTableViewCell: UITableViewCell {
    var picture = UIImageView()
    var mainLabel = UILabel()
    var subLabel = UILabel()
    var contentStackView = UIStackView()
    var centerStackView = UIStackView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        prepareMainLabel()
        prepareSubLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupPictureView()
    }
    
    func setupPictureView() {
        contentView.addSubview(picture)
        picture.snp.makeConstraints { (make) -> Void in
            let size = 50
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(size)
            make.left.equalToSuperview().offset(8)
        }
        picture.layer.cornerRadius = 25
        picture.clipsToBounds = true
    }
    
    func setupContentStackView() {
        contentStackView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-31)
            make.top.bottom.equalTo(contentView)
        }
    }
    
    func prepareMainLabel() {
        mainLabel.font = UIFont.systemFont(ofSize: 18)
        mainLabel.textColor = UIColor(string: "#d0d0d1")
        self.contentView.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { (make) in
            make.left.equalTo(70)
            make.right.equalTo(-10)
            make.height.equalTo(18)
            make.centerY.equalToSuperview().offset(-10)
        }
    }
    
    func prepareSubLabel() {
        subLabel.font = UIFont.systemFont(ofSize: 10)
        subLabel.textColor = UIColor(string: "#4f4d51")
        subLabel.numberOfLines = 1
        contentView.addSubview(subLabel)
        subLabel.snp.makeConstraints { (make) in
            make.left.equalTo(mainLabel.snp.left)
            make.right.equalTo(mainLabel.snp.right)
            make.top.equalTo(mainLabel.snp.bottom).offset(4)
            make.height.equalTo(12)
        }

    }
}
