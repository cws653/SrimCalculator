//
//  GraphViewController.swift
//  SrimCalculator
//
//  Created by 최원석 on 2020/11/26.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    let yPosition: [Int] = [18, 8, 8, 9, 10]
    let xPosition: [Int] = [1,2,3,4,5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var testView = cwsChart(frame: self.view.frame, dataSource: self)
        view.backgroundColor = .blue
        self.view.addSubview(testView)
        
        //self.view.backgroundColor = .blue
    }
}

extension GraphViewController: cwsChartDataSource {
    func cwsChartNumberOfXCount() -> Int {
        return xPosition.count
    }
    
    func cwsChartNUmberOfYCount() -> Int {
        return yPosition.count
    }
    
    func cwsChartEachPoint(_ xPoistion: Int) -> Int {
        return self.yPosition[xPoistion]
    }
}

protocol cwsChartDataSource: class {
    func cwsChartNumberOfXCount() -> Int
    func cwsChartNUmberOfYCount() -> Int

    func cwsChartEachPoint(_ xPoistion: Int) -> Int
}

class cwsChart: UIView {
    
    internal weak var dataSource: cwsChartDataSource?
    
    init(frame: CGRect, dataSource: cwsChartDataSource) {
        super.init(frame: frame)
        
        self.dataSource = dataSource
        
        self.backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let yCount = self.dataSource?.cwsChartNUmberOfYCount() else { return }
        guard let xCount = self.dataSource?.cwsChartNumberOfXCount() else { return }
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: 0))
        
        for x in 0..<xCount {
            guard let yPosition = self.dataSource?.cwsChartEachPoint(x) else { return }
            
            path.addLine(to: CGPoint(x: x * 100, y: yPosition * 20))
        }
        
        UIColor.systemRed.set()
        
        path.stroke()
    }
}
