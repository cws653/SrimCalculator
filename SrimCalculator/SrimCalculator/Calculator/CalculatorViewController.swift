//
//  CalculatorViewController.swift
//  SrimCalculator
//
//  Created by 최원석 on 2021/01/14.
//  Copyright © 2021 최원석. All rights reserved.
//

import UIKit
import Kanna

class CalculatorViewController: UIViewController {
    
    var corporateBondRate: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callCorporateBondRate() { [weak self] corporateBondRate in
            self?.corporateBondRate = corporateBondRate
        }
    }
    
    private func callCorporateBondRate(completion: @escaping (Double) -> Void) {
        let mainURL = "https://www.kisrating.com/ratingsStatistics/statics_spread.do"
        guard let main = URL(string: mainURL) else {
            print("Error: \(mainURL) doesn't seem to be a valid URL")
            return
        }
        do {
            let lolMain = try String(contentsOf: main, encoding: .utf8)
            let doc = try HTML(html: lolMain, encoding: .utf8)
            for product in doc.xpath("//div[@id='con_tab1']") {
                if let firstURL = product.at_xpath("//div[@class='table_ty1']") {
                    if let secondURL = firstURL.at_xpath("table/tbody/tr[11]/td[9]") {
                        if let corporateBondRate = secondURL.text {
                            completion(Double(corporateBondRate) ?? 0.0)
                        }
                    }
                }
            }
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    private func callFinancialData(year: Int, completion:@escaping ([FinancialStatementsList]) -> Void) {
        //        let mycrtfcKey: String = "28223d93326101b760b633b7ab5469df600a465f"
        //            var baseURL: String = "https://opendart.fss.or.kr/api/fnlttSinglAcntAll.json"
        
        let anothertestURL :String = "https://opendart.fss.or.kr/api/fnlttSinglAcntAll.json?crtfc_key=28223d93326101b760b633b7ab5469df600a465f&corp_code=00126380&bsns_year=2019&reprt_code=11011&fs_div=OFS"
        
        //            let MakedURL = baseURL + "?crtfc_key=\(mycrtfcKey)" + "&corp_code=\(corpCode)" + "&bsns_year=\(year)" + "&reprt_code=11011" + "&fs_div=OFS"
        //            if anothertestURL == MakedURL {
        //                print("url 값은 같습니다.")
        //            } else {
        //                print("url 값은 다릅니다.")
        //            }
        
        guard let url = URL(string: anothertestURL) else {return}
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) {(datas, response, error) in
            if error != nil {
                print("Network Error")
            }
            guard let data = datas else {return}
            
            do {
                let search = try JSONDecoder().decode(SearchFinancialStatementsResult.self, from: data)
                completion(search.list)
            } catch {
                print("JSON Parising Error")
            }
        }
        dataTask.resume()
    }
}


struct DataForROE {
    let  OwnerNetIncome: String
    let OwnershipInterest: String
}
