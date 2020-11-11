//
//  ViewController.swift
//  SrimCalculator
//
//  Created by 최원석 on 2020/10/16.
//  Copyright © 2020 최원석. All rights reserved.
//

import UIKit
import SearchTextField
//import SearchTextField  // https://github.com/apasccon/SearchTextField

class SearchCorpVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var searchCoperationTextField: SearchTextField!
    
    private var corpCodeStruct: [CorpCodeStruct] = []
    private var result: [SearchCorpNameResult] = []
    private var list: [SearchCorpNameList] = []
    private var dataString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setList()
        self.setupSearchCoperationTextField()
    }
    
    private func setupSearchCoperationTextField() {
        self.searchCoperationTextField.maxNumberOfResults = 5
        self.searchCoperationTextField.itemSelectionHandler = { item, itemPosition in
            self.searchCoperationTextField.text = item[itemPosition].title
            self.pushToFinancialStatementVC()
        }
    }
    
    private func setSearchCoperationTextField(_ dataList: [SearchCorpNameList]) {
        var suggestionItems: [SearchTextFieldItem] = []
        for data in self.list {
            suggestionItems.append(SearchTextFieldItem(title: data.corpName.first ?? ""))
        }
        self.searchCoperationTextField.filterItems(suggestionItems)
    }
    
    private func setList() {
        guard let dataAsset: NSDataAsset = NSDataAsset(name: "CorpCodeJsonData") else {
            return print("we don't have any data")
        }
        
        do {
            let jsonDecoder = JSONDecoder()
            let dataCorpStruct = try jsonDecoder.decode(CorpCodeStruct.self, from: dataAsset.data)
            
            self.list = dataCorpStruct.result.list
            self.setSearchCoperationTextField(dataCorpStruct.result.list)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func clickSearchButton(_ sender: UIButton) {
        
        guard self.searchCoperationTextField.text != "" else {
            self.showAlert()
            return
        }
        
        self.pushToFinancialStatementVC()
    }
    
    private func pushToFinancialStatementVC() {
        var isShowAlert: Bool = true
        
        for factor in list {
            //TODO: for 문 안에서 여러번 push 하는 경우 어떻게 처리할지 고민!
            if factor.corpName.first == self.searchCoperationTextField.text {
                isShowAlert = false
                
                guard let tabBarController = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController else {
                    return
                }
                
                guard let financialStatementVC = tabBarController.viewControllers?[0] as? FinancalStatementTableVC  else {
                    return
                }
                
                financialStatementVC.corpName = factor.corpName.first
                financialStatementVC.corpCode = factor.corpCode.first
                
                self.navigationController?.pushViewController(tabBarController, animated: true)
            }
        }
        
        if isShowAlert {
            self.showAlert()
        }
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "알림창", message: "기업 이름을 입력해주세요!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "경고", style: .destructive, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
