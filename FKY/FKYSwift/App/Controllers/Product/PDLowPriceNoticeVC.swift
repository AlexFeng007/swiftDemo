//
//  PDLowPriceNoticeVC.swift
//  FKY
//
//  Created by 寒山 on 2020/3/12.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  降价通知

import UIKit

class PDLowPriceNoticeVC: UIViewController,FKY_PDLowPriceNoticeVC {
    @objc var productObject: FKYProductObject! //商品信息
    
    fileprivate var navBar: UIView?
    // ViewModel
    fileprivate lazy var viewModel:LowPriceNoticeViewModel = {
        let VM = LowPriceNoticeViewModel()
        return VM
    }()
    /// 提交按钮容器视图
    lazy var containerSubmitView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        return view
    }()
    /// 提交按钮
    lazy var submitButton:UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = WH(4)
        bt.layer.masksToBounds = true
        //        bt.layer.borderWidth = WH(1)
        //        bt.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        bt.setTitle("提交", for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(15))
        bt.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        bt.backgroundColor = RGBColor(0xFF2D5C)
        _ = bt.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.sendLowPriceNoticeRequest()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return bt
    }()
    
    lazy var tableView: UITableView = { [weak self] in
        var tableView = UITableView(frame: CGRect.null, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = RGBColor(0xF4F4F4)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = UIView.init(frame: .zero)
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.register(PDLowPriceInputCell.self, forCellReuseIdentifier: "PDLowPriceInputCell")
        tableView.register(PDLowPriceProductCell.self, forCellReuseIdentifier: "PDLowPriceProductCell")
        if #available(iOS 11, *) {
            tableView.estimatedRowHeight = 0//WH(213)
            tableView.estimatedSectionHeaderHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
        }()
    
    deinit {
        print("...>>>>>>>>>>>>>>>>>>>>>PDLowPriceNoticeVC deinit~!@")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("内存不足")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.produdModel = productObject
        setupView()
        //每次进入获取缓存数据进行时间判断是否线上隐藏数据
    }
    // MARK: init Method
    fileprivate func setupView() {
        self.navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.navBar!.backgroundColor = RGBColor(0xFFFFFF)
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal") {[weak self] in
            if self != nil {
                FKYNavigator.shared().pop()
            }
        }
        fky_setupTitleLabel("降价通知")
        
        self.view.addSubview(self.containerSubmitView)
        self.containerSubmitView.addSubview(self.submitButton)
        
        // iPhoneX适配
        var height = WH(62)
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                // iPhone X
                height += iPhoneX_SafeArea_BottomInset
            }
        }
        self.containerSubmitView.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(height)
        }
        
        self.submitButton.snp_makeConstraints { (make) in
            make.top.equalToSuperview().offset(WH(10))
            make.left.equalToSuperview().offset(WH(19))
            make.width.equalTo(WH(336))
            make.height.equalTo(WH(42))
        }
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.left.right.equalToSuperview()
            make.top.equalTo(strongSelf.navBar!.snp_bottom)
            make.bottom.equalTo(strongSelf.containerSubmitView.snp_top)
        }
    }
}
extension PDLowPriceNoticeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return viewModel.cellTypeList.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PDLowPriceProductCell", for: indexPath) as!   PDLowPriceProductCell
            cell.selectionStyle = .none
            cell.configCell(productObject)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "PDLowPriceInputCell", for: indexPath) as!   PDLowPriceInputCell
        cell.selectionStyle = .none
        let type = viewModel.cellTypeList[indexPath.row]
        let value = viewModel.getCellValue(type)
        cell.configCell(type, value)
        cell.beginEditing = { [weak self]  in
            guard let strongSelf = self else {
                return
            }
            strongSelf.infoEditBI(indexPath.row)
        }
        // 输入文字改变中
        cell.changeText = { [weak self] (txt) in
            guard let strongSelf = self else {
                return
            }
            // 保存内容
            strongSelf.viewModel.setCellValue(type, txt)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let viewHead = UIView()
            viewHead.backgroundColor = RGBColor(0xFFFCF1)
            
            let lbl = UILabel()
            lbl.backgroundColor = .clear
            lbl.font = UIFont.systemFont(ofSize: WH(12))
            lbl.textColor = RGBColor(0xE8772A)
            lbl.textAlignment = .center
            lbl.text = "一旦此商品在60天内降价，您将收到手机推送消息以及短信通知。"
            viewHead.addSubview(lbl)
            lbl.snp_makeConstraints { (make) in
                make.edges.equalTo(viewHead)
            }
            
            return viewHead
        }
        let viewHead = UIView()
        viewHead.backgroundColor = RGBColor(0xF4F4F4)
        return viewHead
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            return WH(40)
        }
        return PDLowPriceProductCell.getCellContentHeight(productObject)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return WH(32)
        }
        return WH(10)
    }
}


