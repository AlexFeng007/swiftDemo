//
//  FKYMPSelectView.swift
//  FKY
//
//  Created by 寒山 on 2018/6/30.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit
let MAX_TOOLCONTENT_H = WH(50) //工具栏和距离底部的高

/// 厂家筛选事件
let FKY_comfirmFactoryFiltrate = "comfirmFactoryFiltrate"
/// cell行高
let rowHeight = WH(44)
/// sectionHeader高度
let sectionHeaderHeight = CGFloat(24.0)
/// 最小高度
let minHeight = rowHeight*4 + MAX_TOOLCONTENT_H
class FKYMPSelectView:FKYBasePopUpView ,
    UITableViewDelegate,
UITableViewDataSource{
    typealias selectNodeItemList = (_ nodeList: Array<SerachSellersInfoModel>?) -> Void
    var callBack : selectNodeItemList?
    
    /// BI埋点model
    var BIModel = FKYSearchBIModel()
    typealias BIBlock = (_ BIModel: FKYSearchBIModel) -> Void
    ///BI埋点回调
    var rankListBIBlock:BIBlock?
    
    
    /// 选择厂家的block回调
    typealias selectFactoryList = (_ factoryList: [SerachFactorysInfoModel]) -> Void
    var factoryListCallBack : selectFactoryList?
    
    var indexTitleArray :[String] = []
    var toolView: UIView?  /* 工具层**/
    var conmfirButton: UIButton?  /* 确定**/
    var resetButton: UIButton?  /* 取消**/
    var totastLabel : UILabel? //提示字母
    var currentSelected = [SerachSellersInfoModel]()
    /// 当前页面显示的类型 0：初始默认值，无用  1：显示自营商家列表（自营筛选条件列表）  2：显示mp商家列表（商家筛选条件列表） 3: 显示生产厂家列表（厂家筛选条件列表）
    var showType = 0
    /// 最开始选择的厂家ID
    var factoryIDList = [Int]()
    
    /// 生产厂家列表
    lazy var factoryArray:[SerachFactorysInfoModel] = {
        let list:[SerachFactorysInfoModel] = []
        return list
    }()
    
    /// 规格列表
    lazy var rankInfoArray:[SerachRankInfoModel] = {
        let list:[SerachRankInfoModel] = []
        return list
    }()
    
    /// 全部商家
    fileprivate lazy var sortArray: [SerachSellersInfoModel] =  {
        let sortArray : [SerachSellersInfoModel] = []
        return sortArray
    }()
    
    /// 自营商家
    fileprivate lazy var selfArray: [SerachSellersInfoModel] =  {
        let selfArray : [SerachSellersInfoModel] = []
        return selfArray
    }()
    
    /// 常购商家
    fileprivate lazy var buyArray: [SerachSellersInfoModel] =  {
        let sortArray : [SerachSellersInfoModel] = []
        return sortArray
    }()
    
    /// 收藏商家
    fileprivate lazy var favArray: [SerachSellersInfoModel] =  {
        let sortArray : [SerachSellersInfoModel] = []
        return sortArray
    }()
    
    fileprivate lazy var aryLetterIndexForMore: [String] =  {
        let stringArray : [String] = []
        return stringArray
    }()
    
    lazy var factoryDicDataForMore:[String:Array<SerachFactorysInfoModel>] = {
        let dicMoreData : [String:Array<SerachFactorysInfoModel>] = [:]
        return dicMoreData
    }()
    
    fileprivate lazy var dicDataForMore: [String:Array<SerachSellersInfoModel>] =  {
        let dicMoreData : [String:Array<SerachSellersInfoModel>] = [:]
        return dicMoreData
    }()
    
    fileprivate var top:CGFloat = 0.0
    /// type 1 显示自营商家列表  2显示mp商家列表
    func initWithContentAraay(_ frame:CGRect,_ fkySortInfo:[SerachSellersInfoModel],_ factoryList:[SerachFactorysInfoModel],_ type:Int) {
        
        self.showType = type
        self.isShowIng = true
        self.sortArray = fkySortInfo
        self.selfArray = FKYFilterSearchServicesModel.shared.sellerSelfList
        self.buyArray = FKYFilterSearchServicesModel.shared.sellerBuyList
        self.favArray = FKYFilterSearchServicesModel.shared.sellerFavList
        
        self.currentSelected = FKYFilterSearchServicesModel.shared.sellerSelectedList
        
        var dicPinYin:[String:Array<SerachSellersInfoModel>] = [:]
        self.sourceFrame = frame
        self.top =  (self.sourceFrame?.maxY)!
        var contentHeight:CGFloat =  SCREEN_HEIGHT - top - 2*MAX_TOOLCONTENT_H
        var resultHeight:CGFloat = contentHeight+MAX_TOOLCONTENT_H
        
        var preKeyArr :[String] = []
        var allKeyArr :[String] = []
        if self.showType == 1{/// 显示自营商家列表
            /// 自营商家数据填充
            if self.selfArray.count > 0 {
                for item in self.selfArray {
                    item.isSelected = self.contentsSelect(item)
                }
                let defaultSelf = SerachSellersInfoModel(sellerCode: 100, sellerName: "全部")
                
                var isSelectAll = true
                for item in self.selfArray{
                    if item.isSelected == false {
                        isSelectAll = false
                    }
                }
                
                if isSelectAll {// 如果是全选
                    for item in self.selfArray{
                        item.isSelected = false
                    }
                    defaultSelf.isSelected = true
                }else{
                    defaultSelf.isSelected = false
                }
                self.selfArray.insert(defaultSelf, at: 0)
                
                dicPinYin["↑"] = self.selfArray
                preKeyArr.append("↑")
                let tableHeight = CGFloat(self.selfArray.count) * rowHeight
                if (tableHeight + MAX_TOOLCONTENT_H) < resultHeight{
                    if (tableHeight + MAX_TOOLCONTENT_H) < minHeight{
                        resultHeight = minHeight
                        contentHeight = resultHeight - MAX_TOOLCONTENT_H
                    }else{
                        contentHeight = tableHeight
                        resultHeight = contentHeight+MAX_TOOLCONTENT_H
                    }
                }else{
                    contentHeight =  SCREEN_HEIGHT - top - 2*MAX_TOOLCONTENT_H
                    resultHeight = contentHeight+MAX_TOOLCONTENT_H;
                }
            }
        }else if self.showType == 2{/// 显示MP商家列表
            
            //常买数据填充
            if self.buyArray.count > 0 {
                for item in self.buyArray {
                    item.isSelected = self.contentsSelect(item)
                }
                dicPinYin[""] = self.buyArray
                preKeyArr.append("")
            }
            //收藏数据填充
            if self.favArray.count > 0 {
                for item in self.favArray {
                    item.isSelected = self.contentsSelect(item)
                }
                dicPinYin["☆"] = self.favArray
                preKeyArr.append("☆")
            }
            
            //全部商家数据模型填充
            for item in self.sortArray {
                let firstLetterOfPinyin:String = self.getPinyinOfStringFirstLetters(item.sellerName!)
                var strAry:Array<SerachSellersInfoModel>? = dicPinYin[firstLetterOfPinyin]
                if nil == strAry {
                    strAry = []
                }
                item.isSelected = self.contentsSelect(item)
                
                strAry?.append(item)
                dicPinYin[firstLetterOfPinyin] = strAry
                //记录字母
                if allKeyArr.contains(firstLetterOfPinyin) == false {
                    allKeyArr.append(firstLetterOfPinyin)
                }
            }
            let allHeaderHeight = CGFloat(allKeyArr.count+preKeyArr.count) * sectionHeaderHeight
            let allCellHeight = (CGFloat(self.buyArray.count) + CGFloat(self.favArray.count) + CGFloat(self.sortArray.count)) * rowHeight
            if (allHeaderHeight+allCellHeight+MAX_TOOLCONTENT_H)<resultHeight{
                if (allHeaderHeight+allCellHeight+MAX_TOOLCONTENT_H) < minHeight{
                    resultHeight = minHeight
                    contentHeight = resultHeight - MAX_TOOLCONTENT_H
                }else{
                    contentHeight = allHeaderHeight+allCellHeight
                    resultHeight = contentHeight + MAX_TOOLCONTENT_H
                }
            }else{
                contentHeight =  SCREEN_HEIGHT - top - 2*MAX_TOOLCONTENT_H
                resultHeight = contentHeight+MAX_TOOLCONTENT_H;
            }
        }else if self.showType == 3{/// 显示厂家列表
            self.factoryDicDataForMore.removeAll()
            self.factoryArray = factoryList
            self.factoryIDList.removeAll()
            for factory in self.factoryArray {
                if factory.isSelected ?? false {
                    self.factoryIDList.append(factory.factoryId!)
                }
            }
            for item in self.factoryArray {
                let firstLetterOfPinyin:String = self.getPinyinOfStringFirstLetters(item.factoryName!)
                var strAry:Array<SerachFactorysInfoModel>? = self.factoryDicDataForMore[firstLetterOfPinyin]
                if nil == strAry {
                    strAry = []
                }
                item.isSelected = self.factoryContentsSelect(item)
                
                strAry?.append(item)
                self.factoryDicDataForMore[firstLetterOfPinyin] = strAry
                //记录字母
                if allKeyArr.contains(firstLetterOfPinyin) == false {
                    allKeyArr.append(firstLetterOfPinyin)
                }
            }
            let allHeaderHeight = CGFloat(allKeyArr.count) * sectionHeaderHeight
            let allCellHeight = CGFloat(self.factoryArray.count) * rowHeight
            if (allHeaderHeight+allCellHeight+MAX_TOOLCONTENT_H)<resultHeight{
                if (allHeaderHeight+allCellHeight+MAX_TOOLCONTENT_H) < minHeight{
                    resultHeight = minHeight
                    contentHeight = resultHeight - MAX_TOOLCONTENT_H
                }else{
                    contentHeight = allHeaderHeight+allCellHeight
                    resultHeight = contentHeight + MAX_TOOLCONTENT_H
                }
                
            }else{
                contentHeight =  SCREEN_HEIGHT - top - 2*MAX_TOOLCONTENT_H
                resultHeight = contentHeight+MAX_TOOLCONTENT_H;
            }
        }
        //排序及调整
        let arr = allKeyArr.sorted()
        if (arr.contains("#") && arr.count > 1){
            self.aryLetterIndexForMore = preKeyArr + arr[1...arr.count-1] + ["#"]
        }else {
            self.aryLetterIndexForMore = preKeyArr + arr
        }
        
        self.dicDataForMore = dicPinYin
        
        let rootView :UIWindow = UIApplication.shared.keyWindow!
        
        
        
        
        //        if (contentHeight + MAX_TOOLCONTENT_H)>(SCREEN_HEIGHT - top - MAX_TOOLCONTENT_H){
        //            contentHeight = SCREEN_HEIGHT - top - MAX_TOOLCONTENT_H
        //        }
        //let maxHeight:CGFloat = SCREEN_HEIGHT - 88.0 - top - 44.0;
        
        
        self.frame = CGRect(x: 0, y: top, width: SCREEN_WIDTH, height: 0)
        
        rootView.addSubview(self)
        
        self.mainTableView = {
            let tv = UITableView.init(frame: self.bounds, style: .plain )
            tv.delegate = self
            tv.dataSource = self
            tv.separatorStyle = .none
            tv.backgroundColor = UIColor.white
            tv.sectionIndexColor = RGBColor(0xFF2D5C)
            tv.sectionIndexBackgroundColor = UIColor.clear
            tv.sectionIndexTrackingBackgroundColor = UIColor.clear
            tv.backgroundView = nil
            //            tv.estimatedRowHeight = 44 // cell高度动态自适应
            tv.estimatedRowHeight = 200
            tv.rowHeight = UITableView.automaticDimension
            tv.register(FKYSortItemCell.self, forCellReuseIdentifier: "FKYSortItemCell")
            self.addSubview(tv)
            return tv
        }()
        
        
        self.shadowView = {
            let v = UIView()
            v.frame = CGRect(x: 0, y: top, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - top)//CGRectMake(0, top, kScreenWidth, kScreenHeigth - top);
            v.backgroundColor = RGBColor(0x484848);
            v.alpha = 0.0
            v.isUserInteractionEnabled = true
            rootView.addSubview(v)
            rootView.insertSubview(v, belowSubview: self)
            return v
        }()
        
        self.toolView = {
            let v = UIView()
            v.frame = CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height: MAX_TOOLCONTENT_H)//CGRectMake(0, top, kScreenWidth, kScreenHeigth - top);
            v.backgroundColor = RGBColor(0xFFFFFF);
            v.isUserInteractionEnabled = true
            v.layer.shadowColor = RGBColor(0x000000).cgColor
            v.layer.shadowOpacity = 0.1
            v.layer.shadowOffset = CGSize.init(width: 0, height: -4)
            self.addSubview(v)
            return v
        }()
        self.resetButton = {
            let button = UIButton()
            button.frame = CGRect(x: 0, y: 0 , width: SCREEN_WIDTH/2.0, height: MAX_TOOLCONTENT_H)//CGRectMake(0, top, kScreenWidth, kScreenHeigth - top);
            button.backgroundColor = RGBColor(0xFFFFFF);
            button.titleLabel?.font = t36.font
            button.setTitle("重置", for: .normal)
            button.setTitleColor(RGBColor(0x333333), for: .normal)
            button.addTarget(self, action: #selector(FKYMPSelectView.resetSelectInfoAction), for: .touchUpInside)
            self.toolView?.addSubview(button)
            return button
        }()
        
        /// 确定按钮
        self.conmfirButton = {
            let button = UIButton()
            button.frame = CGRect(x: SCREEN_WIDTH/2.0, y: 0 , width: SCREEN_WIDTH/2.0, height: MAX_TOOLCONTENT_H)
            button.backgroundColor = RGBColor(0xFF2D5C);
            button.setTitle("确定", for: .normal)
            button.titleLabel?.font = t36.font
            button.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
            button.addTarget(self, action: #selector(FKYMPSelectView.comfireSelectInfoAction), for: .touchUpInside)
            self.toolView?.addSubview(button)
            return button
        }()
        
        self.totastLabel = {
            let label = UILabel()
            label.isHidden = true
            label.textColor = RGBColor(0xffffff)
            label.font = t15.font
            label.textAlignment = .center
            label.backgroundColor = RGBColor(0xFF2D5C)
            label.layer.masksToBounds = true
            label.layer.cornerRadius = WH(50)/2.0
            self.addSubview(label)
            return label
        }()
        
        self.totastLabel?.snp.makeConstraints({ (make) in
            make.center.equalTo(self)
            make.width.height.equalTo(WH(50))
        })
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FKYMPSelectView.respondsToTapGestureRecognizer))
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 1
        self.shadowView?.addGestureRecognizer(tapGesture)
        
        UIView.animate(withDuration: 0.5, animations:{[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.frame = CGRect(x: 0, y: strongSelf.top, width: SCREEN_WIDTH, height: resultHeight)
            strongSelf.mainTableView?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: contentHeight)
            strongSelf.toolView?.frame = CGRect(x: 0, y: contentHeight , width: SCREEN_WIDTH, height: MAX_TOOLCONTENT_H)
            strongSelf.shadowView?.alpha = 0.8 }, completion: nil)
        self.mainTableView?.reloadData()
    }
    
    func clearSelectData(){
        self.currentSelected.removeAll()
    }
    
    func hideToatLabel() {
        let deadline = DispatchTime.now() + 1.0 //刷新数据的时候有延迟，所以推后1S刷新
        DispatchQueue.global().asyncAfter(deadline: deadline) {[weak self] in
            DispatchQueue.main.async {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.totastLabel?.isHidden = true
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.aryLetterIndexForMore.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keyLetter:String = self.aryLetterIndexForMore[section]
        if self.showType == 3 {
            return self.factoryDicDataForMore[keyLetter]!.count
        }
        return self.dicDataForMore[keyLetter]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FKYSortItemCell", for: indexPath) as! FKYSortItemCell
        if self.showType == 3 {/// 厂家筛选条件
            let keyLetter:String = self.aryLetterIndexForMore[indexPath.section]
            let factory: SerachFactorysInfoModel = (self.factoryDicDataForMore[keyLetter])![indexPath.row]
            cell .configCell(factory.factoryName, isSelected: factory.isSelected!)
        }else{
            let keyLetter:String = self.aryLetterIndexForMore[indexPath.section]
            let nodeInfo: SerachSellersInfoModel = (self.dicDataForMore[keyLetter])![indexPath.row]
            cell .configCell(nodeInfo.sellerName, isSelected: nodeInfo.isSelected!)
        }
        return cell
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        if self.showType == 1{/// 自营商家列表不需要右边索引
            return [""]
        }else if  self.showType == 3{
            let arr = self.aryLetterIndexForMore.filter { $0 != ""}
            return  arr
            
        }else{
            let arr = self.aryLetterIndexForMore.filter { $0 != ""}
            return  arr
        }
        
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        self.totastLabel?.isHidden = false
        self.totastLabel?.text = title
        self.hideToatLabel()
        return self.aryLetterIndexForMore.index(of: title) ?? 0
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return rowHeight
    //    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if  self.showType == 1 {/// 自营筛选不需要头部视图
            return 0
        }
        return sectionHeaderHeight
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView ()
        if  self.showType != 1 {
            headView.backgroundColor = RGBColor(0xF4F4F4)
            
            let titleLabel = UILabel ()
            titleLabel.font = UIFont.systemFont(ofSize: WH(14))
            titleLabel.textColor = RGBColor(0x666666);
            titleLabel.sizeToFit()
            titleLabel.backgroundColor = UIColor.clear
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            headView.addSubview(titleLabel)
            let titleStr = self.aryLetterIndexForMore[section]
            if titleStr == "↑" {
                titleLabel.text = "自营"
            }else if titleStr == "" {
                titleLabel.text = "购买过"
            }else if titleStr == "☆"{
                titleLabel.text = "收藏"
            }else{
                titleLabel.text = titleStr
            }
            titleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(headView).offset(WH(18))
                make.centerY.right.equalTo(headView)
            })
        }
        return headView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.showType == 3{/// 生产厂家
            let keyLetter:String = self.aryLetterIndexForMore[indexPath.section]
            let nodeInfo: SerachFactorysInfoModel = (self.factoryDicDataForMore[keyLetter])![indexPath.row]
            nodeInfo.isSelected = !(nodeInfo.isSelected ?? true)//默认false
        }else{
            let keyLetter:String = self.aryLetterIndexForMore[indexPath.section]
            let nodeInfo: SerachSellersInfoModel = (self.dicDataForMore[keyLetter])![indexPath.row]
            if self.showType == 1{//自营商家筛选列表
                if indexPath.row == 0{//点击全部
                    if nodeInfo.isSelected == true {//取消全选
                        for item in self.selfArray{
                            item.isSelected = false
                        }
                        self.currentSelected.removeAll()
                    }else{//全选
                        //                        self.currentSelected.removeAll()
                        for (index,item) in self.selfArray.enumerated(){
                            
                            if index == 0{
                                item.isSelected = true
                            }else{
                                item.isSelected = false
                                //                                self.currentSelected.append(item)
                            }
                        }
                        
                    }
                }else{
                    if selfArray.count > 0 {
                        let seller = self.selfArray[0]
                        
                        if seller.isSelected == true{
                            self.currentSelected.removeAll()
                            seller.isSelected = false
                        }
                        if nodeInfo.isSelected == true {
                            nodeInfo.isSelected = false
                            if let index = self.currentSelected.index(of: nodeInfo) {
                                self.currentSelected.remove(at: index)
                            }
                            
                        }else{
                            nodeInfo.isSelected = true
                            self.currentSelected.append(nodeInfo)
                        }
                    }
                }
            }else{
                if nodeInfo.isSelected!{
                    nodeInfo.isSelected = false
                    for selectNode in currentSelected{
                        if selectNode.sellerCode == nodeInfo.sellerCode{
                            currentSelected = currentSelected.filter{$0 != selectNode}
                            break;
                        }
                    }
                }
                else{
                    nodeInfo.isSelected = true
                    currentSelected.append(nodeInfo);
                }
                //由于自营/购买过/收藏分类中和全部商家可能有重合商家，需都选中
                for keyLetterStr in self.aryLetterIndexForMore{
                    //只遍历未选中的分类的商品
                    if keyLetterStr != keyLetter {
                        for node in self.dicDataForMore[keyLetterStr]!{
                            if node.sellerCode == nodeInfo.sellerCode {
                                node.isSelected = nodeInfo.isSelected
                                break
                            }
                        }
                    }
                }
            }
        }
        
        tableView .reloadData()
    }
    
    @objc func respondsToTapGestureRecognizer(){
        //        if callBack != nil {
        //            callBack!(nil)
        //        }
        
        //        self.dissmissView()
    }
    func dissmissView() -> () {
        if self.showType == 3{
            for factory in self.factoryArray {
                factory.isSelected = false
            }
            for id in self.factoryIDList {
                for factory in self.factoryArray{
                    if factory.factoryId == id {
                        factory.isSelected = true
                    }
                }
            }
        }
        UIView.animate(withDuration: 0.5, animations:{[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.frame = CGRect(x: 0, y: strongSelf.top, width: SCREEN_WIDTH, height: 0)
            strongSelf.mainTableView?.frame = strongSelf.bounds
            strongSelf.toolView?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height:MAX_TOOLCONTENT_H )
            strongSelf.shadowView?.alpha = 0.0 }, completion: {[weak self] finish in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.isShowIng = false
                strongSelf.totastLabel?.removeFromSuperview()
                strongSelf.shadowView?.removeFromSuperview()
                strongSelf.mainTableView?.removeFromSuperview()
                strongSelf.toolView?.removeFromSuperview()
                if (strongSelf.superview != nil) {
                    strongSelf.removeFromSuperview()
                }
        })
    }
    func dissmissViewRightNow() -> () {
        if self.showType == 3{
            for factory in self.factoryArray {
                factory.isSelected = false
            }
            for id in self.factoryIDList {
                for factory in self.factoryArray{
                    if factory.factoryId == id {
                        factory.isSelected = true
                    }
                }
            }
        }else{
            if callBack != nil {
                callBack!(nil)
            }
        }
        self.isShowIng = false
        //var selectArray = [SerachSellersInfoModel]()
        
        self.totastLabel?.removeFromSuperview()
        self.toolView?.removeFromSuperview()
        self.shadowView?.removeFromSuperview()
        self.mainTableView?.removeFromSuperview()
        if (self.superview != nil) {
            self.removeFromSuperview()
        }
    }
    func dissmissViewForScroll() -> () {
        if self.showType == 3{
            for factory in self.factoryArray {
                factory.isSelected = false
            }
            for id in self.factoryIDList {
                for factory in self.factoryArray{
                    if factory.factoryId == id {
                        factory.isSelected = true
                    }
                }
            }
        }
        self.isShowIng = false
        self.totastLabel?.removeFromSuperview()
        self.toolView?.removeFromSuperview()
        self.shadowView?.removeFromSuperview()
        self.mainTableView?.removeFromSuperview()
        if (self.superview != nil) {
            self.removeFromSuperview()
        }
    }
    func callBackBlock(_ block: @escaping selectNodeItemList) {
        
        callBack = block
    }
    
    /// 厂家筛选回调
    func factoryCallBack(_ block: @escaping selectFactoryList) {
        
        factoryListCallBack = block
    }
    
    @objc func comfireSelectInfoAction(){
        self.BIParam()
        if let BICallBack = self.rankListBIBlock{
            BICallBack(self.BIModel)
        }
        
        if self.showType == 3{
            var selectFactoryList = [SerachFactorysInfoModel]()
            self.factoryIDList.removeAll()
            for factory in self.factoryArray{
                if factory.isSelected == true{
                    self.factoryIDList.append(factory.factoryId!)
                    selectFactoryList.append(factory)
                }
            }
            
            if factoryListCallBack != nil {
                factoryListCallBack!(selectFactoryList)
            }
        }else if self.showType == 1{
            //自营的选择
            if callBack != nil && self.selfArray.count > 0{
                self.currentSelected.removeAll()
                if self.selfArray[0].isSelected == true{// 全选
                   // self.currentSelected.removeAll()
                    for (index,item) in self.selfArray.enumerated() {
                        if index != 0 {
                            item.isSelected = true
                            self.currentSelected.append(item)
                        }
                    }
                }else{
                    for (index,item) in self.selfArray.enumerated() {
                        if index != 0 {
                            if item.isSelected == true{
                                self.currentSelected.append(item)
                            }
                        }
                    }
                }
                FKYFilterSearchServicesModel.shared.sellerSelectedList = self.currentSelected;
                callBack!(self.currentSelected)
            }
        }else{
            if callBack != nil {
                FKYFilterSearchServicesModel.shared.sellerSelectedList = self.currentSelected;
                callBack!(self.currentSelected)
            }
        }
        
        self.dissmissView()
    }
    @objc func resetSelectInfoAction(){
        
        if self.showType == 3{
            for factory in self.factoryArray{
                factory.isSelected = false
            }
        }else if self.showType == 1{
            for item in self.selfArray {
                item.isSelected = false
            }
        }
        else{
            self.currentSelected.removeAll()
            for keyLetter in self.aryLetterIndexForMore{
                for node in self.dicDataForMore[keyLetter]!{
                    node.isSelected = false
                }
            }
        }
        
        self.mainTableView?.reloadData()
    }
    // MARK: - Private
    fileprivate func getPinyinOfStringFirstLetters(_ factoryName: String) -> String {
        var py="#"
        if factoryName.count > 0 {
            
            let index = (factoryName as NSString).character(at: 0)
            
            if( index > 0x4e00 && index < 0x9fff)
            {
                let strPinYin:String = factoryName.transformToPinyin()
                py  = (strPinYin as NSString).substring(to: 1).uppercased()
                
            }
            else{
                
                py = (factoryName as NSString).substring(to: 1).uppercased()
                //不是字母
                if (py < "A" || py > "Z") {
                    py = "#"
                }
                
            }
        }
        return py
    }
    func contentsSelect(_ node:SerachSellersInfoModel) -> Bool {
        for selectNode in currentSelected{
            if selectNode.sellerCode == node.sellerCode{
                return true
            }
        }
        return false
    }
    
    func factoryContentsSelect(_ node:SerachFactorysInfoModel) -> Bool {
        for selectNode in self.factoryIDList{
            if selectNode == node.factoryId{
                return true
            }
        }
        return false
    }
}

