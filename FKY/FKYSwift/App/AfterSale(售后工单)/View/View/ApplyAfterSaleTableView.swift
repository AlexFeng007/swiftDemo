//
//  ApplyAfterSaleTableView.swift
//  FKY
//
//  Created by 寒山 on 2019/5/5.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class ApplyAfterSaleTableView: UIView {
    var selectTypeBlock: ((ASApplyTypeModel)->())?// 点击下一步
    // 数据源...<可以是上个界面传递过来的，也可以是当前界面实时请求的>
    var dataList = [ASApplyTypeModel]()
    // 当前默认选择索引...<默认选中>
    var selectedIndex = -1
    // cell高度
    var cellHeight = WH(45)
    //空视图
    fileprivate lazy var emptyView: ASListEmptyView = { [weak self] in
        let view = ASListEmptyView()
        view.tip!.text = "暂无可申请的售后服务"
        view.isHidden = true
        return view
        }()
    // 列表...<快递公司 or 申请原因 or 商品列表>
    fileprivate lazy var tableview: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.tableHeaderView = {
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(10)))
            view.backgroundColor = .clear
            return view
        }()
        view.tableFooterView = UIView.init(frame: CGRect.zero)
        view.register(ASProblemListCell.self, forCellReuseIdentifier: "ASProblemListCell")
        if #available(iOS 11, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    
    // 底部视图...<确定>
    fileprivate lazy var viewBottom: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(62)))
        view.backgroundColor = RGBColor(0xF4F4F4)
        // 按钮
        view.addSubview(self.btnDone)
        self.btnDone.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(WH(10))
            make.right.equalTo(view.snp.right).offset(-WH(30))
            make.left.equalTo(view.snp.left).offset(WH(30))
            make.height.equalTo(WH(42))
        }
        // 分隔线
        let viewLine = UIView.init(frame: CGRect.zero)
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        view.addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.height.equalTo(0.5)
        }
        return view
    }()
    // 提交按钮
    fileprivate lazy var btnDone: UIButton = {
        // 自定义按钮背景图片
        let imgNormal = UIImage.imageWithColor(RGBColor(0xFF2D5C), size: CGSize.init(width: 2, height: 2))
        let imgSelect = UIImage.imageWithColor(UIColor.init(red: 113.0/255, green: 0, blue: 0, alpha: 1), size: CGSize.init(width: 2, height: 2))
        let imgDisable = UIImage.imageWithColor(RGBColor(0xE5E5E5), size: CGSize.init(width: 2, height: 2))
        
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .highlighted)
        btn.setTitleColor(RGBColor(0x999999), for: .disabled)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(15))
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("下一步", for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(3)
        btn.setBackgroundImage(imgNormal, for: .normal)
        btn.setBackgroundImage(imgSelect, for: .highlighted)
        btn.setBackgroundImage(imgDisable, for: .disabled)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.selectedIndex == -1 {
                FKYAppDelegate!.showToast("请选择售后服务类型")
                return
            }
            if let block = strongSelf.selectTypeBlock {
                block(strongSelf.dataList[strongSelf.selectedIndex])
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    init() {
        super.init(frame: CGRect.null)
        backgroundColor =  RGBColor(0xF4F4F4)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpView(){
       // dataList.append(contentsOf: ["申请退换货","随行单据（随货单/发票)","商品错漏发","商品首营资质","企业首营资质"])
        self.addSubview(viewBottom)
        self.addSubview(tableview)
        self.addSubview(emptyView)
        tableview.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(viewBottom.snp.top)
        }
        emptyView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(self)
        }
        viewBottom.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self)
            make.height.equalTo(WH(62)+bootSaveHeight())
        }
        tableview.reloadData()
        
    }
    func configData(_ viewModel:AfterSaleViewModel) {
        self.dataList.removeAll()
        self.dataList = viewModel.dataSource
        self.tableview.reloadData()
        if self.dataList.isEmpty == true{
            self.tableview.isHidden = true
            self.emptyView.isHidden = false
        }else{
            self.tableview.isHidden = false
            self.emptyView.isHidden = true
        }
    }
}
// MARK: - UITableViewDelegate
extension  ApplyAfterSaleTableView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 固定高度
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ASProblemListCell", for: indexPath) as! ASProblemListCell
        // 配置cell
        let model:ASApplyTypeModel = dataList[indexPath.row]
        cell.configCell(model.typeName)
        // 是否选中
        cell.setSelectedStatus(indexPath.row == selectedIndex)
        // 底部分隔线设置
        cell.showBottomLine(indexPath.row == dataList.count - 1 ? false : true)
        // 点击btn后选中
        cell.selectBlock = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.selectedIndex = indexPath.row
            strongSelf.tableview.reloadData()
//            if model.typeId == ASTypeECode.ASType_EnterpriceReport.rawValue{
//                strongSelf.btnDone.setTitle("提交", for: .normal)
//            }else{
//                strongSelf.btnDone.setTitle("下一步", for: .normal)
//            }
        }
        cell.selectionStyle = .default
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedIndex = indexPath.row
        self.tableview.reloadData()
//        let model:ASApplyTypeModel = dataList[indexPath.row]
//        if model.typeId == ASTypeECode.ASType_EnterpriceReport.rawValue{
//            btnDone.setTitle("提交", for: .normal)
//        }else{
//            btnDone.setTitle("下一步", for: .normal)
//        }
        
    }
}

