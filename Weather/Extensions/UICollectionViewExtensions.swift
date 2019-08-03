//
//  UICollectionViewExtensions.swift
//  Weather
//
//  Created by ChanHee Kim on 02/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit


extension UICollectionView {

    func register(_ cellClass: UICollectionViewCell.Type) {
        self.register(cellClass, forCellWithReuseIdentifier: cellClass.typeName)
    }

    func dequeueReusableCell<CollectionViewCell: UICollectionViewCell>(_ cellClass: CollectionViewCell.Type, for indexPath: IndexPath) -> CollectionViewCell {
        return self.dequeueReusableCell(withReuseIdentifier: cellClass.typeName, for: indexPath) as! CollectionViewCell
    }

}
