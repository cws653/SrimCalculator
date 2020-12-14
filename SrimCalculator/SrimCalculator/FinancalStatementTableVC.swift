//
//  ThirdViewController.swift
//  SrimCalculator
//
//  Created by 최원석 on 2020/10/18.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit
import SwiftDataTables


class FinancalStatementTableVC: UIViewController {
    
    lazy var dataTable = makeDataTable()
    var dataSource: DataTableContent = []
    let headerTitles = ["년도","매출액(억)", "영업이익(억)", "당기순이익(억)", "EPS(원)"]
    
    var corpCode: String?
    var corpName: String?
    
    let accountWords: [String] = ["매출액", "매출","매출 및 지분법 손익", "수익(매출액)", "영업수익"]
    let businessProfitWords: [String] = ["영업손익", "영업이익", "영업이익(손실)", "총영업이익", "영업이익 (손실)"]
    let netIncomeWords: [String] = ["당기순손익", "당기순이익", "당기순이익(손실)", "당기의 순이익"]
    let EPSWords: [String] = ["기본 및 희석 보통주당이익", "기본 및 희석주당이익", "기본 및 희석주당이익(보통주)", "기본/희석주당순이익", "기본및희석주당계속영업이익", "기본및희석주당이익", "기본및희석주당이익(손실)","기본주당손익", "기본주당순이익", "기본주당이익", "기본주당이익(손실)", "보통주 기본 및 희석주당손익", "보통주 기본 및 희석주당이익(손실)", "보통주 기본및희석주당손익", "보통주 기본주당이익", "보통주기본주당순이익", "보통주기본주당순이익(손실)", "보통주기본주당이익", "보통주희석주당이익", "기본주당이익(손실) (단위:원)","기본주당이익(원)","보통주 기본 및 희석주당이익 (단위: 원)","기본주당계속영업이익","보통주 기본주당손익","기본주당순이익(손실)"]
    
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
        title = "재무제표"
        
        view.backgroundColor = .white
        
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
    
    enum DataValueType {
        case account
        case businessProfit
        case netIncome
        case EPS
        
        var words: [String] {
            switch self {
            case .account:
                return ["매출액", "매출","매출 및 지분법 손익", "수익(매출액)", "영업수익"]
            case .businessProfit:
                return ["영업손익", "영업이익", "영업이익(손실)", "총영업이익", "영업이익 (손실)"]
            case .netIncome:
                return ["당기순손익", "당기순이익", "당기순이익(손실)", "당기의 순이익"]
            case .EPS:
                return ["기본 및 희석 보통주당이익", "기본 및 희석주당이익", "기본 및 희석주당이익(보통주)", "기본/희석주당순이익", "기본및희석주당계속영업이익", "기본및희석주당이익", "기본및희석주당이익(손실)","기본주당손익", "기본주당순이익", "기본주당이익", "기본주당이익(손실)", "보통주 기본 및 희석주당손익", "보통주 기본 및 희석주당이익(손실)", "보통주 기본및희석주당손익", "보통주 기본주당이익", "보통주기본주당순이익", "보통주기본주당순이익(손실)", "보통주기본주당이익", "보통주희석주당이익", "기본주당이익(손실) (단위:원)","기본주당이익(원)","보통주 기본 및 희석주당이익 (단위: 원)","기본주당계속영업이익","보통주 기본주당손익","기본주당순이익(손실)"]
            }
        }
    }
    
    private func setDataValue(_ factor: FinancialStatementsList, dataType: DataValueType) -> DataTableValueType? {
        if self.findKeyWord(structFinancalStatement: factor, list: dataType.words) {
            //                                let factorData = factor.thstrmAmount
            do {
                let factorData = try self.roundToBillion(value: Int(factor.thstrmAmount) ?? 0)
                return DataTableValueType.string(factorData ?? "")
            } catch {
                print("단위가 억단위가 아닙니다.")
            }
        }
        
        return nil
    }
    