extension PDLowPriceNoticeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let  sectionHeaderHeight = WH(32)
        if(scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right:0);
        }
        else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsets(top: -sectionHeaderHeight, left: 0, bottom: 0, right:0)
        }
    }
}
extension PDLowPriceNoticeVC{
    func sendLowPriceNoticeRequest(){
        if viewModel.lowPrice == nil{
            self.toast("请输入期望价格")
            return
        }
        if !(viewModel.lowPrice!.isEmpty) {
            let reg = "^(([1-9]{1}\\d*)|([0]{1}))(\\.(\\d){0,2})?$"
            let pre = NSPredicate(format: "SELF MATCHES %@", reg)
            if !pre.evaluate(with: viewModel.lowPrice!) {
                self.toast("请输入正确的期望价格,最多两位小数")
                return
            }
            if viewModel.lowPrice!.count > 10{
                self.toast("请输入正确的期望价格,最多10位含小数")
                return
            }
        }
        if viewModel.lowPrice != nil , StringToFloat(str: viewModel.lowPrice!) <= 0{
            self.toast("请输入正确的期望价格")
            return
        }
        if  StringToFloat(str: viewModel.lowPrice!) >= CGFloat((productObject.priceInfo.price as NSString).floatValue) {
            self.toast("期望价格需低于当前价格")
            return
        }
        if let promotionNum =  productObject.productPromotion?.promotionPrice , promotionNum.floatValue > 0  {
            if  StringToFloat(str: viewModel.lowPrice!) >= CGFloat(promotionNum.floatValue) {
                self.toast("期望价格需低于当前价格")
                return
            }
        }
        if let pVip = productObject.vipPromotionInfo,let _ = pVip.vipPromotionId,let _ = pVip.visibleVipPrice, let vipNum = Float(pVip.visibleVipPrice), vipNum > 0 {
            if let vipAvailableNum = Float(pVip.availableVipPrice) ,vipAvailableNum > 0 {
                //会员
                if  StringToFloat(str: viewModel.lowPrice!) >= CGFloat(vipAvailableNum) {
                    self.toast("期望价格需低于当前价格")
                    return
                }
            }
        }
        if viewModel.userPhoneNum.isEmpty {// 电话号码
            self.toast("请填写手机号")
            return
        }else{
            let reg = "^1[0-9]+$"
            let pre = NSPredicate(format: "SELF MATCHES %@", reg)
            if !pre.evaluate(with: viewModel.userPhoneNum) {
                self.toast("请填写1开头手机号")
                return
            }
            if viewModel.userPhoneNum.count != 11{
                self.toast("请填正确格式手机号")
                return
            }
        }
        
        var currectPrice = productObject.priceInfo.price ?? "0"
        
        if let promotionNum =  productObject.productPromotion?.promotionPrice , promotionNum.floatValue > 0  {
            currectPrice = String(format:"\(productObject.productPromotion?.promotionPrice ?? 0)")
        }
        //let value = Float(vipNum)
        if let pVip = productObject.vipPromotionInfo,let _ = pVip.vipPromotionId,let _ = pVip.visibleVipPrice, let vipNum = Float(pVip.visibleVipPrice), vipNum > 0 {
            if let vipAvailableNum = Float(pVip.availableVipPrice) ,vipAvailableNum > 0 {
                //会员
                currectPrice = pVip.availableVipPrice
            }
        }
        let itemTitle =  currectPrice + "|" + viewModel.lowPrice!
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: "降价通知", sectionId: nil, sectionPosition: nil, sectionName:nil, itemId: "I6602", itemPosition:"1", itemName: "提交", itemContent: nil, itemTitle: itemTitle, extendParams:nil, viewController: self)
        showLoading()
        viewModel.postLowPriceInfo(){ [weak self] (success, msg) in
            // 成功
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            strongSelf.toast(msg)
            if success{
                FKYNavigator.shared().pop()
            }
        }
    }
    func StringToFloat(str:String)->(CGFloat){
        let string = str
        var cgFloat:CGFloat = 0
        if let doubleValue = Double(string)
        {
            cgFloat = CGFloat(doubleValue)
        }
        return cgFloat
    }
    
}
extension PDLowPriceNoticeVC{
    //0：填写价格  1：填写手机号
    func infoEditBI(_ rowIndex:Int){
        var itemName = "填写价格"
        var itemPosition = "1"
        if rowIndex == 0{
            itemName = "填写价格"
            itemPosition = "1"
        }else if  rowIndex == 1{
            itemName = "填写手机号"
            itemPosition = "2"
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: "降价通知", sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I6601", itemPosition:itemPosition, itemName: itemName, itemContent: nil, itemTitle: nil, extendParams:nil, viewController: self)
    }
}