//MARK: - BI埋点
extension FKYMPSelectView{
    func BIParam(){
        if self.showType == 1{// 自营商家列表
            var itemPositionList:[String] = []
            var itemName = "全部"
            var isSelectAll = true
            for (index,item) in self.selfArray.enumerated() {
                if item.sellerName != "全部" && item.isSelected == true{
                    isSelectAll = false
                }
                if item.isSelected == true{
                    itemPositionList.append("\(index)")
                }
            }
            var itemPosition = ""
            if isSelectAll == false{
                itemName = "选择自营商家"
                itemPosition = itemPositionList.joined(separator: ",")
            }else{
                itemName = "全部"
                itemPosition = "0"
            }
            
            self.BIModel.floorName = "筛选条件"
            self.BIModel.sectionId = "S9001"
            self.BIModel.sectionPosition = "1"
            self.BIModel.sectionName = "自营"
            self.BIModel.itemId = ITEMCODE.SEARCHRESULT_FILTRATE_CLICK_CODE.rawValue
            self.BIModel.itemPosition = itemPosition
            self.BIModel.itemName = itemName
            self.BIModel.type = "4"
            
          // FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: "筛选条件", sectionId: "S9001", sectionPosition: "1", sectionName: "自营", itemId: ITEMCODE.SEARCHRESULT_FILTRATE_CLICK_CODE.rawValue, itemPosition: itemPosition, itemName: itemName, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: nil)
        }else if self.showType == 2{//MP商家列表
            
            var itemPositionList:[String] = []
            for str in self.aryLetterIndexForMore{
                for (index,item) in (self.dicDataForMore[str])!.enumerated(){
                    if item.isSelected == true{
                        itemPositionList.append("\(index)")
                    }
                }
            }
            let itemPosition = itemPositionList.joined(separator: ",")
            var itemTitle = ""
            var isHave = false
            for item in self.buyArray{
                if item.isSelected == true{
                    isHave = true
                }
            }
            if isHave {
                itemTitle = itemTitle + "," + "购买过"
                isHave = false
            }
            
            for item in self.favArray{
                if item.isSelected == true{
                    isHave = true
                }
            }
            if isHave {
                itemTitle = itemTitle + "," + "收藏"
                isHave = false
            }
            
            for item in self.sortArray{
                if item.isSelected == true{
                    isHave = true
                }
            }
            if isHave {
                itemTitle = itemTitle + "," + "全部"
                isHave = false
            }
            
            self.BIModel.floorName = "筛选条件"
            self.BIModel.sectionId = "S9001"
            self.BIModel.sectionPosition = "4"
            self.BIModel.sectionName = "商家"
            self.BIModel.itemId = ITEMCODE.SEARCHRESULT_FILTRATE_CLICK_CODE.rawValue
            self.BIModel.itemPosition = itemPosition
            self.BIModel.itemName = "选择商家"
            self.BIModel.type = "3"
            
            //            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: "筛选条件", sectionId: "S9001", sectionPosition: "4", sectionName: "商家", itemId: ITEMCODE.SEARCHRESULT_FILTRATE_CLICK_CODE.rawValue, itemPosition: itemPosition, itemName: "选择商家", itemContent: nil, itemTitle: itemTitle, extendParams: nil, viewController: nil)
        }else if self.showType == 3{//生产厂家列表
            var itemPositionList:[String] = []
            for (index,item) in self.factoryArray.enumerated(){
                if item.isSelected == true{
                    itemPositionList.append("\(index + 1)")
                }
            }
            let itemPosition = itemPositionList.joined(separator: ",")
            
            self.BIModel.floorName = "筛选条件"
            self.BIModel.sectionId = "S9001"
            self.BIModel.sectionPosition = "3"
            self.BIModel.sectionName = "厂家"
            self.BIModel.itemId = ITEMCODE.SEARCHRESULT_FILTRATE_CLICK_CODE.rawValue
            self.BIModel.itemPosition = itemPosition
            self.BIModel.itemName = "选择厂家"
            self.BIModel.type = "2"
            
            //            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: "筛选条件", sectionId: "S9001", sectionPosition: "3", sectionName: "厂家", itemId: ITEMCODE.SEARCHRESULT_FILTRATE_CLICK_CODE.rawValue, itemPosition: itemPosition, itemName: "选择厂家", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: nil)
        }
    }
}
