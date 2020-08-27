//
//  RemindMeTableViewCell.swift
//  RemindMe
//
//  Created by Catalina on 20.08.2020.
//  Copyright © 2020 Catalina. All rights reserved.
//

import UIKit

class RemindMeTableViewCell: UITableViewCell {

    public static var identifier = "RemindMeTableViewCell"
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 3
        return stack
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .black
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .black
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        commitInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commitInit()
    }
    
    private func commitInit() {
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(stackView)
        stackView.edgesToSuperview(insets: UIEdgeInsets(top: 2, left: 15, bottom: 2, right: 2))
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dateLabel)
    }
}
