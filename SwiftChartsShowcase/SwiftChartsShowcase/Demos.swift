import SwiftUI
import Charts

// MARK: - Bar
struct BarChartDemo: View {
    var body: some View {
        Chart(SampleData.weeklySales) { s in
            BarMark(
                x: .value("Day", s.day, unit: .day),
                y: .value("Amount", s.amount)
            )
            .annotation(position: .top) {
                Text("\(Int(s.amount))").font(.caption2)
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 7)) { _ in
                AxisValueLabel(format: .dateTime.weekday(.abbreviated))
            }
        }
        .frame(height: 300)
        .padding()
    }
}

// MARK: - Line
struct LineChartDemo: View {
    var body: some View {
        Chart(SampleData.temps.filter { $0.city == "Lisbon" }) { p in
            LineMark(
                x: .value("Date", p.date),
                y: .value("°C", p.value)
            )
            .interpolationMethod(.catmullRom)
            PointMark(x: .value("Date", p.date), y: .value("°C", p.value))
        }
        .chartYScale(domain: 14...30)
        .frame(height: 300)
        .padding()
    }
}

// MARK: - Area
struct AreaChartDemo: View {
    var body: some View {
        Chart(SampleData.temps.filter { $0.city == "Porto" }) { p in
            AreaMark(
                x: .value("Date", p.date),
                y: .value("°C", p.value)
            )
            .interpolationMethod(.monotone)
        }
        .chartYScale(domain: 14...30)
        .frame(height: 300)
        .padding()
    }
}

// MARK: - Point / Scatter
struct PointChartDemo: View {
    var body: some View {
        Chart(SampleData.temps) { p in
            PointMark(
                x: .value("Date", p.date),
                y: .value("°C", p.value)
            )
            .foregroundStyle(by: .value("City", p.city))
        }
        .frame(height: 320)
        .padding()
    }
}

// MARK: - Stacked Bar
struct StackedBarDemo: View {
    var body: some View {
        Chart(SampleData.stackedWeeklySales) { s in
            BarMark(
                x: .value("Day", s.day, unit: .day),
                y: .value("Amount", s.amount)
            )
            .foregroundStyle(by: .value("Channel", s.category ?? "-"))
            .position(by: .value("Channel", s.category ?? "-"))
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 7)) { _ in
                AxisValueLabel(format: .dateTime.weekday(.abbreviated))
            }
        }
        .frame(height: 320)
        .padding()
    }
}

// MARK: - Combo Line + Bar
struct ComboLineBarDemo: View {
    var body: some View {
        Chart {
            ForEach(SampleData.weeklySales) { s in
                BarMark(
                    x: .value("Day", s.day, unit: .day),
                    y: .value("Revenue", s.amount)
                )
            }
            ForEach(SampleData.weeklySales) { s in
                LineMark(
                    x: .value("Day", s.day, unit: .day),
                    y: .value("7d Avg", s.amount)
                )
                .interpolationMethod(.catmullRom)
            }
        }
        .frame(height: 320)
        .padding()
    }
}

// MARK: - Range (Gantt-like)
struct RangeMarkDemo: View {
    var body: some View {
        Chart(SampleData.ranges) { r in
            BarMark(
                xStart: .value("Start", r.start),
                xEnd: .value("End", r.end),
                y: .value("Batch", r.label)
            )
        }
        .frame(height: 280)
        .padding()
    }
}

// MARK: - Heatmap (Rectangle + color scale)
struct HeatmapDemo: View {
    private let days = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]

    var body: some View {
        Chart {
            ForEach(Array(SampleData.heatmapMatrix.enumerated()), id: \.offset) { _, cell in
                RectangleMark(
                    x: .value("Day", days[cell.x]),                         // categorical
                    y: .value("Hour", String(format: "%02d", cell.y)),      // categorical
                    width: .ratio(1), height: .ratio(1)
                )
                .foregroundStyle(.blue)
                .opacity(max(0.05, min(1, cell.v))) // ensure not fully transparent
            }
        }
        .chartXAxis {
            AxisMarks(values: days) { value in AxisValueLabel() }
        }
        .chartYAxis {
            AxisMarks(values: (0..<12).map { String(format: "%02d", $0) }) { _ in AxisValueLabel() }
        }
        .frame(height: 320)
        .padding()
    }
}

// MARK: - Pie / Donut (iOS 17+)
struct PieDonutDemo: View {
    var body: some View {
        if #available(iOS 17.0, *) {
            Chart(SampleData.shares) { s in
                SectorMark(
                    angle: .value("Value", s.value),
                    innerRadius: .ratio(0.5)
                )
                .foregroundStyle(by: .value("Category", s.category))
            }
            .frame(height: 320)
            .padding()
        } else {
            Text("SectorMark requires iOS 17+")
                .foregroundColor(.secondary)
                .padding()
        }
    }
}

// MARK: - Interactions (selection + annotation)
struct InteractionDemo: View {
    @State private var selectedX: Date? = nil

    var body: some View {
        VStack {
            Chart(SampleData.weeklySales) { s in
                LineMark(
                    x: .value("Day", s.day, unit: .day),
                    y: .value("Amount", s.amount)
                )

                if let selectedX, Calendar.current.isDate(s.day, inSameDayAs: selectedX) {
                    RuleMark(x: .value("Selected", selectedX))
                        .annotation(position: .top) {
                            VStack(spacing: 2) {
                                Text(selectedX, style: .date)
                                Text("\(Int(s.amount))")
                            }
                            .font(.caption2)
                        }
                }
            }
            .chartOverlay { proxy in
                GeometryReader { geo in
                    let plot = proxy.plotAreaFrame
                    Rectangle()
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let localX = value.location.x - geo[plot].origin.x
                                    if let date: Date = proxy.value(atX: localX) {
                                        selectedX = Calendar.current.startOfDay(for: date)
                                    }
                                }
                        )
                }
            }
            .frame(height: 320)
            .padding()

            if let d = selectedX {
                Text("Selected: \(d.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption)
            }
        }
    }
}
