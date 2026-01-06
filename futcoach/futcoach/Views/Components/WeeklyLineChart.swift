//
//  WeeklyLineChart.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 6.01.2026.
//

import SwiftUI
import Charts

/// Interactive line chart displaying weekly health data
struct WeeklyLineChart: View {
    let data: [DailyStats]
    let metric: HealthMetric
    @Binding var selectedDay: DailyStats?
    
    @State private var animationProgress: CGFloat = 0
    
    /// Transformed data for the chart
    private var chartData: [(day: Date, value: Double, hasData: Bool)] {
        data.map { stat in
            let value = metric.value(from: stat)
            // For heart rate, check if it's nil (no data)
            let hasData = metric == .heartRate ? stat.heartRate != nil : value > 0
            return (stat.date, value, hasData)
        }
    }
    
    /// Y-axis range with some padding
    private var yAxisRange: ClosedRange<Double> {
        let values = chartData.map { $0.value }
        let minValue = values.min() ?? 0
        let maxValue = max(values.max() ?? 100, 1)
        let padding = (maxValue - minValue) * 0.1
        return max(0, minValue - padding)...(maxValue + padding)
    }
    
    var body: some View {
        Chart {
            ForEach(chartData.indices, id: \.self) { index in
                let item = chartData[index]
                
                // Area under curve for depth effect
                AreaMark(
                    x: .value("Day", item.day, unit: .day),
                    y: .value(metric.displayName, item.value * animationProgress)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [metric.color.opacity(0.3), metric.color.opacity(0.05)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)
                
                // Main line
                LineMark(
                    x: .value("Day", item.day, unit: .day),
                    y: .value(metric.displayName, item.value * animationProgress)
                )
                .foregroundStyle(metric.color)
                .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .interpolationMethod(.catmullRom)
                
                // Point markers
                if item.hasData {
                    PointMark(
                        x: .value("Day", item.day, unit: .day),
                        y: .value(metric.displayName, item.value * animationProgress)
                    )
                    .foregroundStyle(metric.color)
                    .symbolSize(selectedDay?.date == item.day ? 120 : 50)
                    .annotation(position: .top) {
                        if selectedDay?.date == item.day {
                            ChartTooltip(value: metric.formatValueWithUnit(item.value), day: item.day)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                }
            }
            
            // Vertical selection indicator
            if let selected = selectedDay {
                RuleMark(x: .value("Selected", selected.date, unit: .day))
                    .foregroundStyle(.white.opacity(0.3))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 3]))
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { value in
                AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                AxisGridLine()
                    .foregroundStyle(.white.opacity(0.1))
                AxisValueLabel()
                    .foregroundStyle(.white.opacity(0.6))
                    .font(.system(size: 10))
            }
        }
        .chartYScale(domain: yAxisRange)
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle()
                    .fill(.clear)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                handleChartInteraction(at: value.location, proxy: proxy, geometry: geometry)
                            }
                            .onEnded { _ in
                                withAnimation(.spring(response: 0.3)) {
                                    selectedDay = nil
                                }
                            }
                    )
            }
        }
        .frame(height: 200)
        .padding()
        .cardStyle()
        .onAppear {
            // Animate chart drawing
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                animationProgress = 1.0
            }
        }
        .onChange(of: metric) { _ in
            // Reset and re-animate on metric change
            animationProgress = 0
            withAnimation(.easeOut(duration: 0.5)) {
                animationProgress = 1.0
            }
        }
    }
    
    /// Handle tap/drag gesture on the chart
    private func handleChartInteraction(at location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) {
        let plotFrame = geometry[proxy.plotAreaFrame]
        let x = location.x - plotFrame.origin.x
        
        guard x >= 0, x <= plotFrame.width else { return }
        guard let date: Date = proxy.value(atX: x) else { return }
        
        let calendar = Calendar.current
        
        // Find the closest day
        if let closest = data.min(by: {
            abs(calendar.startOfDay(for: $0.date).timeIntervalSince(date)) <
            abs(calendar.startOfDay(for: $1.date).timeIntervalSince(date))
        }) {
            // Only update if it's a different day
            if selectedDay?.date != closest.date {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
                    selectedDay = closest
                }
                HapticManager.lightImpact()
            }
        }
    }
}

/// Tooltip displayed above selected chart point
struct ChartTooltip: View {
    let value: String
    let day: Date
    
    private var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: day)
    }
    
    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
            
            Text(dayName)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        )
        .offset(y: -8)
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color.primaryGradientStart, Color.primaryGradientMiddle, Color.primaryGradientEnd],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        WeeklyLineChart(
            data: (0..<7).map { dayOffset in
                DailyStats(
                    userId: "preview",
                    date: Calendar.current.date(byAdding: .day, value: -6 + dayOffset, to: Date())!,
                    steps: Int.random(in: 3000...12000),
                    distance: Double.random(in: 2...8) * 1000,
                    activeEnergy: Double.random(in: 200...600),
                    heartRate: Double.random(in: 60...100)
                )
            },
            metric: .steps,
            selectedDay: .constant(nil)
        )
        .padding()
    }
}
