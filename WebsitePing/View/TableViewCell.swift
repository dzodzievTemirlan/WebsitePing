//
//  TableViewCell.swift
//  WebsitePing
//
//  Created by Temirlan Dzodziev on 13.07.2020.
//  Copyright © 2020 Temirlan Dzodziev. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    let link: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    let status: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(link)
        link.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        link.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addSubview(status)
        status.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        status.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
    }
    
}
