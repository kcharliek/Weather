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
    case ampm_hour = "a h시"
    case ampm_hour_minute = "a h:m"

}

internal class DateLabel: UILabel {

    // MARK: - internal

    internal func setDate(_ date: Date, format: DateFormat) {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        self.text = formatter.string(from: date)
    }

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }




}
