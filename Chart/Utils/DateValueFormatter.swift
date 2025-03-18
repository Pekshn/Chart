//
//  DateValueFormatter.swift
//  Chart
//
//  Created by Petar  on 18.3.25..
//

import DGCharts
import Foundation

class DateValueFormatter: AxisValueFormatter {
    
    //MARK: - Properties
    private let timeFormatter: DateFormatter
    private let dateFormatter: DateFormatter
    private var isZoomedIn: Bool = false
    
    //MARK: - Init
    init(isZoomedIn: Bool) {
        self.isZoomedIn = isZoomedIn
        self.timeFormatter = DateFormatter()
        self.dateFormatter = DateFormatter()

        timeFormatter.dateFormat = "HH:mm"
        dateFormatter.dateFormat = "dd/MM"
    }
    
    //MARK: - Public API
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)

        if isZoomedIn {
            if components.hour == 0 && components.minute == 0 {
                return "\(timeFormatter.string(from: date))\n\(dateFormatter.string(from: date))" //Time and Date
            }
            return "\(timeFormatter.string(from: date))\n" //Time only
        } else {
            return "\(dateFormatter.string(from: date))\n" //Time only
        }
    }
}
