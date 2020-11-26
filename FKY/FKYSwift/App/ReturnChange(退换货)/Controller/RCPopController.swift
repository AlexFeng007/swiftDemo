//
//  RCPopController.swift
//  FKY
//
//  Created by 夏志勇 on 2018/11/22.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  (回寄信息之)选择快递公司 & (退货之)申请原因

import UIKit

// pop类型
enum RCPopType: Int {
    case sendCompanyList = 0    // 快递公司列表...<退换货>
    case applyReason = 1        // 申请原因...<退换货>
    case applyProductList = 2   // 申请商品列表...<退换货>
    case complainTypeList = 3   // 投诉类型...<买家投诉>
    case showGiftList = 6       // 展示当前商家订单中的赠品列表...<检查订单>
}


class RCPopController: UIViewController {
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
        view.backgroundColor = UIColor.white
        return view
    }()
    // 顶部视图...<标题、关闭>
    fileprivate lazy var viewTop: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    // 列表...<快递公司 or 申请原因 or 商品列表>
    fileprivate lazy var tableview: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.separatorStyle = .none
        if self.popType == .sendCompanyList || self.popType == .applyReason {
            // 快递公司列表 or 申请原因
            view.tableHeaderView = {
                let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(12)))
                view.backgroundColor = .white
                return view
            }()
            view.tableFooterView = {
                let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(12)))
                view.backgroundColor = .white
                return view
            }()
        }
        else {
            // 申请商品列表 & 其它
            view.tableHeaderView = UIView.init(frame: CGRect.zero)
            view.tableFooterView = UIView.init(frame: CGRect.zero)
        }
        view.register(RCPopCell.self, forCellReuseIdentifier: "RCPopCell")
        view.register(RCDProductListCell.self, forCellReuseIdentifier: "RCDProductListCell")
        view.register(COProductItemCell.self, forCellReuseIdentifier: "COProductItemCell")
        view.register(COFrightRuleCell.self, forCellReuseIdentifier: "COFrightRuleCell")
        if #available(iOS 11, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    // 底部视图...<确定>
    fileprivate lazy var viewBottom: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(64)))
        view.backgroundColor = RGBColor(0xF7F7F7)
        // 按钮
        view.addSubview(self.btnDone)
        self.btnDone.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsets(top: WH(12), left: WH(30), bottom: WH(9), right: WH(30)))
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
        btn.setTitle("确定", for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(3)
        btn.setBackgroundImage(imgNormal, for: .normal)
        btn.setBackgroundImage(imgSelect, for: .highlighted)
        btn.setBackgroundImage(imgDisable, for: .disabled)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.doneAction()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.text = "请选择"
        lbl.textColor = RGBColor(0x000000)
        lbl.font = UIFont.systemFont(ofSize: WH(17))
        lbl.textAlignment = .center
        return lbl
    }()
    
    // 数据源...<可以是上个界面传递过来的，也可以是当前界面实时请求的>
    var dataList = [Any]()
    
    // 当前默认选择索引...<默认无选中>
    var selectedIndex = -1
    
    // 界面类型
    var popType: RCPopType = .sendCompanyList
    
    // 内容高度...<当前默认2/3屏高>
    var contentHeight = SCREEN_HEIGHT * 2 / 3
    
    // cell高度
    var cellHeight = WH(45)
    
    // 是否显示底部确定按钮...<默认显示>
    var showBtn = true
    
    // 是否由当前VC自已来请求数据
    var requestBySelf = true
    
    // 父view...<若未赋值，则会使用window>
    var viewParent: UIView!
    
    // 内容标题...<必须赋值>
    var popTitle: String! = "请选择" {
        didSet {
            if let t = popTitle, t.isEmpty == false {
                lblTitle.text = t
            }
            else {
                lblTitle.text = "请选择"
            }
        }
    }
    
    // closure
    var selectItemBlock: ((Any, Int)->())? // 选择完回调
    
    
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dataList.count == 0 {
            // 无数据时需要刷新
            setupRequest()
        }
        else {
            // 有数据
            if selectedIndex >= 0, selectedIndex < dataList.count {
                tableview.scrollToRow(at: IndexPath.init(row: selectedIndex, section: 0), at: .none, animated: false)
                tableview.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 每次显示时均重置
//        tableview.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
//        tableview.reloadData()
    }
    
    deinit {
        print("RCPopController deinit")
    }
}

// MARK: - UI
extension RCPopController {
    // 设置UI
    fileprivate func setupView() {
        setupSubView()
        setupContentView()
        setupTopView()
    }
    
