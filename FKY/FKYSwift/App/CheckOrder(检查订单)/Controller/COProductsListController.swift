//
//  COProductsListController.swift
//  FKY
//
//  Created by My on 2019/12/9.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class COProductsListController: UIViewController {
    
    //商家model
    var supplyShop: COSupplyOrderModel?
    
    lazy var headerView: COProductsListHeader = {
        let view = COProductsListHeader.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(44)))
        return view
    }()
    
    // 列表
    fileprivate lazy var tableview: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        view.separatorStyle = .none
        if #available(iOS 11, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        view.register(COProductInfoCell.self, forCellReuseIdentifier: "COProductInfoCell")
        return view
    }()
    
    // 导航栏
    fileprivate lazy var navBar: UIView? = {
        if let _ = self.NavigationBar {
            //
        }
        else {
            self.fky_setupNavBar()
        }
        self.NavigationBar?.backgroundColor = bg1
        return self.NavigationBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        reloadProductsListVC()
    }
}


extension COProductsListController {
    // UI绘制
    fileprivate func setupView() {
        view.backgroundColor = .white
        // 标题
        fky_setupTitleLabel("药品清单")
        // 分隔线
        fky_hiddedBottomLine(false)
        
        // 返回
        fky_setupLeftImage("icon_back_new_red_normal") {
            FKYNavigator.shared().pop()
        }
        
        view.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(WH(10));
            make.right.equalTo(view).offset(-WH(10));
            make.top.equalTo(self.navBar!.snp.bottom)
            make.bottom.equalTo(view).offset(-COInputController.getScreenBottomMargin())
        }
    }
    
    func reloadProductsListVC() {
        if let shop = supplyShop {
            headerView.configCell(shop)
            tableview.reloadData()
        }
    }
}

extension COProductsListController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let shop = supplyShop else {
            return 0
        }
        
        if let products = shop.products {
            return products.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let shop = supplyShop else {
            return UITableViewCell.init(style: .default, reuseIdentifier: "error")
        }
        
        if let products = shop.products, products.count > indexPath.row {
            let cell = tableView.dequeueReusableCell(withIdentifier: "COProductInfoCell", for: indexPath) as! COProductInfoCell
            cell.configCell(products[indexPath.row], (indexPath.row != products.count - 1))
            return cell
        }
        
        return UITableViewCell.init(style: .default, reuseIdentifier: "error")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let shop = supplyShop else {
            return 0
        }
        
        if let products = shop.products, products.count > indexPath.row {
            let model = products[indexPath.row]
            return COProductInfoCell.getContentHeight(model)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return WH(44)
    }
}
