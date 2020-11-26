//
//  ShopNavBtnListCell.swift
//  FKY
//
//  Created by 寒山 on 2020/3/31.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  店铺内导航按钮

import UIKit

class ShopNavBtnListCell: UITableViewCell {
    
    // MARK: - Property
    // var isVisualAble = true  //是否可见 在首页曝光里使用
    fileprivate lazy var operation: HomePresenter = HomePresenter()
    // closure
    fileprivate var callback: HomeCellActionCallback?
    
    var clickNavItemBlock : ((Int,HomeFucButtonItemModel)->(Void))? //点击导航按钮
    // 数据源
    fileprivate var fucBtModels: HomeFucButtonModel? {
        didSet {
            fucCollectionView.reloadData()
        }
    }
    //选中的的背景
    fileprivate lazy var bgView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    fileprivate lazy var fucCollectionView: UICollectionView! = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        //设置滚动的方向  horizontal水平混动
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(HomeFuctionBtCollCell.self, forCellWithReuseIdentifier: "HomeFuctionBtCollCell")
        view.backgroundColor = UIColor.white
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        view.isPagingEnabled = false
        return view
    }()
    
    var bannerBgWidth = WH(14)
    
    //选中的的背景
    fileprivate lazy var contentBgView : UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xECE6E7)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(1.5)
        view.clipsToBounds = true
        return view
    }()
    //选中的横条
    fileprivate lazy var selectedBgView : UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFF2D5C)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(1.5)
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    // MARK: - UI
    
    func setupView() {
        self.backgroundColor = RGBColor(0xF4F4F4)
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.contentView.snp.bottom).offset(WH(-10))
            make.left.right.top.equalTo(self.contentView)
        }
        
        bgView.addSubview(fucCollectionView)
        fucCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.top).offset(WH(10))
            make.left.equalTo(bgView.snp.left)
            make.right.equalTo(bgView.snp.right)
            make.height.equalTo(WH(66))
        }
        bgView.addSubview(contentBgView)
        contentBgView.addSubview(selectedBgView)
        let bannerWidth = WH(14)
        contentBgView.snp.makeConstraints { (make) in
            make.bottom.equalTo(bgView).offset(WH(-8))
            make.centerX.equalTo(bgView)
            make.height.equalTo(WH(3))
            make.width.equalTo(bannerWidth)
        }
        selectedBgView.frame = CGRect(x: 0, y: 0, width: bannerWidth, height: WH(3))
        
    }
    // MARK: - Public
    
    // 配置cell
    func configCell(_ fucBtModel: HomeFucButtonModel?) {
        fucBtModels = fucBtModel
        if let model = self.fucBtModels ,let itemsCount = model.navigations {
            contentBgView.isHidden = false
            bannerBgWidth = WH(14) * CGFloat(itemsCount.count/5)
            if itemsCount.count%5 == 0{
                bannerBgWidth = WH(14) * CGFloat(itemsCount.count/5)
            }else{
                bannerBgWidth = WH(14) * CGFloat(itemsCount.count/5 + 1)
            }
            if itemsCount.count < 6 {
                contentBgView.isHidden = true
            }
            contentBgView.snp.remakeConstraints { (make) in
                make.bottom.equalTo(bgView).offset(WH(-8))
                make.centerX.equalTo(bgView)
                make.height.equalTo(WH(3))
                make.width.equalTo(bannerBgWidth)
            }
            
        }
    }
    
}
extension ShopNavBtnListCell: HomeCellInterface {
    static func calculateHeight(withModel model: HomeModelInterface, tableView: UITableView, identifier: String, indexPath: IndexPath) -> CGFloat {
        return WH(102)
    }
    
    func bindOperation(_ callback: @escaping HomeCellActionCallback) {
        self.callback = callback
    }
    
    func bindModel(_ model: HomeModelInterface) {
        if let m = model as? HomeFucButtonModel {
            configCell(m)
        }
        else {
            configCell(nil)
        }
    }
}

extension ShopNavBtnListCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let model = self.fucBtModels ,let itemsCount = model.navigations {
            return  itemsCount.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let model = self.fucBtModels ,let itemsCount = model.navigations {
            if itemsCount.count < 5 && itemsCount.count != 0{
                return CGSize(width: SCREEN_WIDTH/CGFloat(itemsCount.count), height:WH(66))
            }
        }
        return CGSize(width: SCREEN_WIDTH/5.0, height:WH(66))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: WH(0), bottom: 0, right:WH(0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeFuctionBtCollCell", for: indexPath) as! HomeFuctionBtCollCell
        cell.config(model: self.fucBtModels?.navigations![indexPath.item],HomeFucAlign.Center)
        
        return cell
    }
    
    //选中item会触发的方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let navigations = self.fucBtModels?.navigations {
            if let block = self.clickNavItemBlock {
                block(indexPath.item,navigations[indexPath.item])
            }
//            let action = HomeTemplateAction()
//            action.actionType = .navigation014_clickItem
//            let model = navigations[indexPath.item]
//            if model.name != nil{
//                action.itemName = model.name!
//            }
//            action.actionParams = [HomeString.ACTION_KEY:model]
            
            //            action.itemCode = ITEMCODE.HOME_NAVIGATION_CLICK_CODE.rawValue
            //            action.itemPosition = String(indexPath.item + 1 + indexPath.section*5)
            //            action.floorPosition = "1"
            //            action.floorName = "运营首页"
            //            action.floorCode = FLOORID.HOME_RECOMMEND_PRODUCT_FLOOR.rawValue
            //            action.sectionName = "导航按钮"
            //self.operation.onClickCellAction(action)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    // 已开始滑动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateSelectConentPos()
    }
    
    // 用户手动滑动结束后调用此方法
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // scrollKeyMethod()
        updateSelectConentPos()
    }
    
    //    // 用户手动滑动开始
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        updateSelectConentPos()
    }
    
    // 用户手动滑动结束
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        updateSelectConentPos()
    }
    func updateSelectConentPos(){
        if self.fucCollectionView.contentSize.width <= SCREEN_WIDTH{
            selectedBgView.frame = CGRect(x: 0, y: 0, width: WH(14), height: WH(3))
        }else{
            selectedBgView.frame = CGRect(x: (self.fucCollectionView.contentOffset.x/(self.fucCollectionView.contentSize.width - SCREEN_WIDTH)) * (bannerBgWidth - WH(14)), y: 0, width: WH(14), height: WH(3))
        }
    }
    static func  getCellContentHeight(_ fucBtModel: HomeFucButtonModel?) -> CGFloat{
        if let model = fucBtModel ,let itemsCount = model.navigations {
          if itemsCount.count < 6 {
              return WH(89) + WH(10)
          }
        }
        return WH(96) + WH(10)
    }
}


