//
//  FKYSalesManVC.swift
//  FKY
//
//  Created by fengbo on 2020/11/24.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import Foundation

class FKYSalesManVC : UIViewController,UITableViewDelegate,UITableViewDataSource
{
    fileprivate var navBar : UIView?
    fileprivate lazy var tableView : UITableView = {[weak self] in
        var tableView = UITableView(frame:CGRect.null, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = RGBColor(0xF4F4F4)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = UIView.init(frame: .zero)
        tableView.tableFooterView = UIView.init(frame: .zero)
        
        
        tableView.register(SalesManTableCell.self, forCellReuseIdentifier: "SalesManTableCell")
        
        if #available (iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
    }()
    
    fileprivate var emptyView : FKYSaleManEmptyView = {
        let view = FKYSaleManEmptyView(frame:CGRect.zero)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()
        self.setupView()
    }
    
    //Mark:tableView Delegate && DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 138
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SalesManTableCell  = tableView.dequeueReusableCell(withIdentifier: "SalesManTableCell", for: indexPath) as! SalesManTableCell
        
        return cell;
    }
}

extension FKYSalesManVC {
    func fetchData() {
        self.showLoading()
        print("fetchData")
        self.dismissLoading()
    }
}

extension FKYSalesManVC {
    func setupView() {
        self.view.backgroundColor = RGBColor(0xFFFFFF)
        self.navBar = { [weak self] in
            if let _ = self?.NavigationBar {
                
            }else{
                self?.fky_setupNavBar()
            }
            self?.NavigationBar?.backgroundColor = bg1
            return self?.NavigationBar
        }()
        self.fky_setupTitleLabel("我的联系人")
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal") {
            FKYNavigator.shared()?.pop()
        }
        
        //tableView
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) -> Void in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(self.navBar!.snp.bottom)
        }
        
        //emptyView
        self.view.addSubview(emptyView)
        self.emptyView.isHidden = true
        emptyView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
    }
}
