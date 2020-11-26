//
//  FKYSearchRankListView.swift
//  FKY
//
//  Created by 油菜花 on 2020/2/11.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit



class FKYSearchRankListView: UIView{
    /// BI埋点model
    var BIModel = FKYSearchBIModel()
    
    /// cell行高
    let rankListRowHeight = WH(40)
    /// sectionHeader高度
    let rankListSectionHeaderHeight = CGFloat(24.0)
    /// 最小高度
    let rankListMinHeight = rowHeight*4 + MAX_TOOLCONTENT_H
    
    fileprivate var top:CGFloat = 0.0
    /// 规格列表
    lazy var selectedRankList:[String] = []
    
    /// 是否已经弹出 默认已弹出
    lazy var isPoped = false
    
    typealias rankNodeItemList = (_ rankList: [SerachRankInfoModel]) -> Void
    /// 规格筛选的回调
    var rankListCallBack:rankNodeItemList?
    
    typealias BIBlock = (_ BIModel: FKYSearchBIModel) -> Void
    ///BI埋点回调
    var rankListBIBlock:BIBlock?
    
    /// tapBar的frame
    var sourceFrame: CGRect?
    
    lazy var collectionView: UICollectionView =  {
        let flowLayout = UICollectionViewLeftAlignedLayout()
        flowLayout.minimumInteritemSpacing = WH(7)
        flowLayout.minimumLineSpacing = WH(20)
        //        flowLayout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.white
        cv.alwaysBounceVertical = true
        flowLayout.estimatedItemSize = CGSize(width: (SCREEN_WIDTH - WH(13)*3)/2.0, height: 200);
        flowLayout.headerReferenceSize = CGSize.init(width: SCREEN_WIDTH - MAX_FACTORYCONTENT_SPACE, height: 40)// 页眉宽高
        flowLayout.footerReferenceSize =  CGSize.zero
        cv.register(FKYSearchRankListItem.self, forCellWithReuseIdentifier: "FKYSearchRankListItem") // 加车cell
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) { // iPhone X
                cv.contentInsetAdjustmentBehavior = .never
                cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                cv.scrollIndicatorInsets = cv.contentInset
            }
        }
        return cv
    }()
    
    /// 容器视图
    lazy var toolView:UIView = {
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
    
    /// 重置按钮
    lazy var resetButton:UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0 , width: SCREEN_WIDTH/2.0, height: MAX_TOOLCONTENT_H)//CGRectMake(0, top, kScreenWidth, kScreenHeigth - top);
        button.backgroundColor = RGBColor(0xFFFFFF);
        button.titleLabel?.font = t36.font
        button.setTitle("重置", for: .normal)
        button.setTitleColor(RGBColor(0x333333), for: .normal)
        button.addTarget(self, action: #selector(FKYSearchRankListView.resetSelectInfoAction), for: .touchUpInside)
        self.toolView.addSubview(button)
        return button
    }()
    
    /// 确定按钮
    lazy var conmfirButton:UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: SCREEN_WIDTH/2.0, y: 0 , width: SCREEN_WIDTH/2.0, height: MAX_TOOLCONTENT_H)
        button.backgroundColor = RGBColor(0xFF2D5C);
        button.setTitle("确定", for: .normal)
        button.titleLabel?.font = t36.font
        button.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        button.addTarget(self, action: #selector(FKYSearchRankListView.comfireSelectInfoAction), for: .touchUpInside)
        self.toolView.addSubview(button)
        return button
    }()
    
    lazy var shadowView:UIView = {
        let v = UIView()
        return v
    }()
    
}

