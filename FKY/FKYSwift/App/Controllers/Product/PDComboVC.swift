//
//  PDComboVC.swift
//  FKY
//
//  Created by 夏志勇 on 2018/3/28.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  商详之(搭配or固定)套餐VC...<弹出界面>
//  特性：支持多套餐，支持混合类型套餐

import UIKit

typealias jumpToProductDetailClosure = (_ product: FKYProductGroupItemModel?,_ indexRow:Int,_ groupIndex:Int,_ groupName:String,_ maxBuyNum:Int)->()

typealias addProductGroupClosure = (_ group: FKYProductGroupModel?, _ index: Int)->()

var FOOT_ADD_VIEW_H = WH(98)

@objc
class PDComboVC: UIViewController {
    //MARK: - Property
    
   // @objc var groupName:String = "" //套餐名字
    @objc var supplyID:String = "" //供应商ID
    @objc var spucode:String = "" //商品spucode
    // 响应视图
    fileprivate lazy var viewDismiss: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    // 内容视图...<包含所有内容的容器视图>
    fileprivate lazy var viewContent: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    // 顶部视图...<标题、关闭>
    fileprivate lazy var viewTop: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    // 标题视图...<套餐标题>
    fileprivate lazy var viewTitle: PDGroupTitleView! = {
        let view = PDGroupTitleView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.white
        // 切换套餐
        view.changeIndexCallback = { [unowned self] (groupIndex: Int) -> Void in
            // 保存当前选中套餐索引
            self.groupIndex = groupIndex
            // 切换套餐
            self.scrollview.setContentOffset(CGPoint.init(x: SCREEN_WIDTH * CGFloat(groupIndex), y: 0), animated: true)
            // 更新价格
            self.showGroupPrice()
            // 更新底部操作栏分隔线样式
            self.updateBottomViewTopLine()
             
            let pageValue =  "\(self.supplyID)" + "|" + "\(self.spucode)"
            let extendParams:[String :AnyObject] = ["pageValue" :pageValue   as AnyObject]
            var sectionName = ""
            if let groups = self.arrayGroup, groups.count > 0 {
            // 有套餐数据
               let titleArray = self.getGroupTitles(groups)
               if titleArray.count > self.groupIndex {
                sectionName = titleArray[self.groupIndex] as! String
                }
            }
            //埋点
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: "套餐详情弹窗", sectionId: "S6108", sectionPosition: "\(self.groupIndex+1)", sectionName: sectionName , itemId: "I6108", itemPosition: "0", itemName: "套餐\(self.groupIndex+1)tab", itemContent: nil, itemTitle: nil, extendParams: extendParams, viewController: UIApplication.shared.keyWindow?.currentViewController)
        }
        return view
    }()
    
    // 底部视图...<加车>
    fileprivate lazy var viewBottom: PDGroupBottomView! = {
        let view = PDGroupBottomView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.white
        // (套餐)加车
        view.addCartCallback = { [unowned self] (_ group: FKYProductGroupModel?) -> Void in
            if let closure = self.addGroupCallback {
                closure(group, self.groupIndex)
            }
        }
        return view
    }()
    
    // 中间套餐容器视图
    fileprivate lazy var scrollview: UIScrollView! = {
        let view = UIScrollView.init(frame: CGRect.zero)
        view.backgroundColor = RGBColor(0xf5f5f5)
        view.delegate = self
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    // 套餐展示相关数据
    fileprivate var arrayTables = [UITableView]() // tableview数组
    fileprivate var arrayHeaders = [PDGroupTipView]() // tableHeaderview数组
    fileprivate var arrayFooters = [PDFixedGroupNumberView]() // tableFooterview数组
    fileprivate var groupIndex: Int = 0 // 默认选中第0个套餐
    
    // 商详界面传递过来的相关数据~!@
    @objc var arrayGroup: Array<FKYProductGroupModel>? // 套餐数据源
    
    // 商详view...<必须赋值，否则会使用window>
    @objc var viewPd: UIView!
    
    // 固定套餐是否已弹出
    @objc var viewShowFlag: Bool = false
    
    // closure
    @objc var showProductDetailCallback: jumpToProductDetailClosure? // 查看商详
    @objc var addGroupCallback: addProductGroupClosure? // 套餐加车
    
    
    //MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupView()
        self.setupData()
        self.setupAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("...>>>>>>>>>>>>>>>>>>>>>...PDComboVC deinit~!@")
    }
    
    
    //MARK: - SetupView
    
    func setupView() {
        self.setupSubview()
        self.setupContentView()
        self.setupTopView()
    }
    
    // 设置整体子容器视图
    func setupSubview() {
        self.view.backgroundColor = UIColor.clear
        
        self.view.addSubview(self.viewDismiss)
        self.viewDismiss.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        let height: CGFloat = getContentHeight()
        self.view.addSubview(self.viewContent)
        self.viewContent.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self.view)
            make.height.equalTo(height)
        }
    }
    
    // 设置内容(容器)视图
    func setupContentView() {
        //
        self.viewContent.addSubview(self.viewTop)
        self.viewContent.addSubview(self.viewBottom)
        self.viewContent.addSubview(self.viewTitle)
        self.viewContent.addSubview(self.scrollview)
        
        // 顶部（关闭）视图
        self.viewTop.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.viewContent)
            make.height.equalTo(WH(50))
        }
        
        // 底部（加车）视图
        self.viewBottom.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.viewContent)
            make.bottom.equalTo(self.viewContent).offset(-bootSaveHeight())
            make.height.equalTo(WH(68))
        }
        
        // 中间套餐切换视图
        self.viewTitle.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.viewContent)
            make.top.equalTo(self.viewTop.snp.bottom)
            make.height.equalTo(WH(44))
        }
        
        // 套餐容器视图
        self.scrollview.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.viewContent)
            make.top.equalTo(self.viewTitle.snp.bottom)
            make.bottom.equalTo(self.viewBottom.snp.top)
        }
    }
    
    // 设置顶部视图
    func setupTopView() {
        // 标题
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.text = "选择套餐"
        lbl.textColor = RGBColor(0x333333)
        lbl.font = UIFont.boldSystemFont(ofSize: WH(17))
        lbl.textAlignment = .center
        self.viewTop.addSubview(lbl)
        lbl.snp.makeConstraints { (make) in
            make.center.equalTo(self.viewTop)
        }
        
        // 关闭
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.backgroundColor = UIColor.clear
        btn.alpha = 0.8
        //btn.setImage(UIImage.init(named: "icon_account_close"), for: .normal)
        btn.setImage(UIImage.init(named: "btn_pd_group_close"), for: .normal)
        btn.rx.tap.bind(onNext: { [weak self] in
            if self?.view.superview != nil {
                //埋点
             //   FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: "套餐详情弹窗", sectionId: "S6108", sectionPosition: "1", sectionName: nil, itemId: "I6108", itemPosition: "1", itemName: nil, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: UIApplication.shared.keyWindow?.currentViewController)
                self?.showOrHideGroupPopView(false)
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
        self.viewTop.addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.viewTop)
            make.height.equalTo(0.5)
        }
    }
    
    
    //MARK: - SetupData
    
    func setupData() {
        self.showGroupTitle()
        self.showGroupTip()
        self.showGroupNumber()
        self.showGroupContent()
        self.showGroupPrice()
        self.updateBottomViewTopLine()
    }
    
    
    //MARK: - SetupAction
    
    func setupAction() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            if self?.view.superview != nil {
                self?.showOrHideGroupPopView(false)
            }
        }).disposed(by: disposeBag)
        viewDismiss.addGestureRecognizer(tapGesture)
    }
    
    
    //MARK: - Public
    
    // 显示or隐藏套餐弹出视图
    @objc func showOrHideGroupPopView(_ show: Bool) {
        // 保存显示or隐藏状态
        viewShowFlag = show
        
        let height: CGFloat = getContentHeight()
        if show {
            // 显示
            if viewPd == nil {
                let window = UIApplication.shared.keyWindow
                window?.addSubview(self.view)
                self.view.snp.makeConstraints({ (make) in
                    make.edges.equalTo(window!)
                })
            }
            else {
                viewPd.addSubview(self.view)
                self.view.snp.makeConstraints({ (make) in
                    make.edges.equalTo(viewPd)
                })
            }
            
            self.viewContent.snp.updateConstraints({ (make) in
                make.bottom.equalTo(self.view).offset(height)
            })
            self.view.layoutIfNeeded()
            self.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.0)
            UIView.animate(withDuration: 0.3, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.6)
                strongSelf.viewContent.snp.updateConstraints({[weak self] (make) in
                    guard let strongSelf = self else {
                        return
                    }
                    make.bottom.equalTo(strongSelf.view)
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
                    make.bottom.equalTo(strongSelf.view).offset(height)
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
    
    // 直接显示指定索引处的套餐信息
    @objc func showCurrentComboForIndex(_ index: Int) {
        if let groups = self.arrayGroup, groups.count > 0, groups.count > index {
            // 有套餐数据
            
            // 保存当前选中套餐索引
            self.groupIndex = index
            // 切换套餐
            self.scrollview.setContentOffset(CGPoint.init(x: SCREEN_WIDTH * CGFloat(groupIndex), y: 0), animated: true)
            // 设置当前选中套餐标题
            self.viewTitle.setSegmentedControlIndex(index)
            // 更新价格
            self.showGroupPrice()
            // 更新底部操作栏分隔线样式
            self.updateBottomViewTopLine()
        }
        else {
            // 无套餐数据
        }
    }
    
    
    //MARK: - Private
    
    // 显示套餐标题列表
    fileprivate func showGroupTitle() {
        if let groups = self.arrayGroup, groups.count > 0 {
            // 有套餐数据
            self.viewTitle.showSegmentedControl4GroupTitle(self.getGroupTitles(groups))
        }
        else {
            // 无套餐数据
        }
    }
    
    // 显示套餐说明列表...<header>
    fileprivate func showGroupTip() {
        if let groups = self.arrayGroup, groups.count > 0 {
            // 有套餐数据
            self.arrayHeaders.removeAll()
            for index in (0..<groups.count) {
                // title
                var tip: NSString?
                if groups[index].useDesc != nil && groups[index].useDesc.isEmpty == false {
                    tip = groups[index].useDesc! as NSString
                }
                // view
                let header: PDGroupTipView = PDGroupTipView.init(frame: CGRect.zero)
                header.tag = index
                header.configView(tip, showFlag: tip != nil ? true : false)
                header.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: header.tipHeight)
                self.arrayHeaders.append(header)
            } // for
        }
        else {
            // 无套餐数据
        }
    }
    
    // 显示套餐数量输入视图列表...<footer>
    // 默认每个套餐底部均有一个footer，但搭配套餐不显示，仅固定套餐显示
    fileprivate func showGroupNumber() {
        if let groups = self.arrayGroup, groups.count > 0 {
            // 有套餐数据
            self.arrayFooters.removeAll()
            for index in (0..<groups.count) {
                // 指定索引处的套餐数据
                let item: FKYProductGroupModel = groups[index]
                // view
                let footer = PDFixedGroupNumberView.init(frame: CGRect.zero)
                footer.tag = index
                footer.backgroundColor = RGBColor(0xffffff)
                footer.configView(groups[index], index)
                footer.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: FOOT_ADD_VIEW_H)
                // 加
                footer.addCallback = { [unowned self] (currentCount: Int) -> Void in
                    // 更新数量
                    item.setNumberForAdd(currentCount)
                    // 更新显示数量
                    footer.updateGroupNumber(item.groupNumber)
                    self.updateFixedComboProductNumber(index)
                    // 更新价格
                    self.updateCurrentGroupPrice(item)
                }
                // 减
                footer.minusCallback = { [unowned self] (currentCount: Int) -> Void in
                    // 更新数量
                    item.setNumberForMinus(currentCount)
                    // 更新显示数量
                    footer.updateGroupNumber(item.groupNumber)
                    self.updateFixedComboProductNumber(index)
                    // 更新价格
                    self.updateCurrentGroupPrice(item)
                }
                // 输入检测
                footer.validateTextinputCallback = { [unowned self] (currentCount: Int) -> Void in
                    // 固定套餐
                    if let type = item.promotionRule, type.intValue == 2 {
                        // 超过最大加车数量时给出提示...<仅针对固定套餐>
                        let max = item.getMaxGroupNumber()
                        if max < currentCount {
                            // 延迟0.5s后提示...<带键盘及键盘消失过程中弹toast时，toast显示时长太短>
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {[weak self] in
                                guard let strongSelf = self else {
                                    return
                                }
                                if let num = item.maxBuyNumPerDay,num.intValue > 0 {
                                     strongSelf.toast("您每天最多购买\(max)套，暂时无法购买")
                                }else {
                                    strongSelf.toast("超出最大可售数量，最多只能买" + "\(max)")
                                }
                            }
                        }
                    }
                    // 更新数量
                    item.checkNumber(forInput: currentCount)
                    // 更新显示数量
                    footer.updateGroupNumber(item.groupNumber)
                    self.updateFixedComboProductNumber(index)
                    // 更新价格
                    self.updateCurrentGroupPrice(item)
                }
                // 实时更新
                footer.updateRealTimeCallback = { [unowned self] (currentCount: Int, msg: String?) -> Void in
                    // 更新数量
                    item.checkNumber(forInput: currentCount)
                    // 更新显示数量
                    footer.updateGroupNumber(item.groupNumber)
                    self.updateFixedComboProductNumber(index)
                    // 更新价格
                    self.updateCurrentGroupPrice(item)
                    // toast
                    if let str = msg, str.isEmpty == false {
                        // 有msg，说明用户输入数量超过规定值，需提示
                        if let num = item.maxBuyNumPerDay,num.intValue > 0 {
                            self.toast("您每天最多购买\(currentCount)套，暂时无法购买")
                        }else {
                            self.toast(str)
                        }
                    }
                }
                self.arrayFooters.append(footer)
            } // for
        }
        else {
            // 无套餐数据
        }
    }
    
    // 显示套餐内容列表
    fileprivate func showGroupContent() {
        // scrollview高度
        let height: CGFloat = getContentHeight() - WH(50) - WH(68) - WH(44) - bootSaveHeight()
        
        if let groups = self.arrayGroup, groups.count > 0 {
            // 有套餐数据
            if #available(iOS 13.7, *) {
                self.scrollview.contentSize = CGSize.init(width: SCREEN_WIDTH * CGFloat(groups.count), height: 0)
            }else{
                self.scrollview.contentSize = CGSize.init(width: SCREEN_WIDTH * CGFloat(groups.count), height: height)
            }

            self.arrayTables.removeAll()
            for index in (0..<groups.count) {
                // 当前索引处的套餐model
                let item: FKYProductGroupModel = groups[index]
                // 套餐内容高度
                var tableHeight = height
                // 固定套餐底部加车视图
                let footer = self.arrayFooters[index]
                // 当前索引处的套餐table
                var tableStyle: UITableView.Style = .grouped // 默认搭配套餐样式
                if let type = item.promotionRule, type.intValue == 2 {
                    // 固定套餐
                    tableStyle = .plain
                    tableHeight = tableHeight - FOOT_ADD_VIEW_H
                    footer.frame = CGRect.init(x: SCREEN_WIDTH * CGFloat(index), y: tableHeight, width: SCREEN_WIDTH, height: FOOT_ADD_VIEW_H)
                    self.scrollview.addSubview(footer)
                }
                else {
                    // 搭配套餐
                }
                let table: UITableView = UITableView.init(frame: CGRect.init(x: SCREEN_WIDTH * CGFloat(index), y: 0, width: SCREEN_WIDTH, height: tableHeight), style: tableStyle)
                table.tag = index
                table.delegate = self
                table.dataSource = self
                table.backgroundColor = UIColor.clear
                table.showsVerticalScrollIndicator = false
                table.estimatedRowHeight = WH(126+8+18) // cell高度动态自适应
                table.rowHeight = UITableView.automaticDimension
                table.separatorStyle = UITableViewCell.SeparatorStyle.none
                if self.arrayHeaders.count == groups.count {
                    // add header
                    table.tableHeaderView = self.arrayHeaders[index]
                }
                else {
                    table.tableHeaderView = UIView.init(frame: CGRect.zero)
                }
//                if self.arrayFooters.count == groups.count {
//                    // add footer
//                    if let type = item.promotionRule, type.intValue == 2 {
//                        // 仅固定套餐才显示
//                        table.tableFooterView = self.arrayFooters[index]
//                    }
//                    else {
//                        // 非固定套餐不显示
//                        table.tableFooterView = UIView.init(frame: CGRect.zero)
//                    }
//                }
//                else {
//                    table.tableFooterView = UIView.init(frame: CGRect.zero)
//                }
                table.tableFooterView = UIView.init(frame: CGRect.zero)
                table.register(PDGroupItemCell.self, forCellReuseIdentifier: "PDGroupItemCell")
                table.register(PDFixedGroupItemCell.self, forCellReuseIdentifier: "PDFixedGroupItemCell")
                self.scrollview.addSubview(table)
                self.arrayTables.append(table)
            } // for
        }
        else {
            // 无套餐数据
            self.scrollview.contentSize = CGSize.init(width: SCREEN_WIDTH, height: height)
        }
    }
    
    // 显示当前选中套餐的价格
    fileprivate func showGroupPrice() {
        if let groups = self.arrayGroup, groups.count > 0 {
            // 有套餐数据
            self.viewBottom.isHidden = false
            
            print("current group index: \(self.groupIndex)")
            
            if self.groupIndex >= groups.count {
                self.groupIndex = 0
            }
            
            // 显示or更新当前套餐价格
            self.updateCurrentGroupPrice(groups[self.groupIndex])
        }
        else {
            // 无套餐数据
            self.viewBottom.isHidden = true
        }
    }
    
    // 获取所有套餐名称
    fileprivate func getGroupTitles(_ groupData: Array<FKYProductGroupModel>) -> (NSArray) {
        var arrTitles = [String]()
        for item in groupData {
            if let name = item.promotionName, name.isEmpty == false {
                // 有返回套餐名称
                arrTitles.append(name)
            }
            else {
                // 未返回套餐名称
                //arrTitles.append("套餐")
                var name = "套餐"
                if let type = item.promotionRule {
                    if type.intValue == 1 {
                        name = "搭配套餐"
                    }
                    else if type.intValue == 2 {
                        name = "固定套餐"
                    }
                }
                arrTitles.append(name)
            }
        }
        return arrTitles as (NSArray)
    }
    
    // 更新数据源及对应的展示
    fileprivate func updateGroupData(_ groupIndex: Int, _ indexPath: IndexPath, _ selected: Bool) {
        if self.arrayTables.count > 0, groupIndex < self.arrayTables.count  {
            // 更新Data
            
            // 更新UI
            let table = self.arrayTables[groupIndex]
            table.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    // 切换套餐 or 更新当前套餐时，更新当前价格
    fileprivate func updateCurrentGroupPrice(_ groupItem: FKYProductGroupModel?) {
        if let item = groupItem {
            self.viewBottom.configView(item)
        }
    }
    
    // 更新固定套餐中所有商品数量
    fileprivate func updateFixedComboProductNumber(_ index: Int) {
        if let groups = self.arrayGroup, groups.count == self.arrayTables.count, index < groups.count {
            // 更新Data
            let item: FKYProductGroupModel = groups[index]
            let number = item.getGroupNumber()
            if let list = item.productList, list.count > 0 {
                for tag in 0..<list.count {
                    let product: FKYProductGroupItemModel = list[tag]
                    let baseNumber = product.getBaseNumber()
                    product.inputNumber = baseNumber * number
                } // for
            }
            // 更新UI
            let table = self.arrayTables[index]
            table.reloadData()
        }
    }
    
    // 更新底部操作栏分隔线样式
    fileprivate func updateBottomViewTopLine() {
        if let groups = self.arrayGroup, groups.count > 0 {
            // 有套餐数据
            if self.groupIndex >= groups.count {
                self.groupIndex = 0
            }
            
            let item = groups[self.groupIndex]
            var fixed = false
            if item.productList != nil, item.productList.count > 0 {
                // 当前套餐中包含商品
                if let type = item.promotionRule, type.intValue == 2 {
                    // 固定套餐
                    fixed = true
                }
            }
            self.viewBottom.updateTopLine(!fixed)
        }
        else {
            // 无套餐数据
        }
    }
    
    //
    fileprivate func getContentHeight() -> CGFloat {
        var height: CGFloat = SCREEN_HEIGHT - WH(100)
        return height
    }
}


//MARK: - UIScrollViewDelegate
extension PDComboVC : UIScrollViewDelegate {
    // scrollview滑动结束后更新选中套餐标题
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 只针对scrollview容器，不针对各个子tableview
        if scrollView != self.scrollview {
            return
        }
        
        // 计算当前套餐索引
        let currentIndex = Int(scrollview.contentOffset.x / SCREEN_WIDTH)
        // 保存当前选中套餐索引
        self.groupIndex = currentIndex
        // 设置当前选中套餐标题
        self.viewTitle.setSegmentedControlIndex(currentIndex)
        // 更新价格
        self.showGroupPrice()
        // 更新底部操作栏分隔线样式
        self.updateBottomViewTopLine()
        // 隐藏键盘
        self.view.endEditing(true)
        //埋点
        let pageValue =  "\(self.supplyID)" + "|" + "\(self.spucode)"
        let extendParams:[String :AnyObject] = ["pageValue" :pageValue   as AnyObject]
        var sectionName = ""
        if let groups = self.arrayGroup, groups.count > 0 {
        // 有套餐数据
           let titleArray = self.getGroupTitles(groups)
           if titleArray.count > self.groupIndex {
             sectionName = titleArray[self.groupIndex] as! String
            }
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: "套餐详情弹窗", sectionId: "S6108", sectionPosition: "\(self.groupIndex+1)", sectionName: sectionName, itemId: "I6108", itemPosition: "0", itemName: "套餐\(self.groupIndex+1)tab", itemContent: nil, itemTitle: nil, extendParams: extendParams, viewController: UIApplication.shared.keyWindow?.currentViewController)
    }
}


