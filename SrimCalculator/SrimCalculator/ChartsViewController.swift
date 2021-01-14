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
    var useForMakingCharts: [[Double]] = []
    
    @IBAction func clickAccountButton(_ sender: UIButton) {
        tableData = []
        setChartDefault(inputDataType: .account)
    }
    
    @IBAction func clickBusinessButton(_ sender: UIButton) {
        tableData = []
        setChartDefault(inputDataType: .businessProfit)
    }
    
    @IBAction func clickNetIncomeButton(_ sender: UIButton) {
        tableData = []
        setChartDefault(inputDataType: .netIncome)
    }
    
    @IBAction func clickEPSButton(_ sender: UIButton) {
        tableData = []
        setChartDefault(inputDataType: .EPS)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let months: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        //        let unitsSold: [Double] = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setChartDefault(inputDataType: .account)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableData.removeAll()
    }
    
    struct TableData {
        let years: Int
        let valueData: Double
//        let businessProfit: Double
//        let netIncome: Double
//        let EPS: Double
    }
    
    var tableData: [TableData] = []
    
    enum inputDataType {
        case account
        case businessProfit
        case netIncome
        case EPS
        
        var title: String {
            switch self {
            case .account: return "매출액"
            case .businessProfit: return "영업이익"
            case .netIncome: return "당기순이익"
            case .EPS: return "EPS"
            }
        }
    }
    
    private func setChartDefault(inputDataType: inputDataType) {
        //        var months: [Double] = []
        //        for index in 0..<takingdataOftable.count {
        //            months.append(takingdataOftable[index][0])
        //        }
        //        var unitsSold: [Double] = []
        //        for index in 0..<takingdataOftable.count {
        //         a   unitsSold.append(takingdataOftable[index][1])
        //        }
        switch inputDataType {
        case .account:
            for index in 0..<useForMakingCharts.count {
                let tableDataFactor = TableData(years: Int(useForMakingCharts[index][0]), valueData: useForMakingCharts[index][1])
                tableData.append(tableDataFactor)
            }
        case .businessProfit:
            for index in 0..<useForMakingCharts.count {
                let tableDataFactor = TableData(years: Int(useForMakingCharts[index][0]), valueData: useForMakingCharts[index][2])
                tableData.append(tableDataFactor)
            }
        case .netIncome:
            for index in 0..<useForMakingCharts.count {
                let tableDataFactor = TableData(years: Int(useForMakingCharts[index][0]), valueData: useForMakingCharts[index][3])
                tableData.append(tableDataFactor)
            }
        case .EPS:
            for index in 0..<useForMakingCharts.count {
                let tableDataFactor = TableData(years: Int(useForMakingCharts[index][0]), valueData: useForMakingCharts[index][4])
                tableData.append(tableDataFactor)
            }
        }
        
        let sortedTableData = tableData.sorted { $0.years < $1.years }
        let changingYearsToString = sortedTableData.map { String($0.years) }
        let yAxisData = sortedTableData.map { $0.valueData }
        
        lineGraphView.noDataText = "데이터가 없습니다."
        lineGraphView.noDataFont = .systemFont(ofSize: 20)
        lineGraphView.noDataTextColor = .lightGray
        
        setChart(xAxisData: changingYearsToString, yAxisData: yAxisData, inputDataType: inputDataType)
    }
    
    private func setChart(xAxisData: [String], yAxisData: [Double], inputDataType: inputDataType) {
        var lineChartEntry = [ChartDataEntry]()
        
        for i in 0..<xAxisData.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: yAxisData[i])
            lineChartEntry.append(dataEntry)
        }
        
        var lineDataSet = LineChartDataSet()
        if inputDataType == .EPS {
            lineDataSet = LineChartDataSet(entries: lineChartEntry, label: "단위(원)")
        } else {
            lineDataSet = LineChartDataSet(entries: lineChartEntry, label: "단위(억원)")
        }

        lineDataSet.colors = [NSUIColor.blue]
        lineDataSet.highlightEnabled = false
        
        let data = LineChartData(dataSet: lineDataSet)
        lineGraphView.data = data
        
        lineGraphView.xAxis.labelPosition = .bottom
        lineGraphView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisData)
        lineGraphView.xAxis.setLabelCount(xAxisData.count-1, force: false)
        lineGraphView.rightAxis.enabled = false
        lineGraphView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
//        lineGraphView.leftAxis.axisMaximum = max
//        lineGraphView.leftAxis.axisMinimum = minimum
    }
}

extension Array {
    public subscript(index: Int, default defaultValue: @autoclosure () -> Element) -> Element {
        guard index >= 0, index < endIndex else {
            return defaultValue()
        }
        return self[index]
    }
}