//MARK: - 刷新数据
extension FKYSearchRankListView {
    //    func initRankList(_ frame:CGRect,rankList:[SerachRankInfoModel]){
    func initRankList(_ frame:CGRect){
        for rank in SearchFactoryName.shared.rankList{
            if rank.isSelected == true {
                self.selectedRankList.append(rank.rankName!)
            }
        }
        //frame 布局
        self.sourceFrame = frame
        top =  (self.sourceFrame?.maxY)!
        let rootView :UIWindow = UIApplication.shared.keyWindow!
        var contentHeight:CGFloat =  SCREEN_HEIGHT - top - 2*MAX_TOOLCONTENT_H
        var resultHeight:CGFloat = contentHeight+MAX_TOOLCONTENT_H;
        let numberOfline:Int = SearchFactoryName.shared.rankList.count/2 + SearchFactoryName.shared.rankList.count % 2
        let allCellHeight = CGFloat(numberOfline) * rowHeight
        if (allCellHeight+MAX_TOOLCONTENT_H)<resultHeight{
            if (allCellHeight+MAX_TOOLCONTENT_H) < minHeight{
                resultHeight = minHeight
                contentHeight = resultHeight - MAX_TOOLCONTENT_H
            }else{
                contentHeight = allCellHeight
                resultHeight = contentHeight + MAX_TOOLCONTENT_H
            }
        }else{
            contentHeight =  SCREEN_HEIGHT - top - 2*MAX_TOOLCONTENT_H
            resultHeight = contentHeight+MAX_TOOLCONTENT_H;
        }
        self.frame = CGRect(x: 0, y: top, width: SCREEN_WIDTH, height: 0)
        rootView.addSubview(self)
        shadowView.frame = CGRect(x: 0, y: top, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - top)//CGRectMake(0, top, kScreenWidth, kScreenHeigth - top);
        shadowView.backgroundColor = RGBColor(0x484848);
        shadowView.alpha = 0.0
        shadowView.isUserInteractionEnabled = true
        rootView.insertSubview(shadowView, belowSubview: self)
        ///空白取区域增加点击事件
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FKYMPSelectView.respondsToTapGestureRecognizer))
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 1
        //        self.shadowView.addGestureRecognizer(tapGesture)
        
        setupView(CGRect(x: 0, y: self.top, width: SCREEN_WIDTH, height: resultHeight))
        
        ///动画
        UIView.animate(withDuration: 0.5, animations:{[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.frame = CGRect(x: 0, y: strongSelf.top, width: SCREEN_WIDTH, height: resultHeight)
            strongSelf.collectionView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: contentHeight)
            strongSelf.toolView.frame = CGRect(x: 0, y: contentHeight , width: SCREEN_WIDTH, height: MAX_TOOLCONTENT_H)
            strongSelf.shadowView.alpha = 0.8 }, completion: nil)
        self.isPoped = true
        self.collectionView.reloadData()
    }
}

//MARK: - 事件响应
extension FKYSearchRankListView {
    
    /// 重置按钮点击
    @objc func resetSelectInfoAction(){
        for rank in SearchFactoryName.shared.rankList{
            rank.isSelected = false
        }
        self.collectionView.reloadData()
    }
    
    /// 确定按钮点击
    @objc func comfireSelectInfoAction(){
        self.selectedRankList.removeAll()
        var selectRank:[SerachRankInfoModel] = []
        for rank in SearchFactoryName.shared.rankList{
            if rank.isSelected == true {
                self.selectedRankList.append(rank.rankName!)
                selectRank.append(rank)
            }
        }
        self.BIParam()
        if let BICallBack = self.rankListBIBlock{
            BICallBack(self.BIModel)
        }
        if let callBack = self.rankListCallBack{
            callBack(selectRank)
        }
        self.dissmissView()
    }
}

