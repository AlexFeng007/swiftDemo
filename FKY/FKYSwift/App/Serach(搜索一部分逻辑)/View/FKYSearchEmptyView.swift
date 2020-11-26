//
//  FKYSearchEmptyView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/7/16.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  搜索无结果时的空态视图

import UIKit

/// 跳转到新品登记vc
let FKY_jumpToNewProductRegisterVC = "jumpToNewProductRegisterVC"

class FKYSearchEmptyView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - Property
    var extendDic:[String:AnyObject]?
    // 搜索回调
    var searchClosure: ((Int, SearchSuggestModel)->())?
    var resigterClosure: emptyClosure?
    
    // 分期数组
    var keywordList = [SearchSuggestModel]()
    
    // 1药贷广告栏高度
    var adsHeight: CGFloat = 0
    
    // 是否为店铺内的商品搜索...<默认为非店铺内商品搜索>
    var searchInShop = false
    
    /// 白色背景视图
    var whiteBackView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    //    /// 低分召回提示文描
    //    var lowRecallLabel:UILabel = {
    //        let lb = UILabel()
    //        lb.textColor = RGBColor(0x333333)
    //        lb.textAlignment = .center
    //        lb.font = UIFont.boldSystemFont(ofSize: WH(18))
    //        lb.text = "非精准匹配，以下是相关搜索结果"
    //        return lb
    //    }()
    
    // 1药贷广告
    //    lazy var scrollTextView: LMJScrollTextView? = {
    //        //let view = LMJScrollTextView.init(frame: CGRect.zero, textScrollModel: LMJTextScrollContinuous, direction: LMJTextScrollMoveLeft)
    //        let view = LMJScrollTextView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: WH(20)), textScrollModel: LMJTextScrollContinuous, direction: LMJTextScrollMoveLeft)
    //        //view?.startScroll(withText: "【1药贷】上线，采药也能打白条啦！单体药店/个体诊所顾客至App【我的】→【1药贷】申请开通！", textColor: RGBColor(0xE8772A), font: UIFont.systemFont(ofSize: WH(12)))
    //        if let lbl = view {
    //            lbl.backgroundColor = RGBColor(0xFFFCF1)
    //            lbl.startScroll(withText: "【1药贷】上线，采药也能打白条啦！单体药店/个体诊所顾客至App【我的】→【1药贷】申请开通！", textColor: RGBColor(0xE8772A), font: UIFont.systemFont(ofSize: WH(12)))
    //        }
    //        return view
    //    }()
    
    // icon
    fileprivate lazy var imgviewIcon: UIImageView = {
        let view = UIImageView()
        view.image =  UIImage.init(named: "image_search_empty")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    // 提示
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = RGBColor(0x999999)
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textAlignment = .left
        lbl.text = "很抱歉，没找到与“藿香真实换行情况”相关的商品，请重新搜索"
        lbl.numberOfLines = 3 // 最多3行
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    
    //    // 标题
    //    fileprivate lazy var lblTitle: UILabel = {
    //        let lbl = UILabel()
    //        lbl.backgroundColor = UIColor.clear
    //        lbl.textColor = RGBColor(0x333333)
    //        lbl.font = UIFont.boldSystemFont(ofSize: WH(14))
    //        lbl.textAlignment = .left
    //        lbl.text = "为您推荐："
    //        return lbl
    //    }()
    
    // 推荐词列表
    fileprivate lazy var collectionView: UICollectionView = {
        //let flowLayout = UICollectionViewFlowLayout()
        let flowLayout = UICollectionViewLeftAlignedLayout()
        // 设置滚动的方向
        flowLayout.scrollDirection = .vertical
        // 设置item的大小
        //flowLayout.itemSize = CGSize(width: WH(94), height: WH(30))
        // 设置同一组当中，行与行之间的最小行间距
        flowLayout.minimumLineSpacing = WH(10)
        // 设置同一行的cell中互相之间的最小间隔
        flowLayout.minimumInteritemSpacing = WH(10)
        // 设置section距离边距的距离
        flowLayout.sectionInset = UIEdgeInsets(top: WH(0), left: WH(0), bottom: WH(0), right: WH(10))
        
        let view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.backgroundColor = UIColor.clear
        view.delegate = self
        view.dataSource = self
        view.isScrollEnabled = true
        view.showsVerticalScrollIndicator = false
        view.register(FKYSearchItemCCell.self, forCellWithReuseIdentifier: "FKYSearchItemCCell")
        return view
    }()
    
    ///为你推荐LB
    lazy var TJLable:UILabel = {
        let lb = UILabel()
        lb.backgroundColor = UIColor.clear
        lb.textColor = RGBColor(0x333333)
        lb.font = UIFont.systemFont(ofSize: WH(14))
        lb.textAlignment = .left
        lb.text = "为您推荐:"
        return lb
    }()
    
    /// 有推荐词时候显示的lb
    lazy var subLabel:UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = RGBColor(0x999999)
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textAlignment = .left
        lbl.text = "或者请将商品的“条形码(69码)”告诉我"
        lbl.numberOfLines = 3 // 最多3行
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    
    /// 新品推荐按钮
    lazy var recommendButton:UIButton = {
        let bt = UIButton()
        bt.setTitle("新品登记", for: .normal)
        bt.backgroundColor = RGBColor(0xFFEDE7)
        bt.layer.cornerRadius = WH(3)
        bt.layer.masksToBounds = true
        bt.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        bt.layer.borderWidth = 1
        bt.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: WH(14))
        bt.addTarget(self, action: #selector(FKYSearchEmptyView.recommendButtonClicked), for: .touchUpInside)
        return bt
    }()
    
    // 背景视图
    lazy var viewSuggest: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        //        let lbl = UILabel()
        //        lbl.backgroundColor = UIColor.clear
        //        lbl.textColor = RGBColor(0x333333)
        //        lbl.font = UIFont.systemFont(ofSize: WH(14))
        //        lbl.textAlignment = .left
        //        lbl.text = "为您推荐为您推荐为您推荐为您推荐为您推荐为您推荐为您推荐:"
        
        view.addSubview(TJLable)
        TJLable.snp.makeConstraints({ (make) in
            make.top.equalTo(view).offset(WH(5))
            make.left.equalTo(view).offset(WH(18))
        })
        
        view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints({ (make) in
            make.top.bottom.right.equalTo(view).offset(WH(0))
            make.left.equalTo(TJLable.snp.right).offset(WH(10))
        })
        
        return view
    }()
    
    // 底部分隔线
    //    fileprivate lazy var viewLine: UIView = {
    //        let view = UIView.init(frame: CGRect.zero)
    //        view.backgroundColor = RGBColor(0xE5E5E5)
    //        return view
    //    }()
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UI
extension FKYSearchEmptyView{
    
