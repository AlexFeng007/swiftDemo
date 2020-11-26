//
//  COFrightRuleListController.swift
//  FKY
//
//  Created by 夏志勇 on 2019/3/1.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  检查订单之运费规则列表

import UIKit

class COFrightRuleListController: UIViewController {
    //MARK: - Property
    
    // 响应视图
    fileprivate lazy var viewDismiss: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    // 内容视图...<包含所有内容的容器视图>
    fileprivate lazy var viewContent: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        return view
    }()
    
    // 顶部视图...<标题、关闭、确定>
    fileprivate lazy var viewTop: COPopTitleView = {
        let view = COPopTitleView.init(frame: CGRect.zero)
        view.updateDoneStatus(false) // 隐藏右侧确定按钮
        // 取消
        view.closeAction = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.view.superview != nil {
                strongSelf.showOrHidePopView(false)
            }
        }
        return view
    }()
    // 列表
    fileprivate lazy var tableview: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .grouped)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.backgroundView = nil
        view.separatorStyle = .none
        //view.tableHeaderView = UIView.init(frame: CGRect.zero)
        view.tableFooterView = UIView.init(frame: CGRect.zero)
        view.tableHeaderView = {
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(10)))
            view.backgroundColor = .clear
            return view
        }()
        view.estimatedRowHeight = WH(45) // 动态适配cell高度
        view.rowHeight = UITableView.automaticDimension
        view.register(COFrightRuleCell.self, forCellReuseIdentifier: "COFrightRuleCell")
        view.register(COShopNameHeadView.self, forHeaderFooterViewReuseIdentifier: "COShopNameHeadView")
        if #available(iOS 11, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    
    // 数据源...<运费规则列表>
    @objc var dataList = [COFrightRuleData]() {
        didSet {
            tableview.reloadData()
        }
    }
    
    // 内容高度...<当前默认2/3屏高>
    @objc var contentHeight = SCREEN_HEIGHT * 2 / 3
    
    // cell高度
    @objc var cellHeight = WH(45)
    
    // 父view...<若未赋值，则会使用window>
    @objc var viewParent: UIView!
    
    // 内容标题...<必须赋值>
    @objc var popTitle: String! = "运费规则" {
        didSet {
            if let t = popTitle, t.isEmpty == false {
                viewTop.setTitle(t)
            }
            else {
                viewTop.setTitle("运费规则")
            }
        }
    }
    
    
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        print("COFrightRuleListController deinit~!@")
    }
}


// MARK: - UI
extension COFrightRuleListController {
    // 设置UI
    fileprivate func setupView() {
        setupSubView()
        setupContentView()
    }
    
    // 第一层UI
    fileprivate func setupSubView() {
        view.backgroundColor = UIColor.clear
        
        view.addSubview(viewDismiss)
        viewDismiss.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        view.addSubview(viewContent)
        viewContent.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(-COInputController.getScreenBottomMargin())
            make.height.equalTo(contentHeight)
        }
    }
    
    // 第二层UI
    fileprivate func setupContentView() {
        viewContent.addSubview(viewTop)
        viewContent.addSubview(tableview)
        
        viewTop.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(viewContent)
            make.height.equalTo(WH(55))
        }
        
        tableview.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(viewContent)
            make.top.equalTo(viewTop.snp.bottom)
        }
        tableview.reloadData()
    }
}


// MARK: - EventHandle
extension COFrightRuleListController {
    // 设置事件
    fileprivate func setupAction() {
        // 隐藏
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.view.endEditing(true)
            if strongSelf.view.superview != nil {
                strongSelf.showOrHidePopView(false)
            }
        }).disposed(by: disposeBag)
        viewDismiss.addGestureRecognizer(tapGesture)
    }
}


// MARK: - Public
extension COFrightRuleListController {
    // 显示or隐藏弹出视图
    @objc func showOrHidePopView(_ show: Bool) {
        // 底部margin
        let margin = COInputController.getScreenBottomMargin()
        
        if show {
            // 显示
            if let viewP = viewParent {
                viewP.addSubview(view)
                view.snp.makeConstraints({ (make) in
                    make.edges.equalTo(viewP)
                })
            }
            else {
                let window = UIApplication.shared.keyWindow
                window?.addSubview(view)
                view.snp.makeConstraints({ (make) in
                    make.edges.equalTo(window!)
                })
            }
            
            viewContent.snp.updateConstraints({ (make) in
                make.bottom.equalTo(view).offset(contentHeight + margin)
            })
            view.layoutIfNeeded()
            viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.0)
            UIView.animate(withDuration: 0.3, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.6)
                strongSelf.viewContent.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(strongSelf.view).offset(-margin)
                })
                strongSelf.view.layoutIfNeeded()
            }, completion: { (_) in
                //
            })
        }
        else {
            // 隐藏
            UIView.animate(withDuration: 0.3, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.0)
                strongSelf.viewContent.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(strongSelf.view).offset(strongSelf.contentHeight + margin)
                })
                strongSelf.view.layoutIfNeeded()
            }, completion: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.view.removeFromSuperview()
            })
        }
    }
}


// MARK: - UITableViewDelegate
extension COFrightRuleListController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard dataList.count > 0 else {
            return 0
        }
        let item: COFrightRuleData = dataList[section]
        guard let list = item.freightRuleList, list.count > 0 else {
            return 0
        }
        return list.count
    }
    
    // 动态高度，故不需要当前方法
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        // 固定高度
//        return cellHeight
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard dataList.count > 0 else {
            return UITableViewCell.init(style: .default, reuseIdentifier: "error")
        }
        let item: COFrightRuleData = dataList[indexPath.section]
        guard let list = item.freightRuleList, list.count > 0, list.count > indexPath.row else {
            return UITableViewCell.init(style: .default, reuseIdentifier: "error")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "COFrightRuleCell", for: indexPath) as! COFrightRuleCell
        // 配置cell
        cell.configCell(list[indexPath.row])
        cell.selectionStyle = .default
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //return CGFloat.leastNormalMagnitude
        return WH(40)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //return nil

        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "COShopNameHeadView") as! COShopNameHeadView
        let item: COFrightRuleData = dataList[section]
        let content = "\(section+1)" + ". " + (item.shopName ?? "")
        view.configView(content)
        //view.configView(item.shopName)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        //return CGFloat.leastNormalMagnitude
        return WH(10)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        //return nil
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(12)))
        view.backgroundColor = RGBColor(0xF4F4F4)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

