//
//  UITableViewExtensions.swift
//  Weather
//
//  Created by ChanHee Kim on 02/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit


extension UITableView {

    func register(_ cellClass: UITableViewCell.Type) {
        self.register(cellClass, forCellReuseIdentifier: cellClass.typeName)
    }

    func dequeueReusableCell<TableViewCell: UITableViewCell>(_ cellClass: TableViewCell.Type, for indexPath: IndexPath) -> TableViewCell {
        return self.dequeueReusableCell(withIdentifier: cellClass.typeName, for: indexPath) as! TableViewCell
    }

}
