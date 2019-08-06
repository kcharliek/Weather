//
//  WeeklyWeatherTableViewController.swift
//  Weather
//
//  Created by ChanHee Kim on 04/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit


class WeeklyWeatherTableViewController: UITableViewController {

    private let cellHeight: CGFloat = 44

    // MARK: - internal

    func set(models: [Weather]) {
        self.models = models
        self.tableView.reloadData()
    }

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupController()
    }

    // MARK: - private

    private var models: [Weather] = []

    private func setupController() {
        self.tableView.backgroundColor = .clear
        self.registerTableViewCell()
        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = .none
    }

    private func registerTableViewCell() {
        self.tableView.registerNib(WeeklyWeatherTableViewCell.self)
    }

}

extension WeeklyWeatherTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(WeeklyWeatherTableViewCell.self, for: indexPath)
        cell.set(model: self.models[safe: indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight
    }

}