//MARK: - UI
extension FKYSearchRankListView {
    func setupView(_ frame:CGRect){
        self.addSubview(self.collectionView)
        self.addSubview(self.toolView)
        self.collectionView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0)
        self.toolView.frame = CGRect(x: 0, y:0 , width: SCREEN_WIDTH, height: WH(50))
        self.resetButton.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH/2.0, height: WH(50))
        self.conmfirButton.frame = CGRect(x: SCREEN_WIDTH/2.0, y: 0, width: SCREEN_WIDTH/2.0, height: WH(50))
    }
    
    func dissmissView() -> () {
        ///恢复选中状态
        for rank in SearchFactoryName.shared.rankList {
            rank.isSelected = false
        }
        for name in self.selectedRankList {
            for rank in SearchFactoryName.shared.rankList {
                if rank.rankName == name{
                    rank.isSelected = true
                }
            }
        }
        UIView.animate(withDuration: 0.5, animations:{[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.frame = CGRect(x: 0, y: strongSelf.top, width: SCREEN_WIDTH, height: 0)
            strongSelf.collectionView.frame = strongSelf.bounds
            strongSelf.toolView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height:MAX_TOOLCONTENT_H )
            strongSelf.shadowView.alpha = 0.0 }, completion: {[weak self] finish in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.shadowView.removeFromSuperview()
                strongSelf.collectionView.removeFromSuperview()
                strongSelf.toolView.removeFromSuperview()
                strongSelf.isPoped = false
                if (strongSelf.superview != nil) {
                    strongSelf.removeFromSuperview()
                }
        })
    }
    
    func dissmissViewRightNow() -> () {
        ///恢复选中状态
        for rank in SearchFactoryName.shared.rankList {
            rank.isSelected = false
        }
        for name in self.selectedRankList {
            for rank in SearchFactoryName.shared.rankList {
                if rank.rankName == name{
                    rank.isSelected = true
                }
            }
        }
        self.toolView.removeFromSuperview()
        self.shadowView.removeFromSuperview()
        self.collectionView.removeFromSuperview()
        if (self.superview != nil) {
            self.removeFromSuperview()
        }
        self.isPoped = false
    }
    func dissmissViewForScroll() -> () {
        for rank in SearchFactoryName.shared.rankList {
            rank.isSelected = false
        }
        for name in self.selectedRankList {
            for rank in SearchFactoryName.shared.rankList {
                if rank.rankName == name{
                    rank.isSelected = true
                }
            }
        }
        ///恢复选中状态
        self.toolView.removeFromSuperview()
        self.shadowView.removeFromSuperview()
        self.collectionView.removeFromSuperview()
        if (self.superview != nil) {
            self.removeFromSuperview()
        }
        self.isPoped = false
    }
}


//MARK: - collectionView代理
extension FKYSearchRankListView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SearchFactoryName.shared.rankList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYSearchRankListItem", for: indexPath) as! FKYSearchRankListItem
        let selectNode:SerachRankInfoModel = SearchFactoryName.shared.rankList[indexPath.row]
        cell.configCell(((selectNode.rankName ?? "")+"(\(selectNode.rankCode ?? ""))"), isSelected: selectNode.isSelected!)
        //        cell.backgroundColor = .yellow
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let rankModel:SerachRankInfoModel = SearchFactoryName.shared.rankList[indexPath.row]
        rankModel.isSelected = !(rankModel.isSelected ?? true)//默认false
        self.collectionView.reloadData()
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        return CGSize(width: (SCREEN_WIDTH - WH(13)*3)/2.0, height: WH(40))
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(13), left: WH(13), bottom: WH(0), right: WH(13))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //规格
        return CGSize.zero
        
    }
    
}


//MARK: - BI埋点
extension FKYSearchRankListView{
    func BIParam(){
        var itemPositionList:[String] = []
        for (index,item) in SearchFactoryName.shared.rankList.enumerated(){
            if item.isSelected == true{
                itemPositionList.append("\(index)")
            }
        }
        let itemPosition = itemPositionList.joined(separator: ",")
        
        self.BIModel.floorName = "筛选条件"
        self.BIModel.sectionId = "S9001"
        self.BIModel.sectionPosition = "5"
        self.BIModel.sectionName = "规格"
        self.BIModel.itemId = ITEMCODE.SEARCHRESULT_FILTRATE_CLICK_CODE.rawValue
        self.BIModel.itemPosition = itemPosition
        self.BIModel.itemName = "选择规格"
        self.BIModel.type = "1"
        //        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: "筛选条件", sectionId: "S9001", sectionPosition: "5", sectionName: "规格", itemId: ITEMCODE.SEARCHRESULT_FILTRATE_CLICK_CODE.rawValue, itemPosition: itemPosition, itemName: "选择规格", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: nil)
    }
}
