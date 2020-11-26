//
//  RIEnterpriseListController.swift
//  FKY
//
//  Created by 夏志勇 on 2019/8/16.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  企业名称实时联想界面

import UIKit

class RIEnterpriseListController: UIViewController {
    //MARK: - Property
    
    // cell类型...<默认为企业名称>
    var cellType: RITextInputType = .enterpriseName
    // 上个界面传递过来的企业名称
    var enterpriseName: String?
    
    // 回调block
    var selectEnterpriseClosure: ( (String?)->() )?
    var inputTextClosure: ( (String?)->() )?
    
    // 数据源
    fileprivate var searchList = [String]()
    // 之前的搜索名称
    fileprivate var lastName: String?
    
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
    
    // 顶部提示视图...<置顶>
//    fileprivate lazy var viewTip: RITopTipView = {
//        let view = RITopTipView.init(frame: CGRect.zero)
//        view.configView("企业名称请与营业执照保持一致，否则卖家会拒绝为您发货")
//        return view
//    }()
    fileprivate lazy var viewTip: FKYTipsUIView = {
        let view: FKYTipsUIView = FKYTipsUIView(frame: CGRect.zero)
        view.setTipsContent("特别提醒：企业名称请一定要和营业执照上的名称一致，如果不一致，供应商会拒绝为您发货！", numberOfLines: 2)
        return view
    }()
    
    // 输入视图
    fileprivate lazy var viewInput: RISearchView = {
        let view = RISearchView()
        // 输入框文字改变中
        view.changeText = { [weak self] (keyword) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.requestForEnterpriseSearch(keyword)
        }
        // 输入框编辑完成
//        view.endEditing = { [weak self] in
//            guard let strongSelf = self else {
//                return
//            }
//            guard let block = strongSelf.inputTextClosure else {
//                return
//            }
//            let txt = strongSelf.viewInput.getContent()
//            block(txt)
//        }
        return view
    }()
    
    // 列表
    fileprivate lazy var tableview: UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.backgroundView = nil
        table.backgroundColor = .clear
        table.separatorStyle = .singleLine
        table.separatorColor = RGBColor(0xE5E5E5) // 分隔线颜色
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = UITableView.automaticDimension // 设置高度自适应
        table.estimatedRowHeight = WH(46) // 预设高度
        table.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(10)))
        table.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(10)))
        table.register(RIEnterpriseNameCell.self, forCellReuseIdentifier: "RIEnterpriseNameCell")
        table.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        if #available(iOS 11, *) {
            table.contentInsetAdjustmentBehavior = .never
        }
        return table
    }()
    
    
    //MARK: - UI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        setupData()
        setupRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 在当前方法中显示时键盘顶部视图背景色会有一个变化~!@
        //viewInput.showKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewInput.showKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        print("RIEnterpriseListController deinit~!@")
    }
}


// MARK: - UI
extension RIEnterpriseListController {
    // UI绘制
    fileprivate func setupView() {
        setupNavigationBar()
        setupContentView()
    }
    
    // 导航栏
    fileprivate func setupNavigationBar() {
        // 标题
        fky_setupTitleLabel("填写企业名称")
        // 分隔线
        fky_hiddedBottomLine(false)
        
        // 返回
        fky_setupLeftImage("icon_back_new_red_normal") {
            FKYNavigator.shared().pop()
        }
        
        // 保存
        fky_setupRightImage("") {
            self.view.endEditing(true)
            if let block = self.inputTextClosure {
                let txt = self.viewInput.getContent()
                block(txt)
            }
            FKYNavigator.shared().pop()
        }
        self.NavigationBarRightImage!.setTitle("保存", for: UIControl.State())
        self.NavigationBarRightImage!.fontTuple = t19
        self.NavigationBarRightImage!.setTitleColor(UIColor.init(red: 113.0/255, green: 0, blue: 0, alpha: 1), for: .highlighted)
    }
    
    // 内容视图
    fileprivate func setupContentView() {
        view.backgroundColor = RGBColor(0xF4F4F4)
        
        var margin: CGFloat = 0
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                // iPhone X
                margin = iPhoneX_SafeArea_BottomInset
            }
        }
        
        // 顶部提示视图
        view.addSubview(viewTip)
        viewTip.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(self.navBar!.snp.bottom)
            //make.height.equalTo(WH(32))
        }
        
        // 输入视图
        view.addSubview(viewInput)
        viewInput.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(viewTip.snp.bottom)
            make.height.equalTo(WH(56))
        }
        
        // 中间列表视图
        view.addSubview(tableview)
        tableview.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(-margin)
            make.top.equalTo(viewInput.snp.bottom)
        }
        tableview.reloadData()
    }
}


// MARK: - Data

extension RIEnterpriseListController {
    //
    fileprivate func setupData() {
        viewInput.configView(cellType, enterpriseName)
        //viewInput.showKeyboard()
    }
}


// MARK: - Request

extension RIEnterpriseListController {
    //
    fileprivate func setupRequest() {
        // 请求经营范围
        requestForEnterpriseSearch(enterpriseName)
    }
    
    // 搜索
    fileprivate func requestForEnterpriseSearch(_ name: String?) {
        guard let searchKey = name, searchKey.isEmpty == false else {
            searchList.removeAll()
            tableview.reloadData()
            return
        }
        
        // 若当前搜索关键词与上次搜索关键词相同，则不重复调接口搜索
        if let last = lastName, last.isEmpty == false, searchKey == last {
            return
        }
        
        // 保存当前搜索关键词
        lastName = searchKey
        
        // 清空
        searchList.removeAll()
        tableview.reloadData()
        
        //showLoading()
        RITextViewModel.requestForEnterpriseNameFromErp(searchKey) { [weak self] (success, msg, data) in
            guard let strongSelf = self else {
                return
            }
            //strongSelf.dismissLoading()
            if success {
                print("查询成功")
                if let list: [String] = data as? [String], list.count > 0 {
                    strongSelf.searchList.append(contentsOf: list)
                }
            }
            else {
                print("查询失败")
                //strongSelf.toast(msg)
            }
            // 刷新
            strongSelf.tableview.reloadData()
        }
    }
}


// MARK: - UIScrollViewDelegate
extension RIEnterpriseListController: UIScrollViewDelegate {
    //
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}


// MARK: - UITableViewDelegate

extension RIEnterpriseListController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return WH(46)
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RIEnterpriseNameCell", for: indexPath) as! RIEnterpriseNameCell
        cell.configCell(searchList[indexPath.row], viewInput.getContent())
        return cell
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
        // select
        self.view.endEditing(true)
        FKYNavigator.shared().pop()
        if let block = selectEnterpriseClosure {
            block(searchList[indexPath.row])
        }
    }
}
