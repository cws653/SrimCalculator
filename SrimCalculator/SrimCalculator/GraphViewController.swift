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
    let testPosition: [CGFloat] = [20, 10, 30, 20, 50, 100, 10, 10]
    let takingdataOftable: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let padding: CGFloat = 100
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width - padding, height: self.view.frame.height - padding)
        let view = cwsLineGraph(frame: frame, values: testPosition)
        view.backgroundColor = .gray
        view.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 2)
        self.view.addSubview(view)
        
//        var testView = cwsChart(frame: CGRect(x: 0, y: 0, width: 100, height: 100), dataSource: self)
//        view.backgroundColor = .blue
//        testView.center = self.view.center
//        self.view.addSubview(testView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
}

class cwsLineGraph: UIView {
    
    var values: [CGFloat] = []
    
    var graphPath: UIBezierPath!
    var zeroPath: UIBezierPath!
    
    let graphLayer = CAShapeLayer()
    
    init(frame: CGRect, values: [CGFloat]) {
        super.init(frame: frame)
        self.values = values
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.graphPath = UIBezierPath()
        self.zeroPath = UIBezierPath()
        
        self.layer.addSublayer(graphLayer)
        
        let xOffset: CGFloat = self.frame.width / CGFloat(values.count)
        
        var currentX: CGFloat = 0
        self.graphPath.move(to: CGPoint(x: currentX, y: self.frame.height))
        self.zeroPath.move(to: CGPoint(x: currentX, y: self.frame.height))
        
        for i in 0..<values.count {
            currentX += xOffset
            let newPosition = CGPoint(x: currentX, y: self.frame.height - self.values[i])
            self.graphPath.addLine(to: newPosition)
            self.zeroPath.addLine(to: CGPoint(x: currentX, y: self.frame.height))
        }
        
        graphLayer.fillColor = nil
        graphLayer.strokeColor = UIColor.black.cgColor
        graphLayer.lineWidth = 2
        
        
        let oldPath = self.zeroPath.cgPath
        let newPath = self.graphPath.cgPath
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 0.9
        animation.fromValue = oldPath
        animation.toValue = newPath
        
        self.graphLayer.path = newPath
        self.graphLayer.add(animation, forKey: "path")
        
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
        
        let path = UIBezierPath()
        path.move(to: .zero)
//        path.addCurve(to: CGPoint(x: 100, y: 100), controlPoint1: CGPoint(x: 0, y: 100), controlPoint2: CGPoint(x: 100, y: 0))
        path.addQuadCurve(to: CGPoint(x: 30, y: 0), controlPoint: CGPoint(x: 20, y: 40))
        
        UIColor.orange.set()
        path.stroke()
    }
}