//MARK: - UITableViewDelegate
extension PDComboVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let groups = self.arrayGroup, groups.count > 0 {
            let tagIndex = tableView.tag // tableview索引
            let item: FKYProductGroupModel = groups[tagIndex] // 指定索引处的套餐数据
            if item.productList != nil, item.productList.count > 0 {
                // 当前套餐中包含商品
                if let type = item.promotionRule, type.intValue == 2 {
                    // 固定套餐
                    return 1
                }
                else {
                    // (统一作为)搭配套餐
                    return 2
                }
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let groups = self.arrayGroup, groups.count > 0 {
            let tagIndex = tableView.tag // tableview索引
            let item = groups[tagIndex] // 指定索引处的套餐数据
            if item.productList != nil, item.productList.count > 0 {
                // 当前套餐中包含商品
                if let type = item.promotionRule, type.intValue == 2 {
                    // 固定套餐
                    return item.productList.count
                }
                else {
                    // (统一作为)搭配套餐
                    if section == 0 {
                        // 主品
                        return 1
                    }
                    else {
                        // 子品
                        return item.productList.count - 1
                    }
                }
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let groups = self.arrayGroup, groups.count > 0 {
            // 获取当前商品model
            let tagIndex = tableView.tag // tableview索引
            let item = groups[tagIndex] // 指定索引处的套餐数据
            
            if let type = item.promotionRule, type.intValue == 2 {
                // 固定套餐
                
                // 当前套餐中的单个商品数据
                let product: FKYProductGroupItemModel = item.productList[indexPath.row]
                // 获取当前商品cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "PDFixedGroupItemCell", for: indexPath) as! PDFixedGroupItemCell
                cell.configCell(product, indexPath)
                // 跳转商详
//                cell.JumpToProductDetailCallback = { [unowned self] () -> Void in
//                    print("closure: JumpToProductDetailCallback")
//                    // 若未给viewPd赋值，则默认使用window。查看商详时，需先popout
//                    if self.viewPd == nil {
//                        self.showOrHideGroupPopView(false)
//                    }
//                    // closure
//                    if let pdClosure = self.showProductDetailCallback {
//                        pdClosure(product)
//                    }
//                }
                return cell
            }
            else {
                // (统一作为)搭配套餐
                
                // 当前套餐中的单个商品数据
                var product: FKYProductGroupItemModel!
                if item.productList != nil, item.productList.count > 0 {
                    if indexPath.section == 0 {
                        product = item.productList.first
                    }
                    else {
                        if item.productList.count > (indexPath.row + 1) {
                            product = item.productList[indexPath.row+1]
                        }
                    }
                }
                
                // 获取当前商品cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "PDGroupItemCell", for: indexPath) as! PDGroupItemCell
                cell.configCell(product, indexPath)
                // 选中or取消选中(当前cell)商品
                cell.willChangeSelStateCallback = { [unowned self] (state: Bool) -> Void in
                    print("closure: willChangeSelState")
                    // 更新选中状态
                    product.unselected = !state
                    // 主品必选
                    if let mainNum = product.isMainProduct ,mainNum.intValue == 1 {
                        product.unselected = false
                    }
//                    if indexPath.section == 0, indexPath.row == 0 {
//                        product.unselected = false
//                    }
                    // 更新显示状态
                    tableView.reloadData()
                    // 更新价格
                    self.updateCurrentGroupPrice(item)
                }
                // 加
                cell.addCallback = { [unowned self] (currentCount: Int) -> Void in
                    print("closure: addCallback")
                    // 更新数量
                    product.setNumberForAdd(currentCount)
                    // 更新显示状态
                    tableView.reloadData()
                    // 更新价格
                    self.updateCurrentGroupPrice(item)
                }
                // 减
                cell.minusCallback = { [unowned self] (currentCount: Int) -> Void in
                    print("closure: minusCallback")
                    // 更新数量
                    product.setNumberForMinus(currentCount)
                    // 更新显示状态
                    tableView.reloadData()
                    // 更新价格
                    self.updateCurrentGroupPrice(item)
                }
                // 输入检测
                cell.validateTextinputCallback = { [unowned self] (currentCount: Int) -> Void in
                    print("closure: validateTextinputCallback")
                    // 更新数量
                    product.checkNumber(forInput: currentCount)
                    // 更新显示状态
                    tableView.reloadData()
                    // 更新价格
                    self.updateCurrentGroupPrice(item)
                }
                cell.updateRealTimeCallback = { [weak self] (currentCount: Int, msg: String?) in
                    if let strongSelf = self, let str = msg ,str.count > 0 {
//                        if let num = product.maxBuyNum ,num.intValue > 0 {
//                            strongSelf.toast("每次限购\(currentCount)\(product.unitName ?? "")")
//                        }else {
//                            strongSelf.toast(str)
//                        }
                        strongSelf.toast(str)
                    }
                }
                // 跳转商详
//                cell.JumpToProductDetailCallback = { [unowned self] () -> Void in
//                    print("closure: JumpToProductDetailCallback")
//                    // 若未给viewPd赋值，则默认使用window。查看商详时，需先popout
//                    if self.viewPd == nil {
//                        self.showOrHideGroupPopView(false)
//                    }
//                    // closure
//                    if let pdClosure = self.showProductDetailCallback {
//                        pdClosure(product)
//                    }
//                }
                return cell
            }
        }
        return UITableViewCell.init()
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return WH(126)
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let groups = self.arrayGroup, groups.count > 0 {
            let tagIndex = tableView.tag // tableview索引
            let item = groups[tagIndex] // 指定索引处的套餐数据
            if item.productList != nil, item.productList.count > 0 {
                // 当前套餐中包含商品
                if let type = item.promotionRule, type.intValue == 2 {
                    // 固定套餐
                }
                else {
                    // (统一作为)搭配套餐
                    if section == 1 {
                        // 子品section
                        return WH(35)
                    }
                }
            }
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let groups = self.arrayGroup, groups.count > 0 {
            let tagIndex = tableView.tag // tableview索引
            let item = groups[tagIndex] // 指定索引处的套餐数据
            if item.productList != nil, item.productList.count > 0 {
                // 当前套餐中包含商品
                if let type = item.promotionRule, type.intValue == 2 {
                    // 固定套餐
                }
                else {
                    // (统一作为)搭配套餐
                    if section == 1 {
                        // 子品section
                        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(30)))
                        view.backgroundColor = RGBColor(0xF4F4F4)
                        
                        let lbl = UILabel()
                        lbl.backgroundColor = UIColor.clear
                        lbl.textAlignment = .left
                        lbl.textColor = RGBColor(0x666666)
                        lbl.text = "-请选择其他搭售商品-"
                        lbl.font = UIFont.systemFont(ofSize: WH(12))
                        view.addSubview(lbl)
                        lbl.snp.makeConstraints({ (make) in
                            make.center.equalTo(view)
                        })
                        
                        // 分隔线
                        let viewLine = UIView()
                        viewLine.backgroundColor = RGBColor(0xE5E5E5)
                        view.addSubview(viewLine)
                        viewLine.snp.makeConstraints { (make) in
                            make.left.right.bottom.equalTo(view)
                            make.height.equalTo(0.5)
                        }
                        
                        return view
                    }
                }
            }
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if let groups = self.arrayGroup, groups.count > 0 {
//            let tagIndex = tableView.tag // tableview索引
//            let item = groups[tagIndex] // 指定索引处的套餐数据
//            if item.productList != nil, item.productList.count > 0 {
//                // 当前套餐中包含商品
//                if let type = item.promotionRule, type.intValue == 2 {
//                    // 固定套餐
//                    if section == 0 {
//                        // 套餐数量输入视图
//                        return WH(54)
//                    }
//                }
//                else {
//                    // (统一作为)搭配套餐
//                }
//            }
//        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        if let groups = self.arrayGroup, groups.count > 0 {
//            let tagIndex = tableView.tag // tableview索引
//            let item = groups[tagIndex] // 指定索引处的套餐数据
//            if item.productList != nil, item.productList.count > 0 {
//                // 当前套餐中包含商品
//                if let type = item.promotionRule, type.intValue == 2 {
//                    // 固定套餐
//                    if section == 0 {
//                        // 套餐数量输入视图
//                        return self.arrayFooters[section]
//                    }
//                }
//                else {
//                    // (统一作为)搭配套餐
//                }
//            }
//        }
        return UIView()
    }
    
    // 不再响应整个cell跳转商详
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let groups = self.arrayGroup, groups.count > 0 {
            // 获取当前商品model
            let tagIndex = tableView.tag // tableview索引
            let item = groups[tagIndex] // 指定索引处的套餐数据
            
            if let type = item.promotionRule, type.intValue == 2 {
                // 固定套餐
                
                // 当前套餐中的单个商品数据
                let product: FKYProductGroupItemModel = item.productList[indexPath.row]
                
                // 若未给viewPd赋值，则默认使用window。查看商详时，需先popout
                if self.viewPd == nil {
                    self.showOrHideGroupPopView(false)
                }
                // closure
                if let pdClosure = self.showProductDetailCallback {
                    pdClosure(product,indexPath.row,tagIndex,item.promotionName,item.getMaxGroupNumber())
                }
            }
            else {
                // (统一作为)搭配套餐
                var indexRow = 0 //记录点击了第一个商品
                // 当前套餐中的单个商品数据
                var product: FKYProductGroupItemModel!
                if item.productList != nil, item.productList.count > 0 {
                    if indexPath.section == 0 {
                        indexRow = 0
                        product = item.productList.first
                    }
                    else {
                        if item.productList.count > (indexPath.row + 1) {
                            indexRow = indexPath.row+1
                            product = item.productList[indexPath.row+1]
                        }
                    }
                }
                
                guard let pd = product else {
                    return
                }
                
                // 若未给viewPd赋值，则默认使用window。查看商详时，需先popout
                if self.viewPd == nil {
                    self.showOrHideGroupPopView(false)
                }
                // closure
                if let pdClosure = self.showProductDetailCallback {
                    pdClosure(pd,indexRow,tagIndex,item.promotionName,item.getMaxGroupNumber())
                }
            }
        }
    }
}
