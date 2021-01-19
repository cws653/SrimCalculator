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

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                        print(secondURL.text ?? 0)
                    }
                }
            }
            
//*[@id="con_tab1"]/div[2]/table/tbody/tr[11]/td[9]
            
//          for product in doc.xpath("//div[@class='in']") {
//            if let productURL = product.at_xpath("a/strong"){
//              if let schedule = productURL.text, schedule.contains("[") {
//                print(schedule)
//              }
//            }
//          }
        } catch let error {
          print("Error: \(error)")
        }
    }
}
