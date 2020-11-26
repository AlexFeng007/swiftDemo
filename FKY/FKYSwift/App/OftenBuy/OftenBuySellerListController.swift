//
//  OftenBuySellerListController.swift
//  FKY
//
//  Created by 路海涛 on 2017/4/17.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  常购商家

import UIKit

class OftenBuySellerListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Property
    fileprivate lazy var navBar: UIView? = {
        if let _ = self.NavigationBar {
            //
        }
        else {
            self.fky_setupNavBar()
        }
        self.NavigationBar?.backgroundColor = bg1
        return self.NavigationBar!
    }()
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = RGBColor(0xF7F7F7)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OftenBuySellerCell.self, forCellReuseIdentifier: "OftenBuySellerCell")
        return tableView
    }()
    fileprivate var emptyView: OftenBuySellerEmptyView = {
        let view = OftenBuySellerEmptyView(frame: CGRect.zero)
        return view
    }()
    
    fileprivate lazy var dataSouce = [OftenBuySellerModel]()
    
    // MARK: - LiftCircle
    override func viewDidLoad() {
        super.viewDidLoad()
        steupUI()
        getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit {
        print("OftenBuySellerListController deinit~!@")
    }
    // MARK: - steupUI
    func steupUI () {
        self.fky_setupTitleLabel("常购商家")
        self.fky_hiddedBottomLine(false)
        
        self.fky_setupLeftImage("icon_back_new_red_normal") {
            FKYNavigator.shared().pop()
        }
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) -> Void in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        })

        self.view.addSubview(emptyView)
        emptyView.snp.makeConstraints({ (make) -> Void in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        })
    }

    // MARK: - getData
    func getData() -> () {
        self.showLoading()
        OftenBuyViewModel.getChangMerchants({ [weak self] (sellerList) in
            if let strongSelf = self {
                if sellerList.count > 0 {
                    strongSelf.dataSouce = sellerList
                    strongSelf.tableView.reloadData()
                    strongSelf.emptyView.isHidden = true
                }else{
                    strongSelf.emptyView.isHidden = false
                }
                strongSelf.dismissLoading()
            }
        })
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSouce.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OftenBuySellerCell = tableView.dequeueReusableCell(withIdentifier: "OftenBuySellerCell", for: indexPath) as! OftenBuySellerCell
        cell.selectionStyle = .none;
        let model: OftenBuySellerModel = self.dataSouce[indexPath.row]
        cell.config(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model: OftenBuySellerModel = self.dataSouce[indexPath.row]
        FKYNavigator.shared().openScheme(FKY_ShopItem.self) { (vc) in
            let v = vc as! FKYNewShopItemViewController
            v.shopId = model.enterpriseId
        }
    }
}
