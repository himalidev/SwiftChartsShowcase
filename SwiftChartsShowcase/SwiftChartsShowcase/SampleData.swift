//
//  SampleData.swift
//  SwiftChartsShowcase
//
//  Created by Himali Marasinghe on 2025-09-05.
//

import Foundation

// MARK: - Namespaced sample data + helpers
enum SampleData {
    // calendar + day helper
    static var calendar: Calendar = {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = .current
        return c
    }()

    static func day(_ i: Int) -> Date {
        let today = calendar.startOfDay(for: Date())
        return calendar.date(byAdding: .day, value: i, to: today) ?? today
    }

    // data used by the demos
    static var weeklySales: [Sales] = [
        .init(day: day(0), amount: 120, category: nil),
        .init(day: day(1), amount: 90,  category: nil),
        .init(day: day(2), amount: 150, category: nil),
        .init(day: day(3), amount: 200, category: nil),
        .init(day: day(4), amount: 170, category: nil),
        .init(day: day(5), amount: 110, category: nil),
        .init(day: day(6), amount: 140, category: nil)
    ]

    static var stackedWeeklySales: [Sales] = {
        let cats = ["Online", "Retail", "Wholesale"]
        var arr: [Sales] = []
        for i in 0..<7 {
            for c in cats {
                let base = [100, 70, 40][cats.firstIndex(of: c)!]
                let jitter = Double(Int.random(in: -10...20))
                arr.append(.init(day: day(i), amount: Double(base) + jitter, category: c))
            }
        }
        return arr
    }()

    static var temps: [TemperaturePoint] = {
        let cities = ["Lisbon", "Porto", "Faro"]
        var data: [TemperaturePoint] = []
        for i in 0..<30 {
            for city in cities {
                let base: Double = (city == "Lisbon" ? 22 : city == "Porto" ? 20 : 24)
                let value = base + sin(Double(i)/4.0) * 3 + Double.random(in: -1.2...1.2)
                data.append(.init(date: day(i), city: city, value: value))
            }
        }
        return data
    }()

    static var shares: [CategoryShare] = [
        .init(category: "iOS", value: 42),
        .init(category: "macOS", value: 18),
        .init(category: "watchOS", value: 15),
        .init(category: "tvOS", value: 8),
        .init(category: "Other", value: 17)
    ]

    static var heatmapMatrix: [(x: Int, y: Int, v: Double)] = {
        var m: [(Int, Int, Double)] = []
        for x in 0..<7 {
            for y in 0..<12 {
                let value = Double.random(in: 0...1) * (y < 6 ? 0.6 : 1.0) + (x >= 5 ? 0.2 : 0)
                m.append((x, y, value))
            }
        }
        return m
    }()

    static var ranges: [TimeRangeSample] = [
        .init(label: "Batch A", start: day(0), end: day(1)),
        .init(label: "Batch B", start: day(1), end: day(3)),
        .init(label: "Batch C", start: day(2), end: day(5))
    ]
}
