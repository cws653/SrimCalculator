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
    
    lazy var chartsView = ChartsView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartsView.setUp()
        view.addSubview(chartsView)
    }
}

class ChartsView: UIView {
    var chart: LineChartView!
    var dataSet: LineChartDataSet!
    
    func setUp()
    {
        self.backgroundColor = .red
        // Sample data
        let values: [Double] = [8, 104, 81, 93, 52, 44, 97, 101, 75, 28,
            76, 25, 20, 13, 52, 44, 57, 23, 45, 91,
            99, 14, 84, 48, 40, 71, 106, 41, 45, 61]
        
        var entries: [ChartDataEntry] = Array()
        
        for (i, value) in values.enumerated()
        {
            entries.append(ChartDataEntry(x: Double(i), y: value, icon: UIImage(named: "icon", in: Bundle(for: self.classForCoder), compatibleWith: nil)))
        }
        
        dataSet = LineChartDataSet(entries: entries, label: "First unit test data")
        dataSet.drawIconsEnabled = false
        dataSet.iconsOffset = CGPoint(x: 0, y: 20.0)

        chart = LineChartView(frame: CGRect(x: 0, y: 0, width: 480, height: 350))
        chart.backgroundColor = NSUIColor.clear
        chart.leftAxis.axisMinimum = 0.0
        chart.rightAxis.axisMinimum = 0.0
        chart.data = LineChartData(dataSet: dataSet)
        self.addSubview(chart)
    }
}
