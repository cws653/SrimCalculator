//
//  APIfunction.swift
//  SrimCalculator
//
//  Created by 최원석 on 2020/10/28.
//  Copyright © 2020 최원석. All rights reserved.
//

import Foundation

class APIClass {
    
    private let mycrtfcKey: String = "28223d93326101b760b633b7ab5469df600a465f"
    
    func APIfunctionForFinancialStatements(corpCode: String, year: Int, completion:@escaping ([FinancialStatementsList]) -> Void) {
        var baseURL: String = "https://opendart.fss.or.kr/api/fnlttSinglAcntAll.json"
        
        let anothertestURL :String = "https://opendart.fss.or.kr/api/fnlttSinglAcntAll.json?crtfc_key=28223d93326101b760b633b7ab5469df600a465f&corp_code=00126380&bsns_year=2019&reprt_code=11011&fs_div=OFS"
        
        let MakedURL = baseURL + "?crtfc_key=\(mycrtfcKey)" + "&corp_code=\(corpCode)" + "&bsns_year=\(year)" + "&reprt_code=11011" + "&fs_div=OFS"
        
        if anothertestURL == MakedURL {
            print("url 값은 같습니다.")
        } else {
            print("url 값은 다릅니다.")
        }
        
        guard let url = URL(string: MakedURL) else {return}
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