    private func setupAPIData() {
        
        let defaultValue: DataTableValueType = .string("")
        
        for year in 2010...2019 {
            APIInstanceClass.APIfunctionForFinancialStatements(corpCode: self.corpCode ?? "", year: year) { financialData in
                
                var year: DataTableValueType = .int(year)
                var account: DataTableValueType = .string("")
                var businessProfit: DataTableValueType = .string("")
                var netIncome: DataTableValueType = .string("")
                var EPS: DataTableValueType = .string("")
                
                for factor in financialData {
                    
                    if account == .string("") {
                        if factor.sjNm.contains("손익계산서") {
                            account = self.setDataValue(factor, dataType: .account) ?? defaultValue
                        } else if factor.sjNm.contains("포괄손익계산서") {
                            account = self.setDataValue(factor, dataType: .account) ?? defaultValue
                        }
                    }
                    
                    if businessProfit == .string("") {
                        if factor.sjNm.contains("손익계산서") {
                            businessProfit = self.setDataValue(factor, dataType: .businessProfit) ?? defaultValue
                        } else if factor.sjNm.contains("포괄손익계산서") {
                            businessProfit = self.setDataValue(factor, dataType: .businessProfit) ?? defaultValue
                        }
                    }
                    
                    if netIncome == .string("") {
                        if factor.sjNm.contains("손익계산서") {
                            netIncome = self.setDataValue(factor, dataType: .netIncome) ?? defaultValue
                        } else if factor.sjNm.contains("포괄손익계산서") {
                            netIncome = self.setDataValue(factor, dataType: .netIncome) ?? defaultValue
                        }
                    }
                    
                    if EPS == .string("") {
                        if factor.sjNm.contains("손익계산서") {
                            if self.findKeyWord(structFinancalStatement: factor, list: self.EPSWords) {
                                let factorData = factor.thstrmAmount
                                EPS = DataTableValueType.string(factorData)
                            }
                        } else if factor.sjNm.contains("포괄손익계산서") {
                            if self.findKeyWord(structFinancalStatement: factor, list: self.EPSWords) {
                                let factorData = factor.thstrmAmount
                                //                                let factorData = self.roundToBillion(value: Int(factor.thstrmAmount) ?? 0)
                                EPS = DataTableValueType.string(factorData)
                            }
                        }
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
            self.dataTable.reload()
        }
    }
    
    enum OperatorError: Error {
        case valueIsLow
    }
    
    private func roundToBillion(value: Int) throws -> String? {
        
        let billion = 100000000
        let fiveMilion = 50000000
        
        let billionValue = value/billion * billion + (value % billion) / fiveMilion * billion
        let str = String(billionValue)
        
        if str.count < 8 {
            return nil
        } else {
            let endIndex = str.index(str.endIndex, offsetBy: -8)
            let remakeStr = String(str[..<endIndex])
            return remakeStr
        }
    }
    
    private func findKeyWord(structFinancalStatement:FinancialStatementsList, list:[String]) -> Bool {
        
        for index in 0..<list.count {
            if structFinancalStatement.accountNm == list[index] {
                //                structFinancalStatement.accountNm.contains(list[word])
                print(list[index])
                return true
            }
        }
        return false
    }
}

struct OperatorManager {
    internal func roundToBillion(value: Int) throws -> String? {
        
        let billion = 100000000
        let fiveMilion = 50000000
        
        let billionValue = value/billion * billion + (value % billion) / fiveMilion * billion
        let str = String(billionValue)
        
        if str.count < 8 {
            return nil
        } else {
            let endIndex = str.index(str.endIndex, offsetBy: -8)
            let remakeStr = String(str[..<endIndex])
            return remakeStr
        }
    }
}

extension FinancalStatementTableVC {
    private func makeDataTable() -> SwiftDataTable {
        let dataTable = SwiftDataTable(dataSource: self)
        dataTable.translatesAutoresizingMaskIntoConstraints = false
        dataTable.delegate = self
        dataTable.dataSource = self
        return dataTable
    }
}

extension FinancalStatementTableVC: SwiftDataTableDataSource {
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

extension FinancalStatementTableVC: SwiftDataTableDelegate {
    func didSelectItem(_ dataTable: SwiftDataTable, indexPath: IndexPath) {
        debugPrint("did select item at indexPath: \(indexPath) dataValue: \(dataTable.data(for: indexPath))")
    }
    
    func dataTable(_ dataTable: SwiftDataTable, widthForColumnAt index: Int) -> CGFloat {
        if index == 0 {
            return 100
        } else {
            return 150
        }
    }
    
    func heightForSectionFooter(in dataTable: SwiftDataTable) -> CGFloat {
        return 0.1
    }
}
