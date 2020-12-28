//
//  ChartsViewController.swift
//  SrimCalculator
//
//  Created by 최원석 on 2020/12/18.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit
import Charts

class ChartsViewController: UIViewController {
    
    @IBOutlet weak var lineGraphView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let months: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let unitsSold: [Double] = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        lineGraphView.noDataText = "데이터가 없습니다."
        lineGraphView.noDataFont = .systemFont(ofSize: 20)
        lineGraphView.noDataTextColor = .lightGray
        
        setChart(dataPoints: months, values: unitsSold)
       
        
        
//        for i in 0..<dataPoint.count {
//            let dataEntry = ChartDataEntry(x: Double(i), y: Double(dataArray[i]))
//            dataEntries.append(dataEntry)
//        }
//
//        let line1 = LineChartDataSet(entries: dataEntries, label: "Numbers")
//        line1.colors = [NSUIColor.blue]
//
//        let data = LineChartData()
//        data.addDataSet(line1)
////        let chartDataSet = ChartDataSet(entries: dataEntries, label: "Numbers")
////        let chartData = ChartData(dataSet: chartDataSet)
//
//        lineGraphView.data = data
    }
    
    private func setChart(dataPoints: [String], values: [Double]) {
        var lineChartEntry = [ChartDataEntry]()
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            lineChartEntry.append(dataEntry)
        }
        
        let line = LineChartDataSet(entries: lineChartEntry, label: "Numbers")
        line.colors = [NSUIColor.blue]
        line.highlightEnabled = false
        
        let data = LineChartData(dataSet: line)
        lineGraphView.data = data
        
        lineGraphView.xAxis.labelPosition = .bottom
        lineGraphView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        lineGraphView.xAxis.setLabelCount(dataPoints.count, force: false)
        lineGraphView.rightAxis.enabled = false
        lineGraphView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        lineGraphView.leftAxis.axisMaximum = 30
        lineGraphView.leftAxis.axisMinimum = -10
    }
    
}

