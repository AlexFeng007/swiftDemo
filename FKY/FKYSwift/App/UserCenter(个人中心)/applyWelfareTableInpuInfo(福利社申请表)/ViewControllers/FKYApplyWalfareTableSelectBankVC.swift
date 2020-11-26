//
//  FKYApplyWalfareTableSelectBankVC.swift
//  FKY
//
//  Created by 油菜花 on 2020/5/14.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYApplyWalfareTableSelectBankVC: UIViewController {

    /// viewModel
    let viewModel = FKYApplyWalfareTableSelectBankViewModel()
    
    /// 选择银行之后的回调
    var selectBankCallBack:((_ bankName:String,_ bankID:String)->())?
    
    /// 容器视图
    lazy var containerView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xffffff)
        return view
    }()
    
    /// 标题
    lazy var topTitleLB:UILabel = {
        let lb = UILabel()
        lb.text = "收款银行选择"
        lb.font = .systemFont(ofSize: WH(17))
        lb.textColor = RGBColor(0x000000)
        lb.textAlignment = .center
        lb.backgroundColor = RGBColor(0xFFFFFF)
        return lb
    }()
    
    /// 分割线
//    lazy var marginLine:UIView = {
//        let view = UIView()
//        view.backgroundColor = RGBColor(0xE5E5E5)
//        return view
//    }()
    
    /// 关闭按钮
    lazy var closeBtn:UIButton = {
        let bt = UIButton()
        bt.setBackgroundImage(UIImage(named:"btn_pd_group_close"), for: .normal)
        bt.addTarget(self, action: #selector(FKYApplyWalfareTableSelectBankVC.closeBtnClicked), for: .touchUpInside)
        return bt
    }()
    
    /// 主table
    lazy var mainTableView:UITableView = {
        let tb = UITableView(frame: CGRect.null, style: .grouped)
        tb.delegate = self
        tb.dataSource = self
        tb.rowHeight = UITableView.automaticDimension
        tb.estimatedRowHeight = 50
        tb.estimatedSectionHeaderHeight = 40
        tb.estimatedSectionFooterHeight = 0
        tb.bounces = false
        //tb.separatorStyle = .none
        tb.register(FKYApplyWalfareTableBankCell.self, forCellReuseIdentifier: NSStringFromClass(FKYApplyWalfareTableBankCell.self))
        tb.backgroundColor = RGBColor(0xFFFFFFFF)
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.requestBankList()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showAnimation()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

/// 事件响应
extension FKYApplyWalfareTableSelectBankVC{
    
    /// 关闭按钮点击
    @objc func closeBtnClicked(){
        self.dismissAnimation()
    }
}

//MARK: - UI
extension FKYApplyWalfareTableSelectBankVC{
    
    func setupUI(){
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.view.addSubview(self.containerView)
        self.containerView.addSubview(self.topTitleLB)
        self.containerView.addSubview(self.closeBtn)
        //self.containerView.addSubview(self.marginLine)
        self.containerView.addSubview(self.mainTableView)
        
        
        
        self.containerView.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.snp_bottom)
            make.height.equalTo(WH(420))
        }
        
        self.topTitleLB.snp_makeConstraints { (make) in
            make.top.equalToSuperview().offset(WH(0))
            //make.top.equalTo(self.view.snp_bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(WH(55))
        }
        
        self.closeBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.topTitleLB)
            make.right.equalToSuperview().offset(WH(-13))
            make.width.height.equalTo(WH(17))
        }
        
//        self.marginLine.snp_makeConstraints { (make) in
//            make.top.equalTo(self.topTitleLB.snp_bottom)
//            make.left.right.equalToSuperview()
//            make.height.equalTo(0.5)
//        }
        
        self.mainTableView.snp_makeConstraints { (make) in
            make.top.equalTo(self.topTitleLB.snp_bottom)
            make.bottom.left.right.equalToSuperview()
            //make.height.equalTo(WH(364))
        }
    }
    
    /// 出现动画
    func showAnimation(){
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor=UIColor(red:0, green:0, blue:0, alpha:0.5)
            self.containerView.hd_y -= WH(420)
            /*
            self.topTitleLB.snp_remakeConstraints { (make) in
                make.top.equalToSuperview().offset(WH(247))
                make.left.right.equalToSuperview()
                make.height.equalTo(WH(55))
            }
            */
        }) { (isFinished) in
            if isFinished {
                
            }
        }
    }
    
    /// 消除动画
    func dismissAnimation(){
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor=UIColor(red:0, green:0, blue:0, alpha:0)
            self.containerView.hd_y += WH(420)
            /*
            self.topTitleLB.snp_remakeConstraints { (make) in
                //make.top.equalToSuperview().offset(WH(247))
                make.top.equalTo(self.view.snp_bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(WH(55))
            }
            */
        }) { (isFinished) in
            self.dismiss(animated: false) {
                
            }
        }
    }
    
}

//MARK: - 网络请求
extension FKYApplyWalfareTableSelectBankVC{
    func requestBankList(){
        self.showLoading()
        self.viewModel.getBankList {[weak self] (isSuccess, msg) in
            guard let weakSelf = self else {
                return
            }
            weakSelf.dismissLoading()
            guard isSuccess else {
                weakSelf.toast(msg)
                return
            }
            
            weakSelf.mainTableView.reloadData()
        }
    }
}

//MARK: - UITableView代理
extension FKYApplyWalfareTableSelectBankVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.bankList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYApplyWalfareTableBankCell.self)) as! FKYApplyWalfareTableBankCell
        cell.configCell(text: self.viewModel.bankList[indexPath.row].bankCodeName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let callBack =  self.selectBankCallBack {
            callBack(self.viewModel.bankList[indexPath.row].bankCodeName,self.viewModel.bankList[indexPath.row].bankCode)
            self.dismissAnimation()
        }
    }
    
}
