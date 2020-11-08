//
//  ViewController.swift
//  SrimCalculator
//
//  Created by 최원석 on 2020/10/16.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit

class searchCorpVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchCoperationTextField: UITextField!
    
    var corpCodeStruct: [CorpCodeStruct] = []
    var result: [SearchCorpNameResult] = []
    var list: [SearchCorpNameList] = []
    var dataString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let jsonDecoder:JSONDecoder = JSONDecoder()
        guard let dataAsset: NSDataAsset = NSDataAsset(name: "CorpCodeJsonData") else {
            return print("we don't have any data")
        }
        
        do {
            let dataCorpStruct = try jsonDecoder.decode(CorpCodeStruct.self, from: dataAsset.data)
            let dataResult = dataCorpStruct.result
            let dataList = dataResult.list
            self.list = dataList
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func clickSearchButton(_ sender: UIButton) {

        if self.searchCoperationTextField.text != "" {
            var isShowAlert: Bool = true
            
            for factor in list {
                
                if factor.corpName.first == self.searchCoperationTextField.text {
                    isShowAlert = false
                    guard let thirdViewController = storyboard?.instantiateViewController(identifier: "ThirdViewController") as? ThirdViewController else {
                        return
                    }
                    thirdViewController.corpName = factor.corpName.first
                    thirdViewController.corpCode = factor.corpCode.first
                    self.navigationController?.pushViewController(thirdViewController, animated: true)
                }
            }
            
            if isShowAlert {
                let alertController = UIAlertController(title: "알림창", message: "기업 이름을 입력해주세요!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "경고", style: .destructive, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            
        } else {
            let alertController = UIAlertController(title: "알림창", message: "기업 이름을 입력해주세요!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "경고", style: .destructive, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
