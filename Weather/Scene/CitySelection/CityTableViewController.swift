//
//  CityTableViewController.swift
//  Weather
//
//  Created by ChanHee Kim on 03/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit


private enum Constant {

    static let cellHeigth: CGFloat = 65

}

internal class CityTableViewController: UITableViewController {

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupController()
    }

    deinit {
        self.clockTimer?.invalidate()
        self.clockTimer = nil
    }

    // MARK: - private

    private var models: [Placemark] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var clockTimer: Timer?

    private func setupController() {
        self.registerTableViewCell()
        self.setupClockTimer()
    }

    private func registerTableViewCell() {
        self.tableView.register(CityTableViewCell.self)
    }

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

//    private func sendTimeChangeNotification() {
//        NotificationCenter.default.post(name: .didChangeDeviceTime, object: nil)
//    }

}

extension CityTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(CityTableViewCell.self, for: indexPath)
        cell.setModel(self.models[safe: indexPath.row])
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

    }

}
