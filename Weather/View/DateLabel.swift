//
//  DateLabel.swift
//  Weather
//
//  Created by ChanHee Kim on 03/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit


internal enum DateFormat: String {

    case dayOfTheWeek = "EEEE"
    case ampm_hour = "a h"
    case ampm_hour_minute = "a h:m"

}

internal class DateLabel: UILabel {

    // MARK: - internal

    internal func setTimeInterval(_ timeInterval: TimeInterval?, format: DateFormat, timeZone: TimeZone? = nil) {
        guard let timeInterval = timeInterval else {
            self.text = "--"
            return
        }
        let date = Date(timeIntervalSince1970: timeInterval)
        self.setDate(date, format: format, timeZone: timeZone)
    }

    internal func setDate(_ date: Date, format: DateFormat, timeZone: TimeZone? = nil) {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone ?? .current
        formatter.dateFormat = format.rawValue
        self.text = formatter.string(from: date)
    }

}
