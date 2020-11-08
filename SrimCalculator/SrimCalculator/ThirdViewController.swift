//
//  ThirdViewController.swift
//  SrimCalculator
//
//  Created by 최원석 on 2020/10/18.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit
import SwiftDataTables

class ThirdViewController: UIViewController {
    
    
    lazy var dataTable = makeDataTable()
    var dataSource: DataTableContent = []
    let headerTitles = ["년도","매출액", "영업이익", "당기순이익", "EPS"]
    
    var corpCode: String?
    var corpName: String?
    
    private let APIInstanceClass = APIClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setupAPIData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupViews() {
        automaticallyAdjustsScrollViewInsets = false
        navigationController?.navigationBar.isTranslucent = false
        title = "재무제표 리스트"
        view.backgroundColor = UIColor.white
        view.addSubview(dataTable)
        dataTable.reload()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dataTable.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            dataTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dataTable.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            dataTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func setupAPIData() {
        for year in 2010...2019 {
            APIInstanceClass.APIfunctionForFinancialStatements(corpCode: self.corpCode ?? "", year: year) { financialData in
                
                var year: DataTableValueType = .int(year)
                var account: DataTableValueType = .string("")
                var businessProfit: DataTableValueType = .string("")
                var netIncome: DataTableValueType = .string("")
                var EPS: DataTableValueType = .string("")
                
                for factor in financialData {
                    if factor.accountNm.contains("매출액") {
                        account = DataTableValueType.string(factor.thstrmAmount)
                        
                    } else if factor.accountNm.contains("영업이익")  {
                        businessProfit = DataTableValueType.string(factor.thstrmAmount)
                        
                    } else if factor.accountNm.contains("당기순이익") && factor.sjNm.contains("손익계산서") {
                        netIncome = DataTableValueType.string(factor.thstrmAmount)
                        
                    } else if factor.accountNm.contains("기본주당이익") {
                        EPS = DataTableValueType.string(factor.thstrmAmount)
                    }
                }
                let temp = [year, account, businessProfit, netIncome, EPS]
                self.updateDataSourece(temp)
            }
        }
    }
    
    private func updateDataSourece(_ dataSource: [DataTableValueType]) {
        DispatchQueue.main.async {
            self.dataSource.append(dataSource)
//            self.dataSource.sort { ($0.first ?? DataTableValueType.int(1)) < ($1.first ?? DataTableValueType.int(1)) }
            self.dataTable.reload()
        }
    }
}

extension ThirdViewController {
    private func makeDataTable() -> SwiftDataTable {
        let dataTable = SwiftDataTable(dataSource: self)
        dataTable.translatesAutoresizingMaskIntoConstraints = false
        dataTable.delegate = self
        dataTable.dataSource = self
        return dataTable
    }
}

extension ThirdViewController: SwiftDataTableDataSource {
    func numberOfColumns(in: SwiftDataTable) -> Int {
        return self.headerTitles.count
    }
    
    func numberOfRows(in: SwiftDataTable) -> Int {
        return self.dataSource.count
    }
    
    func dataTable(_ dataTable: SwiftDataTable, dataForRowAt index: NSInteger) -> [DataTableValueType] {
        return self.dataSource[index]
    }
    
    func dataTable(_ dataTable: SwiftDataTable, headerTitleForColumnAt columnIndex: NSInteger) -> String {
        return self.headerTitles[columnIndex]
    }
}

extension ThirdViewController: SwiftDataTableDelegate {
    func didSelectItem(_ dataTable: SwiftDataTable, indexPath: IndexPath) {
        debugPrint("did select item at indexPath: \(indexPath) dataValue: \(dataTable.data(for: indexPath))")
    }
    
    func heightForSectionFooter(in dataTable: SwiftDataTable) -> CGFloat {
        return 0.1
    }
}
