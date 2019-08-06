//
//  HourlyWeatherCollectionViewController.swift
//  Weather
//
//  Created by ChanHee Kim on 02/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit


class HourlyWeatherCollectionViewController: UICollectionViewController {

    // MARK: - internal

    internal func setModels(_ models: [Weather], placemark: Placemark?) {
        self.models = models
        self.placemark = placemark
        self.collectionView.reloadData()
    }

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupController()
    }

    // MARK: - private

    private var models: [Weather] = []
    private var placemark: Placemark?

    private func setupController() {
        self.collectionView.backgroundColor = .clear
        self.registerCollectionViewCell()
        (self.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
    }

    private func registerCollectionViewCell() {
        self.collectionView.registerNib(HourlyWeatherCollectionViewCell.self)
    }

}

extension HourlyWeatherCollectionViewController: UICollectionViewDelegateFlowLayout {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(self.models.count, 12)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(HourlyWeatherCollectionViewCell.self, for: indexPath)
        cell.setModel(self.models[safe: indexPath.row], placemark: self.placemark)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: collectionView.frame.height)
    }

}