    // 第一层UI
    fileprivate func setupSubView() {
        view.backgroundColor = UIColor.clear
        
        view.addSubview(viewDismiss)
        viewDismiss.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        var margin: CGFloat = 0.0
        if #available(iOS 11, *) {
            // >= iOS 11
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                // iPhone X
                margin = (insets?.bottom)!
            }
        }
        
        view.addSubview(viewContent)
        viewContent.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(-margin)
            make.height.equalTo(contentHeight)
        }
    }
    
    // 第二层UI
    fileprivate func setupContentView() {
        viewContent.addSubview(viewTop)
        viewContent.addSubview(viewBottom)
        viewContent.addSubview(tableview)
        
        viewTop.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(viewContent)
            make.height.equalTo(WH(55))
        }
        
        viewBottom.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(viewContent)
            make.height.equalTo(WH(64))
        }
        
        tableview.snp.makeConstraints { (make) in
            make.left.right.equalTo(viewContent)
            make.top.equalTo(viewTop.snp.bottom)
            make.bottom.equalTo(viewBottom.snp.top)
        }
        
        if !showBtn {
            // 不显示底部确定按钮
            viewBottom.isHidden = true
            viewBottom.snp.updateConstraints { (make) in
                make.bottom.equalTo(viewContent).offset(WH(64))
            }
        }
    }
    
    // 第三层UI
    fileprivate func setupTopView() {
        // 标题
        lblTitle.text = popTitle
        viewTop.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { (make) in
            make.center.equalTo(viewTop)
        }
        
        // 关闭
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.backgroundColor = UIColor.clear
        btn.alpha = 0.8
        btn.setImage(UIImage.init(named: "btn_pd_group_close"), for: .normal)
        btn.rx.tap.bind(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.view.superview != nil {
                strongSelf.showOrHidePopView(false)
            }
        }).disposed(by: disposeBag)
        self.viewTop.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.viewTop)
            make.left.equalTo(self.viewTop)
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(50))
        }
        
        // 分隔线
        let viewLine = UIView.init(frame: CGRect.zero)
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        viewTop.addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(viewTop)
            make.height.equalTo(0.5)
        }
    }
}

// MARK: - EventHandle
extension RCPopController {
    // 设置事件
    fileprivate func setupAction() {
        // 隐藏
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.view.superview != nil {
                strongSelf.showOrHidePopView(false)
            }
        }).disposed(by: disposeBag)
        viewDismiss.addGestureRecognizer(tapGesture)
    }
    
    // 确定
    fileprivate func doneAction() {
        switch popType {
        case .sendCompanyList, .applyReason, .complainTypeList:
            // 快递公司列表 or 申请原因 or 投诉类型
            guard dataList.count > 0 else {
                return
            }
            guard selectedIndex >= 0, selectedIndex < dataList.count else {
                toast("请选择")
                return
            }
            guard let block = selectItemBlock else {
                return
            }
            // 回传选中model
            block(dataList[selectedIndex], selectedIndex)
            // 隐藏
            showOrHidePopView(false)
        case .applyProductList:
            // 申请商品列表
            print("无此操作!!!")
        case .showGiftList:
            // 赠品列表
            print("无此操作!!!")
        }
    }
    
    // 选择
    fileprivate func selectAction(_ index: Int) {
        switch popType {
        case .sendCompanyList, .applyReason, .complainTypeList:
            // 快递公司列表 or 申请原因 or 投诉类型
            selectedIndex = index
        case .applyProductList:
            // 申请商品列表
            print("进商详???")
        case .showGiftList:
            // 赠品列表
            print("无此操作!!!")
        }
        tableview.reloadData()
    }
}


// MARK: - Request
extension RCPopController {
    // 接口请求配置
    fileprivate func setupRequest() {
        // 当前界面不请求数据，由上个界面传递数据源
        guard requestBySelf else {
            return
        }
        
        switch popType {
        case .sendCompanyList:
            // 快递公司列表
            requestSendCompanyList()
        case .applyReason:
            // 申请原因
            requestApplyReason()
        case .applyProductList:
            // 申请商品列表
            requestApplyProductList()
        case .complainTypeList:
            // 投诉类型
            requestComplainList()
        case .showGiftList:
            // 赠品列表
            print("无此操作!!!")
        }
    }
    
