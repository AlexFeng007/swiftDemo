//
//  FKYSelectBankVC.swift
//  FKY
//
//  Created by 油菜花 on 2020/1/9.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYSelectBankVC: UIViewController {

     typealias selectBankBlock = (_ selectBank : FKYBankModel ) -> ()
    
    ///选择银行后的回调
    var selectBank:selectBankBlock?
    
    ///银行列表
    lazy var bankListTable:UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = RGBColor(0xF2F2F2)
        table.bounces = false
        table.tableFooterView = UIView.init(frame: .zero)
//        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    ///银行viewModel
    lazy var bankViewModel = FKYSelectBankViewModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        requestInvoiceBank()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        popBankView()
    }

}

//MARK: - 事件响应
extension FKYSelectBankVC {
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKY_dismissSelectBankVC {//dismiss
            dismissBankView()
        }
    }
    
    ///触摸空白处收回
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissBankView()
    }
}

//MARK: - 网络请求
extension FKYSelectBankVC {
    func requestInvoiceBank(){
        self.bankViewModel.requestBankList { (success, msg) in
            self.bankListTable.reloadData()
        }
    }
}
//MARK: - UITableViewDelegate,dataSoure
extension FKYSelectBankVC:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bankViewModel.bankList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellTableIndentifier = "selectBankCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: CellTableIndentifier)
        if (cell == nil){
            cell = UITableViewCell.init(style: .default, reuseIdentifier: CellTableIndentifier)
        }
        cell?.selectionStyle = .none
        cell?.textLabel?.font = UIFont.systemFont(ofSize: WH(13))
        let bankModel = self.bankViewModel.bankList[indexPath.row]
        cell?.textLabel?.text = bankModel.name
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WH(44)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = FKYSelectBankTitleView(frame: .zero)
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(55))
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return WH(55)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bankModel = self.bankViewModel.bankList[indexPath.row]
        if selectBank != nil {
            selectBank!(bankModel)
            dismissBankView()
        }
    }
}

//MARK: - UI
extension FKYSelectBankVC {
    func setupView(){
        
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        
        self.view.addSubview(bankListTable)
        
        bankListTable.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view.snp_bottom)
            make.height.equalTo(SCREEN_HEIGHT/5.0*3.0)
        }
    }
    
    ///弹出银行选择界面
    func popBankView(){
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.bankListTable.transform = CGAffineTransform(translationX: 0, y: -(SCREEN_HEIGHT/5.0*3.0));//xy移动距离;
        }) { (isComplete) in
            
        }
    }
    
    ///移除选择界面
    func dismissBankView(){
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.bankListTable.transform = .identity
        }) {[weak self] (isComplete) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismiss(animated: true) {
                
            }
        }
    }
}
