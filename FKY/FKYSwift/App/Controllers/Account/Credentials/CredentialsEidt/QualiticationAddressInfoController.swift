//
//  AddressInfoController.swift
//  FKY
//
//  Created by mahui on 2016/11/2.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  地址详情...<未使用?!>

import Foundation
class QualiticationAddressInfoController:
    UIViewController,
    UITableViewDelegate,
    UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    var navBar : UIView?
    
    fileprivate lazy var tableView : UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.register(CredentialsAddressCell.self, forCellReuseIdentifier: "CredentialsAddressCell")
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = bg2
        return view
    }()
    
    var zzInfoModel : ZZModel?
    
    func setupView() -> () {
        self.view.backgroundColor = bg2
        self.navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.fky_setupLeftImage("icon_back_red_normal") {
            FKYNavigator.shared().pop()
        }
        self.navBar!.backgroundColor = bg1
        self.fky_setupTitleLabe("地址详情")
        self.NavigationTitleLabel!.fontTuple = t14
        self.fky_hiddedBottomLine(false)
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) in
            make.top.equalTo((self.navBar?.snp.bottom)!)
            make.left.right.bottom.equalTo(self.view)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.zzInfoModel != nil && self.zzInfoModel?.receiverAddressList != nil {
            return (self.zzInfoModel?.receiverAddressList?.count)!
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        if self.zzInfoModel == nil || self.zzInfoModel?.receiverAddressList == nil {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CredentialsAddressCell", for: indexPath) as! CredentialsAddressCell
        cell.configDetailCell(self.zzInfoModel?.receiverAddressList![indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let zzreceiveModel = self.zzInfoModel?.receiverAddressList![indexPath.row]
        if zzreceiveModel?.defaultAddress == 1 {
            return WH(115)
        }
        return WH(75)
    }
}

