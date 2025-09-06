import Foundation

struct Sales: Identifiable, Hashable {
    let id = UUID()
    let day: Date
    let amount: Double
    let category: String?
}

struct TemperaturePoint: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let city: String
    let value: Double
}

struct CategoryShare: Identifiable, Hashable {
    let id = UUID()
    let category: String
    let value: Double
}

struct TimeRangeSample: Identifiable, Hashable {
    let id = UUID()
    let label: String
    let start: Date
    let end: Date
}
