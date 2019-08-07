//
//  MainViewController.swift
//  Weather
//
//  Created by ChanHee Kim on 31/07/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var pageControl: WeatherPageControl!

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateCurrentPlacemark()
    }

    // MARK: - action

    @IBAction
    private func onClickGithubButton(_ sender: Any) {
        UIApplication.shared.open(URL.gitHubRepo, options: [:], completionHandler: nil)
    }
 
    @IBAction
    private func onClickCityListButton(_ sender: Any) {
        let vc = CityTableViewController()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }

    // MARK: - private

    private let pageViewController = MainPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

    private func setupController() {
        self.view.backgroundColor = Color.darkBlue

        self.setupPageControl()
        self.setupPageViewController()
        self.setupWeatherPages()
    }

    private func updateCurrentPlacemark() {
        LocationManager.shared.requestCurrentPlacemark(completion: { result in
            result.handleFailure(self.showErrorToast)
        })
    }

    private func setupPageViewController() {
        self.pageViewController.mainDelegate = self

        self.addChild(self.pageViewController)
        self.containerView.addSubview(self.pageViewController.view)
        self.pageViewController.view.autoPinEdgesToSuperview()
        self.pageViewController.didMove(toParent: self)
    }

    private func setupWeatherPages() {
        self.setupCurrentWeatherPage()
        self.setupFollowingCityPages()
    }

    private func setupCurrentWeatherPage() {
        self.pageViewController.setupCurrentWeatherPage()
        self.pageControl.numberOfPages += 1
    }

    private func setupFollowingCityPages() {
        let cities: [Placemark] = Defaults.shared.value(forKey: .cities) ?? []
        cities.forEach(self.addPage)
    }

    private func setupPageControl() {
        self.pageControl.numberOfPages = 0
        self.pageControl.currentPage = 0
    }

    private func addPage(with placemark: Placemark) {
        self.pageViewController.addPage(for: placemark)
        self.pageControl.numberOfPages += 1
    }

    private func removePage(with placemark: Placemark) {
        self.pageViewController.removePage(for: placemark)
        self.pageControl.numberOfPages -= 1
    }

    private func selectPage(with placemark: Placemark) {
        self.pageViewController.selectPage(for: placemark)
    }

    // TODO: Window에 직접 Toast 띄우기
    private func showErrorToast(with error: Error) {
        var iteration = 0
        let maximumRecursion = 10

        func _showErrorToast(with error: Error) {
            guard iteration <= maximumRecursion else {
                return
            }

            if self.isVisible {
                UIAlertController.toast("\(error)")
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    iteration += 1
                    _showErrorToast(with: error)
                }
            }
        }

        _showErrorToast(with: error)
    }

}


extension MainViewController: CityTableViewControllerDelegate {

    func cityTableViewController(_ controller: CityTableViewController, didAddCity city: Placemark) {
        self.addPage(with: city)
    }

    func cityTableViewController(_ controller: CityTableViewController, didRemoveCity city: Placemark) {
        self.removePage(with: city)
    }

    func cityTableViewController(_ controller: CityTableViewController, didSelectCity city: Placemark) {
        self.selectPage(with: city)
    }

}

extension MainViewController: MainPageViewControllerDelegate {

    func mainPageViewController(_ mainPageViewController: MainPageViewController, didChangeIndex index: Int) {
        self.pageControl.currentPage = index
    }

}