    // 请求退换货之快递公司列表
    fileprivate func requestSendCompanyList() {
        showLoading()
        FKYRequestService.sharedInstance()?.requestForSendCompanyList(withParam: nil, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            guard success else {
                // 失败
                var msg = error?.localizedDescription ?? "请求数据失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                strongSelf.toast(msg)
                return
            }
            // 成功
            if let list = model, (list as AnyObject).isKind(of:NSArray.self) {
                strongSelf.dataList = list as! [RCSendCompanyModel]
                strongSelf.tableview.reloadData()
            }
            else {
                strongSelf.toast("暂无数据")
            }
        })
    }
    
    // 请求退换货之申请原因
    fileprivate func requestApplyReason() {
        showLoading()
        let param = ["type": "8"] // type:8 退换货类型
        FKYRequestService.sharedInstance()?.requestForApplyReasonList(withParam: param, completionBlock: { [weak self] (success, error, response, model) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            guard success else {
                // 失败
                var msg = error?.localizedDescription ?? "请求数据失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                strongSelf.toast(msg)
                return
            }
            // 成功
            if let list = model, (list as AnyObject).isKind(of:NSArray.self) {
                strongSelf.dataList = list as! [RCApplyReasonModel]
                strongSelf.tableview.reloadData()
            }
            else {
                strongSelf.toast("暂无数据")
            }
        })
    }
    
    // 请求退换货之申请商品列表
    fileprivate func requestApplyProductList() {
        //
    }
    
    // 显示投诉类型
    fileprivate func requestComplainList() {
        self.tableview.reloadData()
    }
}

// MARK: - Public
extension RCPopController {
    // 显示or隐藏弹出视图
    func showOrHidePopView(_ show: Bool) {
        var margin: CGFloat = 0.0
        if #available(iOS 11, *) {
            // >= iOS 11
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                // iPhone X
                margin = (insets?.bottom)!
            }
        }
        
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
                strongSelf.viewContent.snp.updateConstraints({[weak self] (make) in
                    guard let strongSelf = self else {
                        return
                    }
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
                strongSelf.viewContent.snp.updateConstraints({[weak self] (make) in
                    guard let strongSelf = self else {
                        return
                    }
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
    
    // 滑到选中项
    func showSelectedItem(_ index: Int) {
        selectedIndex = index
        tableview.reloadData()
        guard dataList.count > 0 else {
            return
        }
        if selectedIndex >= 0, selectedIndex < dataList.count {
            tableview.scrollToRow(at: IndexPath.init(row: selectedIndex, section: 0), at: .none, animated: false)
        }
        else {
            tableview.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .none, animated: false)
        }
    }
    
    // 根据不同界面设计要求，对部分UI样式进行更新
    func updateViewStyle() {
        viewBottom.backgroundColor = RGBColor(0xFFFFFF)
        lblTitle.font = UIFont.boldSystemFont(ofSize: WH(18))
    }
}

// MARK: - UITableViewDelegate
extension RCPopController: UITableViewDelegate, UITableViewDataSource {
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
        switch popType {
        case .sendCompanyList, .applyReason, .complainTypeList:
            // 快递公司列表 or 申请原因 or 投诉类型
            let cell = tableView.dequeueReusableCell(withIdentifier: "RCPopCell", for: indexPath) as! RCPopCell
            // 配置cell
            cell.configCell(dataList[indexPath.row])
            // 是否选中
            cell.setSelectedStatus(indexPath.row == selectedIndex)
            // 底部分隔线设置
            cell.showBottomLine(indexPath.row == dataList.count - 1 ? false : true)
            // 点击btn后选中
            cell.selectBlock = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.selectAction(indexPath.row)
            }
            cell.selectionStyle = .default
            return cell
        case .applyProductList:
            // 申请商品列表
            let cell = tableView.dequeueReusableCell(withIdentifier: "RCDProductListCell", for: indexPath) as! RCDProductListCell
            // 配置cell
            cell.configCell(dataList[indexPath.row])
            // 底部分隔线设置
            //cell.showBottomLine(indexPath.row == dataList.count - 1 ? false : true)
            // 顶部分隔线设置
            cell.showTopLine(indexPath.row == 0 ? true : false)
            cell.selectionStyle = .default
            return cell
        case .showGiftList:
            // 赠品列表
            let cell = tableView.dequeueReusableCell(withIdentifier: "COFrightRuleCell", for: indexPath) as! COFrightRuleCell
            // 配置cell
            cell.configCell(dataList[indexPath.row] as? String)
            // 底部分隔线设置
            cell.showBottomLine(indexPath.row == dataList.count - 1 ? false : true)
            cell.backgroundColor = .white
            cell.selectionStyle = .default
            return cell
        }
        
        //return UITableViewCell.init(style: .default, reuseIdentifier: "default")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 点击选中
        selectAction(indexPath.row)
    }
}
