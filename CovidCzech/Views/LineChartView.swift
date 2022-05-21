//
//  LineChartView.swift
//  CovidCzech
//
//  Created by Richard Amare on 10/8/21.
//

import SwiftUI
import SwiftUICharts

struct LineChartView: View {
    var data: [InfectedDaily]
    
    var dataPoints: [LineChartDataPoint] {
        data.map { item -> LineChartDataPoint in
            let xAxis = item.formattedDate
                .formatted(.dateTime.day().month().year())
                .prefix(5)
            let description = item.formattedDate
                .formatted(.dateTime.day().month().year())
            
            return LineChartDataPoint(
                value: Double(item.value),
                xAxisLabel: String(xAxis),
                description: description,
                date: item.formattedDate
            )
        }
    }
    
    var chartData: LineChartData {
        let data = LineDataSet(
            dataPoints: dataPoints,
            pointStyle: PointStyle(),
            style: LineStyle(lineColour: ColourStyle(colour: .accentColor), lineType: .curvedLine)
        )
        
        let chartStyle = LineChartStyle(
            infoBoxPlacement: .infoBox(isStatic: true),
            infoBoxContentAlignment: .vertical,
            infoBoxBorderColour: Color(uiColor: .systemGray5),
            infoBoxBorderStyle: StrokeStyle(lineWidth: 1),
            markerType: .vertical(attachment: .line(dot: .style(DotStyle()))),
            xAxisLabelPosition: .bottom,
            xAxisLabelColour: Color.primary,
            xAxisLabelsFrom: .dataPoint(rotation: .degrees(0)),
            yAxisLabelPosition: .leading,
            yAxisLabelColour: Color.primary,
            globalAnimation: .easeOut(duration: 1)
        )
        
        return LineChartData(dataSets: data, chartStyle: chartStyle)
    }
    
    var body: some View {
        Chart(data: chartData)
    }
}

struct Chart: View {
    var data: LineChartData
    
    var body: some View {
        LineChart(chartData: data)
            .touchOverlay(chartData: data, specifier: "%.0f")
            .xAxisGrid(chartData: data)
            .yAxisGrid(chartData: data)
            .yAxisLabels(chartData: data, colourIndicator: .style(size: 12))
            .infoBox(chartData: data)
            .id(data.id)
            .frame(height: UIScreen.main.bounds.height * 0.4)
    }
}

struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartView(data: [.init(value: 200, date: "")])
    }
}