    func setupView() {
        backgroundColor = RGBColor(0xF4F4F4)
        adsHeight = 0
        //        if searchInShop {
        //            // 店铺内的商品搜索...<不显示1药贷广告>
        //            //self.scrollTextView?.isHidden = true
        //        }
        //        else {
        //            // 非店铺内的商品搜索
        //            if let ads = scrollTextView {
        //               // self.scrollTextView?.isHidden = false
        //                adsHeight = WH(20)
        //                addSubview(ads)
        //                ads.snp.makeConstraints { (make) in
        //                    make.top.left.right.equalTo(self)
        //                    make.height.equalTo(adsHeight)
        //                }
        //            }
        //  }
        
        self.addSubview(self.whiteBackView)
        self.sendSubviewToBack(whiteBackView)
        self.addSubview(self.imgviewIcon)
        self.addSubview(self.lblTip)
        self.addSubview(self.viewSuggest)
        self.addSubview(self.subLabel)
        self.addSubview(self.recommendButton)
        
        self.whiteBackView.snp_makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(WH(-20))
        }
        
        self.imgviewIcon.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(adsHeight + WH(20))
            make.left.equalTo(self).offset(WH(20))
            make.width.equalTo(WH(52))
            make.height.equalTo(WH(48))
        }
        
        self.lblTip.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.imgviewIcon).offset(-WH(2))
            make.left.equalTo(self.imgviewIcon.snp.right).offset(WH(20))
            make.right.equalTo(self).offset(-WH(10))
        }
        
        //        self.viewSuggest.backgroundColor = .red
        self.viewSuggest.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(self.imgviewIcon.snp_bottom).offset(WH(20))
            make.top.lessThanOrEqualTo(self.lblTip.snp_bottom).offset(WH(10))
            //            make.top.equalTo( imgviewIcon.snp.bottom).offset(WH(10))
            make.left.right.equalTo(self)
            make.height.equalTo(WH(0))
        }
        
        //        self.subLabel.backgroundColor = .yellow
        self.subLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.viewSuggest.snp_bottom).offset(WH(0))
            make.left.equalTo(self.imgviewIcon)
            make.right.equalTo(self.lblTip)
        }
        
        self.recommendButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self.subLabel.snp_bottom).offset(WH(9))
            make.width.equalTo(WH(79))
            make.height.equalTo(WH(30))
            make.bottom.equalTo(self).offset(-WH((24+20)))
        }
        //        addSubview(viewLine)
        //        viewLine.snp.makeConstraints { (make) in
        //            make.left.right.bottom.equalTo(self)
        //            make.height.equalTo(0.5)
        //        }
        //        viewLine.isHidden = true // 先隐藏
    }
    
    /// 不显示医药贷广告时候的布局
    //    func hideAdLayout(){
    //        imgviewIcon.snp_updateConstraints { (make) in
    //            make.top.equalTo(self).offset(WH(16))
    //        }
    //    }
    
    /// 低分召回布局UI
    func lowRecallLyaout(){
        self.viewSuggest.isHidden = true
        self.recommendButton.isHidden = true
        self.subLabel.isHidden = true
        self.lblTip.text = "非精准匹配，以下是相关的搜索结果"
    }
    
    // 获取当前视图总高度，同时更新布局
    func getViewHeight() -> CGFloat {
        // 1药贷广告栏高度
        adsHeight = 0
        if searchInShop {
            // 店铺内的商品搜索...<不显示1药贷广告>
            //            if scrollTextView != nil {
            //                scrollTextView!.isHidden = true
            //            }
        }
        else {
            // 非店铺内的商品搜索
            //            if scrollTextView != nil {
            //                adsHeight = WH(20)
            //                scrollTextView!.isHidden = false
            //            }
        }
        
        // 推荐关键词列表高度
        var listHeight: CGFloat = 0
        if self.keywordList.count > 0 {
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            // 最多三行
            listHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
            // 下限
            if listHeight < WH(32) {
                listHeight = WH(32)
            }
            // 上限
            if listHeight > WH(110) {
                listHeight = WH(110)
            }
            self.viewSuggest.snp_updateConstraints { (make) in
                //                make.top.equalTo(imgviewIcon.snp.bottom).offset(WH(10))
                make.left.right.equalTo(self)
                make.height.equalTo(WH(listHeight))
            }
        }
        
        // 更新内部布局
        imgviewIcon.snp.updateConstraints { (make) in
            make.top.equalTo(self).offset(adsHeight + WH(20))
        }
        layoutIfNeeded()
        
        var topLBHeight:CGFloat = 0
        var subLBHeight:CGFloat = 0
        var margin1:CGFloat = 0
        var margin2:CGFloat = 0
        var margin3:CGFloat = 0
        var margin4:CGFloat = 0
        var margin5:CGFloat = 0
        
        if self.keywordList.count > 0 {
            topLBHeight = WH(48)
            subLBHeight = WH(48)
            margin1 = WH(22)
            margin2 = WH(10)
            margin3 = WH(10)
            margin4 = WH(9)
            margin5 = WH(22)
            self.imgviewIcon.snp_updateConstraints { (make) in
                make.top.equalTo(self).offset(adsHeight + WH(20))
            }
            
            self.lblTip.snp_remakeConstraints { (make) in
                make.centerY.equalTo(self.imgviewIcon).offset(-WH(2))
                make.left.equalTo(self.imgviewIcon.snp.right).offset(WH(20))
                make.right.equalTo(self).offset(-WH(10))
            }
        }else{
            self.lblTip.sizeToFit()
            
            topLBHeight = self.lblTip.hd_height
            subLBHeight = WH(0)
            margin1 = WH(34)
            margin2 = WH(0)
            margin3 = WH(0)
            margin4 = WH(9)
            margin5 = WH(24)
            
            self.imgviewIcon.snp_updateConstraints { (make) in
                make.top.equalTo(self).offset(adsHeight + WH(34))
            }
            self.lblTip.snp_remakeConstraints { (make) in
                make.top.equalTo(self.imgviewIcon)
                make.left.equalTo(self.imgviewIcon.snp.right).offset(WH(20))
                make.right.equalTo(self).offset(-WH(10))
            }
        }
        let buttonHeight = WH(30)
        // 返回总高度
        return adsHeight + topLBHeight + subLBHeight + buttonHeight + margin1 + margin2 + margin3 + margin4 + margin5 + listHeight + WH(20)
    }
    
    //底部分隔线显示or隐藏
    //    func showOrHideViewLine(_ showFlag: Bool) {
    //        viewLine.isHidden = !showFlag
    //    }
}

