//
//  ContentView.swift
//  SwiftChartsShowcase
//
//  Created by Himali Marasinghe on 2025-09-05.
//

import SwiftUI

enum Demo: String, CaseIterable, Identifiable, Hashable {
    case bar, line, area, point, stacked, combo, range, heatmap, pie, interaction

    var id: String { rawValue }

    var title: String {
        switch self {
            case .bar: "Bar Chart"
            case .line: "Line Chart"
            case .area: "Area Chart"
            case .point: "Point / Scatter"
            case .stacked: "Stacked Bar"
            case .combo: "Combo: Line + Bar"
            case .range: "Range (Gantt-like)"
            case .heatmap: "Heatmap"
            case .pie: "Pie / Donut"
            case .interaction: "Interactions"
        }
    }

    var subtitle: String {
        switch self {
            case .bar: "Compare categories"
            case .line: "Trend over time"
            case .area: "Trend + fill"
            case .point: "Distribution"
            case .stacked: "Breakdown by category"
            case .combo: "Two series, two stories"
            case .range: "Intervals on a timeline"
            case .heatmap: "Intensity grid"
            case .pie: "Share of whole (iOS 17+)"
            case .interaction: "Selection & annotations"
        }
    }

    @ViewBuilder
    var destination: some View {
        switch self {
            case .bar: BarChartDemo()
            case .line: LineChartDemo()
            case .area: AreaChartDemo()
            case .point: PointChartDemo()
            case .stacked: StackedBarDemo()
            case .combo: ComboLineBarDemo()
            case .range: RangeMarkDemo()
            case .heatmap: HeatmapDemo()
            case .pie: PieDonutDemo()
            case .interaction: InteractionDemo()
        }
    }
}

struct ContentView: View {
    private let demos = Demo.allCases

    var body: some View {
        NavigationStack {
            List(demos) { demo in
                NavigationLink(value: demo) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(demo.title).font(.headline)
                        Text(demo.subtitle).font(.caption)
                    }
                }
            }
            .navigationTitle("Swift Charts Showcase")
            .navigationDestination(for: Demo.self) { demo in
                demo.destination
                    .navigationTitle(demo.title)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
