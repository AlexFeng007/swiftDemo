//
//  FKYFactoryFliterForSearchResultVC.swift
//  FKY
//
//  Created by airWen on 2017/5/4.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  筛选厂家

import UIKit

let MAX_FACTORYCONTENT_SPACE:CGFloat = 55.0 //边隙的距离
let HEADVIEW_HEIGHT:CGFloat = WH(80) //头部的高度

enum FactoryFliterListCotentMode {
    case FactoryNormal
    case FactoryMore
}
enum RankFliterListCotentMode {
    case RankNormal
    case RankMore
}
enum FactoryFliterListCellID : String {
    case FKYFilterDrugInfoCollectionViewCell = "FKYFilterDrugInfoCollectionViewCell"
}


class FKYFactoryFliterForSearchResultVC: UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    // MARK: - Property
    fileprivate lazy var backgroudImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: CGRect.zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.white
        //        imageView.contentMode = UIViewContentModeScaleAspectFit
        return imageView
    }()
    
    fileprivate lazy var maskControl: UIControl = {
        let view: UIControl = UIControl(frame: CGRect.zero)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        view .addTarget(self, action: #selector(onMaskTouch(_:)), for: .touchUpInside)
        return view
    }()
    
    fileprivate lazy var collectionView: UICollectionView =  {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = WH(7)
        flowLayout.minimumLineSpacing = WH(7)
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.white
        cv.alwaysBounceVertical = true
        flowLayout.headerReferenceSize = CGSize.init(width: SCREEN_WIDTH - MAX_FACTORYCONTENT_SPACE, height: 40)// 页眉宽高
        flowLayout.footerReferenceSize =  CGSize.zero
        cv.register(FKYFilterDrugInfoCollectionViewCell.self, forCellWithReuseIdentifier: "FKYFilterDrugInfoCollectionViewCell") // 加车cell
        cv.register(FilterFactoryHeadView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FilterFactoryHeadView")
        cv.register(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionFooter,withReuseIdentifier: "UICollectionReusableView")
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
    
    fileprivate lazy var headView: FilterInfoHeadView = {
        let v = FilterInfoHeadView()
        v.backgroundColor = RGBColor(0xFFFFFF);
        v.isUserInteractionEnabled = true
        return v
    }()
    
    fileprivate lazy var toolView: UIView = {
        let v = UIView()
        v.backgroundColor = RGBColor(0xFFFFFF);
        v.layer.shadowColor = RGBColor(0x000000).cgColor
        v.layer.shadowOpacity = 0.1
        v.layer.shadowOffset = CGSize.init(width: 0, height: -4)
        v.isUserInteractionEnabled = true
        return v
    }()
    
    fileprivate lazy var resetButton: UIButton = {
        let imgNormal = UIImage.imageWithColor(RGBColor(0xFFFFFF), size: CGSize.init(width: 2, height: 2))
        let imgSelect = UIImage.imageWithColor(RGBColor(0xF4F4F4), size: CGSize.init(width: 2, height: 2))
        let imgDisable = UIImage.imageWithColor(RGBColor(0xE5E5E5), size: CGSize.init(width: 2, height: 2))
        
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("重置", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(16))
        btn.setTitleColor(RGBColor(0x333333), for: .normal)
        btn.setTitleColor(RGBColor(0x666666), for: .highlighted)
        btn.setTitleColor(RGBColor(0x999999), for: .disabled)
        btn.setBackgroundImage(imgNormal, for: .normal)
        btn.setBackgroundImage(imgSelect, for: .highlighted)
        btn.setBackgroundImage(imgDisable, for: .disabled)
        btn.addTarget(self, action: #selector(resetSelectInfoAction), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var conmfirButton: UIButton = {
        let imgNormal = UIImage.imageWithColor(RGBColor(0xFF2D5C), size: CGSize.init(width: 2, height: 2))
        let imgSelect = UIImage.imageWithColor(UIColor.init(red: 113.0/255, green: 0, blue: 0, alpha: 1), size: CGSize.init(width: 2, height: 2))
        let imgDisable = UIImage.imageWithColor(RGBColor(0xE5E5E5), size: CGSize.init(width: 2, height: 2))
        
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("确定", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(16))
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .highlighted)
        btn.setTitleColor(RGBColor(0x999999), for: .disabled)
        btn.setBackgroundImage(imgNormal, for: .normal)
        btn.setBackgroundImage(imgSelect, for: .highlighted)
        btn.setBackgroundImage(imgDisable, for: .disabled)
        btn.addTarget(self, action: #selector(comfireSelectInfoAction), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var searchFactoryList: SearchFactoryName = {
        let searchfactory: SearchFactoryName = SearchFactoryName()
        return searchfactory
    }()
    
    //生产厂家相关字段
    fileprivate var factoryHasMore = false
    var factoryContentMode:FactoryFliterListCotentMode = .FactoryNormal
    var currentSelected = [SerachFactorysInfoModel]()//选中的生产厂家
    let maxShowFactpryNum = 5;
    
    //商品规格相关
    fileprivate var rankHasMore = false
    var rankContentMode:RankFliterListCotentMode = .RankNormal
    var currentRankSelected = [SerachRankInfoModel]()//选中的规格
    let maxShowRankpryNum = 10;
    
    //var letters:[String]?
    var dicAPIParam: [String : AnyObject]?
    var itemContentStr:String? //埋点商家id
    var filterResultWithFactoryAction: ((_ factoryName: [SerachFactorysInfoModel]?, _ rankName:[SerachRankInfoModel]?, _ factoryContentMode: FactoryFliterListCotentMode, _ rankContentMode: RankFliterListCotentMode)->())?
    
    // MARK: - LiftCircle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.backgroudImageView)
        self.view.addSubview(self.maskControl)
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints({[weak self] (make) in
            if let strongSelf = self {
                make.top.equalTo(strongSelf.view).offset(HEADVIEW_HEIGHT)
                make.right.equalTo(strongSelf.view)
                make.bottom.equalTo(strongSelf.view).offset(-MAX_TOOLCONTENT_H)
                make.left.equalTo(strongSelf.view).offset(MAX_FACTORYCONTENT_SPACE)
            }
        })
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroudImageView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["backgroudImageView":backgroudImageView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroudImageView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["backgroudImageView":backgroudImageView]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[maskControl(55)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["maskControl":maskControl]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[maskControl]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["maskControl":maskControl]))
        
        self.view.addSubview(headView);
        self.view.addSubview(toolView)
        toolView.addSubview(resetButton)
        toolView.addSubview(conmfirButton)
        headView.frame = CGRect(x: MAX_FACTORYCONTENT_SPACE, y: 0, width: SCREEN_WIDTH - MAX_FACTORYCONTENT_SPACE, height: HEADVIEW_HEIGHT)
        toolView.frame = CGRect(x: MAX_FACTORYCONTENT_SPACE, y: SCREEN_HEIGHT - MAX_TOOLCONTENT_H, width: SCREEN_WIDTH - MAX_FACTORYCONTENT_SPACE, height: MAX_TOOLCONTENT_H)
        resetButton.frame = CGRect(x: 0, y: 0 , width: (SCREEN_WIDTH - MAX_FACTORYCONTENT_SPACE)/2.0, height: MAX_TOOLCONTENT_H)//CGRectMake(0, top, kScreenWidth, kScreenHeigth - top);
        conmfirButton.frame = CGRect(x: (SCREEN_WIDTH - MAX_FACTORYCONTENT_SPACE)/2.0, y: 0 , width: (SCREEN_WIDTH - MAX_FACTORYCONTENT_SPACE)/2.0, height: MAX_TOOLCONTENT_H)
        
        headView.closeViewAction = { [weak self] in
            self?.cancelSelectInfo()
        }
        if nil != dicAPIParam {
            // 获取数据
            self.getFactoryList(dicAPIParam!)
            self.getSpcesList(dicAPIParam!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func resetSelectInfoAction() {
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName:"筛选厂家和规格", sectionId: nil, sectionPosition: nil, sectionName: "操作", itemId: ITEMCODE.SEARCHRESULT_FILTRATE_FUCTION_CODE.rawValue, itemPosition: "2", itemName: "重置", itemContent: self.itemContentStr, itemTitle: nil, extendParams: nil, viewController: self)
        
        self.currentSelected.removeAll()
        self.currentRankSelected.removeAll()
        for  node in self.searchFactoryList.factoryList{
            node.isSelected = false
        }
        for  node in self.searchFactoryList.rankList{
            node.isSelected = false
        }
        self.collectionView.reloadData()
    }
    
    @objc func comfireSelectInfoAction() {
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: "筛选厂家和规格", sectionId: nil, sectionPosition: nil, sectionName: "操作", itemId: ITEMCODE.SEARCHRESULT_FILTRATE_FUCTION_CODE.rawValue, itemPosition: "1", itemName: "确定", itemContent: self.itemContentStr, itemTitle: nil, extendParams: nil, viewController: self)
        
        self.popOut(delay: 0.0, isRunCompletion:true)
    }
    
    // MARK: - Request
    fileprivate func getFactoryList(_ params : [String : AnyObject]) {
        var dic = params
        //商品规格
        var specs:String = ""
        for (index, item) in currentRankSelected.enumerated() {
            if let rankStr = item.rankName {
                if index == 0{
                    specs = specs + String(rankStr)
                }else{
                    specs =  specs + "," + String(rankStr)
                }
            }
        }
        dic["specs"] = specs as AnyObject // (specs as NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue) as AnyObject
        self.showLoading()
        self.searchFactoryList.getFactoryFliterList(dic as! [String:String], callback: { [weak self] (factoryList) in
            if let strongSelf = self {
                if strongSelf.maxShowFactpryNum < factoryList.count {
                    strongSelf.factoryHasMore = true
                }else {
                    strongSelf.factoryHasMore = false
                }
                strongSelf.removeItemWithGetData(0)
                if strongSelf.currentSelected.count > 0 {
                    for node in strongSelf.searchFactoryList.factoryList{
                        node.isSelected = strongSelf.contentsSelect(node)
                    }
                }
                strongSelf.collectionView.reloadData()
                strongSelf.dismissLoading()
            }
            }, errorCallBack: { [weak self] in
                if let strongSelf = self {
                   strongSelf.dismissLoading()
                }
        })
    }
    
    //获取规格
    func getSpcesList(_ params : [String : AnyObject]) {
        //筛选的厂家
        var dic = params
        var factoryIds:String = ""
        for (index, item) in currentSelected.enumerated() {
            if index == 0{
                factoryIds = factoryIds + String(item.factoryId!)
            }else{
                factoryIds =  factoryIds + "," + String(item.factoryId!)
            }
        }
        dic["factoryIds"] = factoryIds as AnyObject
        self.showLoading()
        self.searchFactoryList.getProductRanksList(dic as! [String:String]) { [weak self] (rankList, msg) in
            if let strongSelf = self {
                if msg != nil {
                    strongSelf.toast(msg)
                }else{
                    if strongSelf.maxShowRankpryNum < strongSelf.searchFactoryList.rankList.count {
                        strongSelf.rankHasMore = true
                    }else {
                        strongSelf.rankHasMore = false
                    }
                    strongSelf.removeItemWithGetData(1)
                    if strongSelf.currentRankSelected.count > 0 {
                        for node in strongSelf.searchFactoryList.rankList{
                            node.isSelected = strongSelf.contentsRankSelect(node)
                        }
                    }
                    strongSelf.collectionView.reloadData()
                }
                strongSelf.dismissLoading()
            }
        }
    }
    
    fileprivate func popOut(delay: TimeInterval, isRunCompletion: Bool) {
        UIView.animate(withDuration: 0.05, delay: delay, options: .curveEaseOut, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.collectionView.alpha = 0.7
        }, completion: { finished in
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.maskControl.alpha = 0.0
                strongSelf.collectionView.alpha = 0.0
                strongSelf.toolView.alpha = 0.0
                strongSelf.headView.alpha = 0.0
            }, completion: {[weak self] finished in
                guard let strongSelf = self else {
                    return
                }
                FKYNavigator.shared().topNavigationController.popViewController(animated: false)
                if isRunCompletion {
                    if let searchFactoryAction = strongSelf.filterResultWithFactoryAction {
                        searchFactoryAction(strongSelf.currentSelected,strongSelf.currentRankSelected,strongSelf.factoryContentMode,strongSelf.rankContentMode)
                    }
                }
            })
        })
    }
    
    fileprivate func cancelSelectInfo() {
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: "筛选厂家和规格", sectionId: nil, sectionPosition: nil, sectionName: "操作", itemId: ITEMCODE.SEARCHRESULT_FILTRATE_FUCTION_CODE.rawValue, itemPosition: "3", itemName: "关闭筛选页面", itemContent: self.itemContentStr, itemTitle: nil, extendParams: nil, viewController: self)
        
        if let searchFactoryAction = self.filterResultWithFactoryAction {
        searchFactoryAction(nil,nil,self.factoryContentMode,self.rankContentMode)
        }
        UIView.animate(withDuration: 0.05, delay: 0, options: .curveEaseOut, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.collectionView.alpha = 0.7
        }, completion: {[weak self] finished in
            guard let strongSelf = self else {
                return
            }
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.maskControl.alpha = 0.0
                strongSelf.collectionView.alpha = 0.0
                strongSelf.toolView.alpha = 0.0
                strongSelf.headView.alpha = 0.0
            }, completion: { finished in
                FKYNavigator.shared().topNavigationController.popViewController(animated: false)
            })
        })
    }
    
    //MARK: - Others
    @objc func onMaskTouch(_ sender: UIControl) {
        cancelSelectInfo()
    }
    
    func setScreenCaptureImageForBackground(_ image: UIImage) {
        self.backgroudImageView.image = image
    }
    
    // MARK: - CollectionViewDelegate&DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            //生产厂家
            if  !self.factoryHasMore{
                return self.searchFactoryList.factoryList.count
            }else {
                if factoryContentMode == .FactoryNormal{
                    return maxShowFactpryNum
                }else{
                    return self.searchFactoryList.factoryList.count
                }
            }
        }else{
            //规格
            if  !self.rankHasMore{
                return self.searchFactoryList.rankList.count
            }else {
                if rankContentMode == .RankNormal {
                    return maxShowRankpryNum
                }else{
                    return self.searchFactoryList.rankList.count
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYFilterDrugInfoCollectionViewCell", for: indexPath) as! FKYFilterDrugInfoCollectionViewCell
        if indexPath.section == 0 {
            let selectNode:SerachFactorysInfoModel = self.searchFactoryList.factoryList[indexPath.row]
            cell.configCell(selectNode, isSelected: selectNode.isSelected!)
        }else{
            let selectNode:SerachRankInfoModel = self.searchFactoryList.rankList[indexPath.row]
            cell.configCell(selectNode, isSelected: selectNode.isSelected!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: SCREEN_WIDTH - MAX_FACTORYCONTENT_SPACE - 2.0*WH(16), height: WH(40))
        }else{
            return CGSize(width: (SCREEN_WIDTH - MAX_FACTORYCONTENT_SPACE - 2.0*WH(16)-WH(10))/2.0, height: WH(40))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        var reusableview:UICollectionReusableView!
        if kind == UICollectionView.elementKindSectionHeader
        {
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FilterFactoryHeadView", for: indexPath as IndexPath) as! FilterFactoryHeadView
            if indexPath.section == 0 {
                //生产厂家
                (reusableview as! FilterFactoryHeadView).configCell("生产厂家", (factoryContentMode == .FactoryNormal ?false:true),self.factoryHasMore);
            }else{
                //商品规格
                (reusableview as! FilterFactoryHeadView).configCell("规格包装", (rankContentMode == .RankNormal ? false:true),self.rankHasMore);
            }
            
            (reusableview as! FilterFactoryHeadView).loadMoreAction = { [weak self] in
                if indexPath.section == 0 {
                    //生产厂家
                    self?.factoryContentMode = (self?.factoryContentMode == .FactoryNormal ? .FactoryMore : .FactoryNormal)
                }else{
                    //商品规格
                    self?.rankContentMode = (self?.rankContentMode == .RankNormal ? .RankMore : .RankNormal)
                }
                self?.collectionView.reloadData()
            }
        }
        if kind == UICollectionView.elementKindSectionFooter
        {
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "UICollectionReusableView", for: indexPath as IndexPath)
            reusableview.backgroundColor = .clear
            
        }
        return reusableview
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(0), left: WH(16), bottom: WH(0), right: WH(16))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            //生产厂家
            return self.searchFactoryList.factoryList.count > 0 ? CGSize(width: SCREEN_WIDTH - MAX_FACTORYCONTENT_SPACE, height: WH(40)) : CGSize(width: SCREEN_WIDTH - MAX_FACTORYCONTENT_SPACE, height: WH(0))
            
        }else{
            //规格
            return self.searchFactoryList.rankList.count > 0 ? CGSize(width: SCREEN_WIDTH - MAX_FACTORYCONTENT_SPACE, height: WH(40)) : CGSize(width: SCREEN_WIDTH - MAX_FACTORYCONTENT_SPACE, height: WH(0))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: "筛选厂家和规格", sectionId: nil, sectionPosition: nil, sectionName: "筛选生产厂家", itemId: ITEMCODE.SEARCHRESULT_FILTRATE_FACTORY_CODE.rawValue, itemPosition: "\(indexPath.row+1)", itemName: "生产厂家", itemContent: self.itemContentStr, itemTitle: nil, extendParams: nil, viewController: self)
            //生产厂家
            let selectString:SerachFactorysInfoModel = self.searchFactoryList.factoryList[indexPath.row]
            if selectString.isSelected! {
                selectString.isSelected = false
                for selectNode in currentSelected{
                    if selectNode.factoryId == selectString.factoryId{
                        currentSelected = currentSelected.filter{$0 != selectNode}
                        break;
                    }
                }
            }
            else {
                selectString.isSelected = true
                currentSelected.append(selectString);
            }
            if nil != dicAPIParam {
                // 获取数据
                self.getSpcesList(dicAPIParam!)
            }
        }else{
            //规格
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: "筛选厂家和规格", sectionId: nil, sectionPosition: nil, sectionName: "筛选规格包装", itemId: ITEMCODE.SEARCHRESULT_FILTRATE_SPECS_CODE.rawValue, itemPosition: "\(indexPath.row+1)", itemName: "规格包装", itemContent: self.itemContentStr, itemTitle: nil, extendParams: nil, viewController: self)
            let selectString:SerachRankInfoModel = self.searchFactoryList.rankList[indexPath.row]
            if selectString.isSelected! {
                selectString.isSelected = false
                for selectNode in currentRankSelected{
                    if selectNode.rankName == selectString.rankName{
                        currentRankSelected = currentRankSelected.filter{$0 != selectNode}
                        break;
                    }
                }
            }
            else {
                selectString.isSelected = true
                currentRankSelected.append(selectString);
            }
            if nil != dicAPIParam {
                // 获取数据
                self.getFactoryList(dicAPIParam!)
            }
        }
        collectionView.reloadData()
    }
    
    //设置被选中的厂家
    func contentsSelect(_ node:SerachFactorysInfoModel) -> Bool {
        for selectNode in currentSelected {
            if selectNode.factoryId == node.factoryId {
                return true
            }
        }
        return false
    }
    
    //设置被选中的规格
    func contentsRankSelect(_ node:SerachRankInfoModel) -> Bool {
        for selectNode in currentRankSelected{
            if selectNode.rankName == node.rankName{
                return true
            }
        }
        return false
    }
    
    //筛选可能由于重新请求后，之前选中的数据不存在了
    func removeItemWithGetData(_ type:Int){
        if type == 0 {
            //生产厂家
            if currentSelected.count > 0 {
                var currentArr = [SerachFactorysInfoModel]()
                for selectNode in currentSelected {
                    for node in searchFactoryList.factoryList {
                        if selectNode.factoryId == node.factoryId {
                            currentArr.append(selectNode)
                            break;
                        }
                    }
                }
                currentSelected = currentArr
            }
        }else{
            //产品规格
            if currentRankSelected.count > 0 {
                var currentArr = [SerachRankInfoModel]()
                for selectNode in currentRankSelected {
                    for node in searchFactoryList.rankList {
                        if selectNode.rankName == node.rankName {
                            currentArr.append(selectNode)
                            break;
                        }
                    }
                }
                currentRankSelected = currentArr
            }
        }
    }
}
