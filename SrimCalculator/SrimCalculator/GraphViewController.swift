//
//  GraphViewController.swift
//  SrimCalculator
//
//  Created by 최원석 on 2020/11/26.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    //let yPosition: [Int] = [18, 8, 8, 9, 10]
    //let xPosition: [Int] = [1,2,3,4,5]
    //let testPosition: [CGFloat] = [20, 10, 30, 20, 50, 100, 10, 10]
    var takingdataOftable: [[CGFloat]] = []
    
    private let cwsLineGraph = CwsChart()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cwsLineGraph.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setLineGraph()
    }
    
    private func setLineGraph() {
        self.cwsLineGraph.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cwsLineGraph)
        self.cwsLineGraph.backgroundColor = .green
        
        self.cwsLineGraph.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        self.cwsLineGraph.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        self.cwsLineGraph.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        self.cwsLineGraph.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
}

extension GraphViewController: CwsChartDataSource {
    func cwsChartNumberOfData() -> Int {
        return self.takingdataOftable.count
    }
    
    func cwsChartEachPoint(_ index: Int) -> CGFloat {
        return CGFloat(self.takingdataOftable[index][1])
    }
}

protocol CwsChartDataSource: class {
    func cwsChartNumberOfData() -> Int

    func cwsChartEachPoint(_ xPoistion: Int) -> CGFloat
}

class CwsChart: UIView {
    
    var values: [CGFloat] = []
    
    var graphPath: UIBezierPath?
    var zeroPath: UIBezierPath?
    
    let graphLayer = CAShapeLayer()
    
    internal weak var dataSource: CwsChartDataSource?
    
    init() {
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        self.graphPath = UIBezierPath()
        self.zeroPath = UIBezierPath()
        
        let xOffset: CGFloat = self.frame.width / CGFloat(self.dataSource?.cwsChartNumberOfData() ?? Int(0.0))
        
        self.addLinePath(xOffset: xOffset)
        self.setGraphLayer()
        
        self.layer.addSublayer(graphLayer)
    
        self.drawAnimation()
    }
    
    private func addLinePath(xOffset: CGFloat) {
        var currentX: CGFloat = 0
        
        self.graphPath?.move(to: CGPoint(x: currentX, y: self.frame.height))
        self.zeroPath?.move(to: CGPoint(x: currentX, y: self.frame.height) )
        
        let datacount = self.dataSource?.cwsChartNumberOfData() ?? 0
        
        var max: CGFloat = 0
        for i in 0..<datacount {
            let data = self.dataSource?.cwsChartEachPoint(i) ?? -1
            max = data > max ? data : max
        }
        
        for i in 0..<datacount {
            currentX += xOffset
            let accountInformation = (self.dataSource?.cwsChartEachPoint(i) ?? -1) * (self.frame.height / max)
            
            let newPosition = CGPoint(x: currentX, y: self.frame.height - accountInformation)
            self.graphPath?.addLine(to: newPosition)
            print("cws \(newPosition)")
            self.zeroPath?.addLine(to: CGPoint(x: currentX, y: self.frame.height))
        }
    }
    
    private func setGraphLayer() {
        graphLayer.fillColor = nil
        graphLayer.strokeColor = UIColor.black.cgColor
        graphLayer.lineWidth = 2
        
        guard let cgPath = self.graphPath?.cgPath else { return }
        self.graphLayer.path = cgPath
    }
    
    private func drawAnimation() {
        let oldPath = self.zeroPath?.cgPath
        let newPath = self.graphPath?.cgPath
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 0.9
        animation.fromValue = oldPath
        animation.toValue = newPath
        
        guard let newCGPath = newPath else { return }
        
        self.graphPath?.cgPath = newCGPath
        self.graphLayer.add(animation, forKey: "path")
    }
}
