//
//  WeatherViewController.swift
//  Weather
//
//  Created by ChanHee Kim on 04/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit

private enum Constant {

    static let currentWeatherViewHeight: CGFloat = UIScreen.main.bounds.size.height * 0.4
    static let hourlyWeatherViewHeight: CGFloat = 100
    static let estimateWeeklyWeatherViewHeight: CGFloat = 100
    static let currentWeatherInfoViewHeight: CGFloat = 370

}


class WeatherViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var stackView: UIStackView!

    // MARK: - internal

    internal var model: Placemark?

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupController()
        self.setupData()
    }

    // MARK: - private

    private var currentWeatherViewController = CurrentWeatherViewController.loadFromNib()
    private var weeklyWeatherTableViewController = WeeklyWeatherTableViewController()
    private var hourlyWeatherCollectionViewController = HourlyWeatherCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    private var currentWeatherInfoViewController = CurrentWeatherInfoViewController.loadFromNib()

    private var forecast: Forecast?
    private var weeklyWeatherViewHeightConstraint: NSLayoutConstraint?

    private func setupController() {
        self.setupCurrentWeatherView()
        self.setupHourlyWeatherView()
        self.setupWeeklyWeatherView()
        self.setupCurrentWeatherInfoView()
    }

    private func setupData() {
        guard let placemark = self.model else {
            return
        }

        ForecastCenter.shared.requestForecast(at: placemark) { [weak self] (result) in
            guard let self = self else { return }
            result.handleSuccess(self.updateForecast)
        }
    }

    private func setupCurrentWeatherView() {
        self.addChild(self.currentWeatherViewController)
        self.stackView.addArrangedSubview(self.currentWeatherViewController.view)
        NSLayoutConstraint.activate([
            self.currentWeatherViewController.view.heightAnchor.constraint(equalToConstant: Constant.currentWeatherViewHeight)
        ])
        self.currentWeatherViewController.didMove(toParent: self)
    }

    private func setupHourlyWeatherView() {
        self.addChild(self.hourlyWeatherCollectionViewController)
        self.stackView.addArrangedSubview(self.hourlyWeatherCollectionViewController.collectionView)
        NSLayoutConstraint.activate([
            self.hourlyWeatherCollectionViewController.collectionView.heightAnchor.constraint(equalToConstant: Constant.hourlyWeatherViewHeight)
        ])
        self.hourlyWeatherCollectionViewController.didMove(toParent: self)
    }

    private func setupWeeklyWeatherView() {
        self.addChild(self.weeklyWeatherTableViewController)
        self.stackView.addArrangedSubview(self.weeklyWeatherTableViewController.tableView)
        self.weeklyWeatherViewHeightConstraint = self.weeklyWeatherTableViewController.tableView.heightAnchor.constraint(equalToConstant: Constant.estimateWeeklyWeatherViewHeight)
        self.weeklyWeatherViewHeightConstraint?.isActive = true

        self.weeklyWeatherTableViewController.didMove(toParent: self)
    }

    private func setupCurrentWeatherInfoView() {
        self.addChild(self.currentWeatherInfoViewController)
        self.stackView.addArrangedSubview(self.currentWeatherInfoViewController.view)
        NSLayoutConstraint.activate([
            self.currentWeatherInfoViewController.view.heightAnchor.constraint(equalToConstant: Constant.currentWeatherInfoViewHeight)
        ])
        self.currentWeatherInfoViewController.didMove(toParent: self)
    }

    private func updateForecast(_ forecast: Forecast) {
        DispatchQueue.main.async {
            self.currentWeatherViewController.setModel(forecast.current, placemark: self.model)
            self.hourlyWeatherCollectionViewController.setModels(forecast.hourly, placemark: self.model)

            self.weeklyWeatherViewHeightConstraint?.constant = CGFloat( forecast.weekly.count * 44)
            self.weeklyWeatherTableViewController.setModels(forecast.weekly)

            self.currentWeatherInfoViewController.setModel(forecast.current, placemark: self.model)
        }
    }

}