//MARK: - collectionViewDelegate Datasource
extension FKYSearchEmptyView{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywordList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 计算文字宽度
        var keyword = ""
        let item: SearchSuggestModel = keywordList[indexPath.row]
        if let word = item.word, word.isEmpty == false {
            keyword = word
        }
        let width = COProductItemCell.calculateStringWidth(keyword, UIFont.systemFont(ofSize: WH(14)), WH(30))
        return CGSize(width: width + WH(24), height:WH(30))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(0), left: WH(0), bottom: WH(0), right: WH(10))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return WH(10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return WH(10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYSearchItemCCell", for: indexPath) as! FKYSearchItemCCell
        // 配置cell
        let item: SearchSuggestModel = keywordList[indexPath.row]
        cell.configCell(item.word)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 选择回调
        if let block = searchClosure {
            block(indexPath.item, keywordList[indexPath.row])
        }
    }
}

//MARK: - 数据显示
extension FKYSearchEmptyView{
    // MARK: - Public
    func configView(_ keyword: String?, _ list: [SearchSuggestModel]?) {
        self.keywordList.removeAll()
        if let list = list, list.count > 0 {
            self.keywordList.append(contentsOf: list)
        }
        self.collectionView.reloadData()
        // 无联想词，则隐藏；有联想词，则显示
        //        self.viewSuggest.isHidden = keywordList.count > 0 ? false : true
        
        if self.keywordList.count > 0 {// 有联想词
            self.haveKeyWordShowType(keyword ?? "")
        }else{// 无联想词
            self.haveNoKeyWordShowType(keyword ?? "")
        }
        
        //        if let txt = keyword, txt.isEmpty == false {
        //            
        //        }else {
        //            lblTip.attributedText = nil
        //            lblTip.text = "很抱歉，没找到相关的商品"
        //        }
    }
    
