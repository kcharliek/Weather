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
    static let hourlyWeatherViewHeight: CGFloat = 110
    static let estimateWeeklyWeatherViewHeight: CGFloat = 100
    static let currentWeatherInfoViewHeight: CGFloat = 370

}


class WeatherViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var stackView: UIStackView!

    // MARK: - internal

    internal var model: Placemark?

    internal func scrollToTop() {
        self.scrollView?.setContentOffset(.zero, animated: false)
    }

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupController()
        self.setupData()
    }

    // MARK: - private

    private let currentWeatherViewController = CurrentWeatherViewController.loadFromNib()
    private let weeklyWeatherTableViewController = WeeklyWeatherTableViewController()
    private let hourlyWeatherCollectionViewController = HourlyWeatherCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    private let currentWeatherInfoViewController = CurrentWeatherInfoViewController.loadFromNib()

    private var forecast: Forecast?
    private var weeklyWeatherViewHeightConstraint: NSLayoutConstraint?

    private func setupController() {
        self.scrollView.scrollsToTop = true

        self.addCurrentWeatherView()
        self.addLine()
        self.addHourlyWeatherView()
        self.addLine()
        self.addWeeklyWeatherView()
        self.addLine()
        self.addCurrentWeatherInfoView()
        self.addLine()
    }

    private func setupData() {
        guard let placemark = self.model else {
            return
        }

        ForecastCenter.shared.requestForecast(at: placemark) { [weak self] (result) in
            guard let self = self else { return }
            result.handleSuccess(self.updateForecast)
                  .handleFailure { UIAlertController.toast("\($0)") }
        }
    }

    private func addCurrentWeatherView() {
        self.addChild(self.currentWeatherViewController)
        self.stackView.addArrangedSubview(self.currentWeatherViewController.view)
        NSLayoutConstraint.activate([
            self.currentWeatherViewController.view.heightAnchor.constraint(equalToConstant: Constant.currentWeatherViewHeight)
        ])
        self.currentWeatherViewController.didMove(toParent: self)
    }

    private func addHourlyWeatherView() {
        self.addChild(self.hourlyWeatherCollectionViewController)
        self.stackView.addArrangedSubview(self.hourlyWeatherCollectionViewController.collectionView)

        NSLayoutConstraint.activate([
            self.hourlyWeatherCollectionViewController.collectionView.heightAnchor.constraint(equalToConstant: Constant.hourlyWeatherViewHeight)
        ])
        self.hourlyWeatherCollectionViewController.didMove(toParent: self)
    }

    private func addWeeklyWeatherView() {
        self.addChild(self.weeklyWeatherTableViewController)
        self.stackView.addArrangedSubview(self.weeklyWeatherTableViewController.tableView)
        self.weeklyWeatherViewHeightConstraint = self.weeklyWeatherTableViewController.tableView.heightAnchor.constraint(equalToConstant: Constant.estimateWeeklyWeatherViewHeight)
        self.weeklyWeatherViewHeightConstraint?.isActive = true

        self.weeklyWeatherTableViewController.didMove(toParent: self)
    }

    private func addCurrentWeatherInfoView() {
        self.addChild(self.currentWeatherInfoViewController)
        self.stackView.addArrangedSubview(self.currentWeatherInfoViewController.view)
        NSLayoutConstraint.activate([
            self.currentWeatherInfoViewController.view.heightAnchor.constraint(equalToConstant: Constant.currentWeatherInfoViewHeight)
        ])
        self.currentWeatherInfoViewController.didMove(toParent: self)
    }

    private func addLine() {
        let line = UIView(frame: .zero)
        line.backgroundColor = .white
        line.alpha = 0.5
        self.stackView.addArrangedSubview(line)
        NSLayoutConstraint.activate([line.heightAnchor.constraint(equalToConstant: 1)])
    }

    private func updateForecast(_ forecast: Forecast) {
        DispatchQueue.main.async {
            self.currentWeatherViewController.set(model: forecast.current, placemark: self.model)
            self.hourlyWeatherCollectionViewController.set(models: forecast.hourly, placemark: self.model)

            self.weeklyWeatherViewHeightConstraint?.constant = CGFloat( forecast.weekly.count * 44)
            self.weeklyWeatherTableViewController.set(models: forecast.weekly)

            self.currentWeatherInfoViewController.set(model: forecast.current, placemark: self.model)
        }
    }

}
