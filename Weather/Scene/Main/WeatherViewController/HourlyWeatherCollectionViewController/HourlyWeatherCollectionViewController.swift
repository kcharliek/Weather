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

    internal func setModels(_ models: [Weather]) {
        self.models = models
    }

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupController()
    }

    // MARK: - private

    private var models: [Weather] = []

    private func setupController() {
        self.registerCollectionViewCell()
    }

    private func registerCollectionViewCell() {
        self.collectionView.register(HourlyWeatherCollectionViewCell.self)
    }

}

extension HourlyWeatherCollectionViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.models.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(HourlyWeatherCollectionViewCell.self, for: indexPath)
        cell.setModel(self.models[safe: indexPath.row])
        return cell
    }

}