    /// 有联想词的显示方案
    func haveKeyWordShowType(_ keyword:String){
        
        self.viewSuggest.isHidden = false
        
        self.lblTip.text = ""
        // 富文本
        let content = "很抱歉，没找到与“\(keyword)”相关的商品"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: content)
        let smallFont = UIFont.systemFont(ofSize: WH(14))
        let bigFont = UIFont.systemFont(ofSize: WH(14))
        let textColor = RGBColor(0x999999)
        let typeColor = RGBColor(0x333333)
        attributedString.addAttribute(NSAttributedString.Key.font, value: smallFont, range: NSMakeRange(0, content.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: NSMakeRange(0, content.count))
        if keyword.isEmpty == false{
            let range: NSRange = self.getRangeOfString(content, keyword)
            attributedString.addAttribute(NSAttributedString.Key.font, value: bigFont, range: range)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: typeColor, range: range)
        }
        
        // 设置行间距
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, content.count))
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, content.count))
        self.lblTip.attributedText = attributedString
        
        let mainStr = "或者请将商品的“条形码(69码)”告诉我们，我们会为您尽快采购！"
        let SubStr = "条形码(69码)"
        let attributedString2: NSMutableAttributedString = NSMutableAttributedString(string: mainStr)
        let smallFont2 = UIFont.systemFont(ofSize: WH(14))
        let bigFont2 = UIFont.systemFont(ofSize: WH(14))
        let textColor2 = RGBColor(0x999999)
        let typeColor2 = RGBColor(0xFF2D5C)
        let range2: NSRange = self.getRangeOfString(mainStr, SubStr)
        attributedString2.addAttribute(NSAttributedString.Key.font, value: smallFont2, range: NSMakeRange(0, mainStr.count))
        attributedString2.addAttribute(NSAttributedString.Key.font, value: bigFont2, range: range2)
        attributedString2.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor2, range: NSMakeRange(0, mainStr.count))
        attributedString2.addAttribute(NSAttributedString.Key.foregroundColor, value: typeColor2, range: range2)
        // 设置行间距
        let paragraphStyle2 = NSMutableParagraphStyle()
        paragraphStyle2.lineSpacing = 3
        attributedString2.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle2, range: NSMakeRange(0, mainStr.count))
        self.subLabel.text = ""
        self.subLabel.attributedText = attributedString2
        
        
    }
    
    /// 无联想词的显示方案
    func haveNoKeyWordShowType(_ keyword:String){
        self.viewSuggest.isHidden = true
        
        self.lblTip.text = ""
        // 富文本
        var content = ""
        if keyword.isEmpty == false{
            content = "很抱歉，没找到与“\(keyword)”相关的商品\n或者请将商品的“条形码(69码)”告诉我们，我们会为您尽快采购！"
        }else{
            content = "很抱歉，没找到相关的商品\n或者请将商品的“条形码(69码)”告诉我们，我们会为您尽快采购！"
        }
        
        let SubStr = "条形码(69码)"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: content)
        let smallFont = UIFont.systemFont(ofSize: WH(14))
        let bigFont = UIFont.systemFont(ofSize: WH(14))
        let textColor = RGBColor(0x999999)
        let typeColor = RGBColor(0x333333)
        let typeColor2 = RGBColor(0xFF2D5C)
        attributedString.addAttribute(NSAttributedString.Key.font, value: smallFont, range: NSMakeRange(0, content.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: NSMakeRange(0, content.count))
        if keyword.isEmpty == false{
            let range: NSRange = self.getRangeOfString(content, keyword)
            attributedString.addAttribute(NSAttributedString.Key.font, value: bigFont, range: range)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: typeColor, range: range)
        }
        
        let range2: NSRange = self.getRangeOfString(content, SubStr)
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: typeColor2, range: range2)
        // 设置行间距
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, content.count))
        self.lblTip.attributedText = attributedString
        
        self.subLabel.text = ""
        self.subLabel.attributedText = nil
        
    }
    
    /// 查找子串在父串中的位置，请确保子串在父串中一定存在
    func getRangeOfString(_ mainString:String , _ subString:String) -> NSRange{
        let range:Range = mainString.range(of: subString)!
        return NSRange(range,in:mainString)
    }
}

//MARK: - 响应事件
extension FKYSearchEmptyView{
    /// 新品登记按钮点击
    @objc func recommendButtonClicked(){
        if let block = resigterClosure {
            block()
        }
        self.routerEvent(withName: FKY_jumpToNewProductRegisterVC, userInfo: [FKYUserParameterKey:""])
    }
}


class FKYSearchItemCCell: UICollectionViewCell {
    // MARK: - Property
    
    // 背景视图
    fileprivate lazy var viewBg: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(3)
        view.layer.borderColor = RGBColor(0xCCCCCC).cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    // 关联词
    fileprivate lazy var lblKeyword: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x000000)
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.9
        return lbl
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = UIColor.clear
        
        contentView.addSubview(viewBg)
        viewBg.addSubview(lblKeyword)
        
        viewBg.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        lblKeyword.snp.makeConstraints { (make) in
            make.edges.equalTo(viewBg)
        }
    }
    
    
    // MARK: - Public
    
    // 配置cell
    func configCell(_ keyword: String?) {
        lblKeyword.text = keyword ?? ""
    }
}
