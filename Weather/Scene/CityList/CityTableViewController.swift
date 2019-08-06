//
//  CityTableViewController.swift
//  Weather
//
//  Created by ChanHee Kim on 03/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit


private enum Constant {

    static let cellHeigth: CGFloat = 80

}

internal protocol CityTableViewControllerDelegate: class {

    func cityTableViewController(_ controller: CityTableViewController, didAddCity city: Placemark)
    func cityTableViewController(_ controller: CityTableViewController, didRemoveCity city: Placemark)
    func cityTableViewController(_ controller: CityTableViewController, didSelectCity city: Placemark)

}

internal class CityTableViewController: UITableViewController {

    // MARK: - internal

    internal weak var delegate: CityTableViewControllerDelegate?

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupController()
    }

    deinit {
        self.clockTimer?.invalidate()
        self.clockTimer = nil
    }

    // MARK: - override

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - private

    private var models: [Placemark] = []
    private var currentPlacemark: Placemark?
    private var clockTimer: Timer?
    private var footerView: CityTableFooterView = CityTableFooterView.fromNib()

    private func setupController() {
        self.setupTableView()
        self.registerTableViewCell()
        self.setupClockTimer()
        self.setupFooterView()
        self.setupData()
    }

    private func setupTableView() {
        self.tableView.backgroundColor = .clear

        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }

        self.tableView.allowsMultipleSelectionDuringEditing = false
    }

    private func setupFooterView() {
        self.footerView.delegate = self
        let size = CGSize(width: UIScreen.main.bounds.width, height: 90)
        self.footerView.frame = CGRect(origin: .zero, size: size)
        self.tableView.tableFooterView = self.footerView
    }

    private func setupData() {
        let cities: [Placemark] = Defaults.value(forKey: .cities) ?? []

        if let latestPlacemark = LocationManager.shared.latestPlacemark {
            self.currentPlacemark = latestPlacemark
            self.models = [latestPlacemark] + cities
        } else {
            LocationManager.shared.requestCurrentPlacemark { (result) in
                result
                    .handleSuccess({
                        self.currentPlacemark = $0
                        self.models = [$0] + cities
                    })
                    .handleFailure({ _ in
                        self.currentPlacemark = nil
                        self.models = cities
                    })

                self.tableView.reloadData()
            }
        }
    }

    private func registerTableViewCell() {
        self.tableView.registerNib(CityTableViewCell.self)
    }

    // update weather every 1 minute
    private func setupClockTimer() {
        let now: Date = Date()
        let calendar: Calendar = Calendar.current
        let currentSeconds: Int = calendar.component(.second, from: now)

        let timer = Timer(
            fire: now.addingTimeInterval(Double(60 - currentSeconds + 1)),
            interval: 60,
            repeats: true,
            block: { [weak self] (timer) in
                guard let self = self else {
                    timer.invalidate()
                    return
                }

                self.tableView.reloadData()
        })
        self.clockTimer = timer

        RunLoop.main.add(timer, forMode: RunLoop.Mode.default)
    }

}

extension CityTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(CityTableViewCell.self, for: indexPath)
        cell.setModel(self.models[safe: indexPath.row], isFirst: indexPath.row == 0)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            return Constant.cellHeigth + statusBarHeight
        } else {
            return Constant.cellHeigth
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let model = self.models[safe: indexPath.row] else {
            return
        }

        self.dismiss(animated: true, completion: nil)
        self.delegate?.cityTableViewController(self, didSelectCity: model)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row > 0
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let target = self.models[safe: indexPath.row] else {
            return
        }

        if editingStyle == .delete {
            self.models.remove(at: indexPath.row)

            self.delegate?.cityTableViewController(self, didRemoveCity: target)
            self.tableView.reloadData()

            let value: [Placemark] = Defaults.value(forKey: .cities) ?? []
            Defaults.set(object: value.filter { $0 != target }, forKey: .cities)
        }
    }

}


extension CityTableViewController: CityTableFooterViewDelegate {

    func cityTableFooterViewDidClickAddButton(_ cityTableFooterView: CityTableFooterView) {
        let citySearchViewController = CitySearchViewController.make()
        citySearchViewController.citySearchDelegate = self
        self.present(citySearchViewController, animated: true, completion: nil)
    }

}


extension CityTableViewController: CitySearchViewControllerDelegate {

    func citySearchViewController(_ citySearchViewController: CitySearchViewController, didSelectPlacemark placemark: Placemark) {
        citySearchViewController.dismiss(animated: true, completion: nil)

        guard self.models.contains(placemark) == false else {
            return
        }
        self.models.append(placemark)

        let value: [Placemark] = Defaults.value(forKey: .cities) ?? []
        Defaults.set(object: value + [placemark], forKey: .cities)

        let indexPath = IndexPath(row: self.models.count - 1, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)

        self.delegate?.cityTableViewController(self, didAddCity: placemark)
    }

}
