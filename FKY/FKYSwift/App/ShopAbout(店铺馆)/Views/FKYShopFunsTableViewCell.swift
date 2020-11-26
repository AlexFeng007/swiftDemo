//
//  FKYShopFunsTableViewCell.swift
//  FKY
//
//  Created by yyc on 2020/10/14.
//  Copyright © 2020 yiyaowang. All rights reserved.
//店铺馆导航按钮

import UIKit

let top_coll_h = WH(16) //顶部间距
let space_coll_h = WH(11) //两行的间距

class FKYShopFunsTableViewCell: UITableViewCell {

    // MARK: - UI属性
//    fileprivate lazy var recommendLayout: FKYHorizontalPageFlowLayout = {
//        let layout = FKYHorizontalPageFlowLayout.init()
//        layout.scrollDirection = .horizontal
//        layout.rowCount = self.rowNumber
//        layout.itemCountPerRow = self.columnNumber
//        layout.rowSpacing = space_coll_h
//        layout.columnSpacing = 0
//        layout.edgeInsets = UIEdgeInsets.zero
//        return layout
//    }()
    
    fileprivate lazy var fucCollectionView: UICollectionView! = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        //设置滚动的方向  horizontal水平混动
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = space_coll_h
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        view.register(HomeFuctionBtCollCell.self, forCellWithReuseIdentifier: "HomeFuctionBtCollCell")
        view.backgroundColor = RGBColor(0xF4F4F4)
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
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
    
    
    // 每页行数
    fileprivate var rowNumber = 2
    // 每行单元格item个数（列数）
    fileprivate var columnNumber = 5
    
    fileprivate var navigationArr:[HomeFucButtonItemModel]?
    
    
    fileprivate var nav_w : CGFloat = 0
    fileprivate var bannerBgWidth = WH(14)
    
    var clickItem:((Int,HomeFucButtonItemModel)->(Void))? //点击item
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
extension FKYShopFunsTableViewCell {
    fileprivate func setupView() {
        self.backgroundColor = RGBColor(0xF4F4F4)
        contentView.addSubview(fucCollectionView)
        fucCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(top_coll_h)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(HOME_NAV_ITEM_H)
        }
        contentView.addSubview(contentBgView)
        contentBgView.addSubview(selectedBgView)
        contentBgView.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView).offset(WH(-15))
            make.centerX.equalTo(contentView)
            make.height.equalTo(WH(3))
            make.width.equalTo(WH(0))
        }
        selectedBgView.frame = CGRect(x: 0, y: 0, width: WH(14), height: WH(3))
    }
}
extension FKYShopFunsTableViewCell {
    // 配置cell
    func configCell(_ navigationArr:[HomeFucButtonItemModel]?) {
        self.navigationArr = navigationArr
        self.isHidden = true
        contentBgView.isHidden = true
        if let itemsArr = navigationArr {
            self.isHidden = false
            let itemsCount = itemsArr.count
            self.nav_w = SCREEN_WIDTH/CGFloat(5)
            if  itemsCount <= 5 {
                //一行
                fucCollectionView.snp.updateConstraints { (make) in
                    make.height.equalTo(ceil(HOME_NAV_ITEM_H))
                }
                self.nav_w = SCREEN_WIDTH/CGFloat(itemsCount)
                rowNumber = 1
                columnNumber = itemsCount
            }else if itemsCount < 10 {
                //一行左右滑动
                fucCollectionView.snp.updateConstraints { (make) in
                    make.height.equalTo(ceil(HOME_NAV_ITEM_H))
                }
                rowNumber = 1
                columnNumber = 5
                contentBgView.isHidden = false
            }else if itemsCount == 10{
                //两行
                fucCollectionView.snp.updateConstraints { (make) in
                    make.height.equalTo(ceil(HOME_NAV_ITEM_H*2+space_coll_h))
                }
                rowNumber = 2
                columnNumber = 5
            }else {
                //两行左右滑动
                fucCollectionView.snp.updateConstraints { (make) in
                    make.height.equalTo(ceil(HOME_NAV_ITEM_H*2+space_coll_h))
                }
                rowNumber = 2
                columnNumber = 5
                contentBgView.isHidden = false
            }
            //显示滑动
            if contentBgView.isHidden == false {
                if itemsCount%(5*rowNumber) == 0{
                    bannerBgWidth = WH(14) * CGFloat(itemsCount/(5*rowNumber))
                }else{
                    bannerBgWidth = WH(14) * CGFloat(itemsCount/(5*rowNumber) + 1)
                }
                contentBgView.snp.remakeConstraints { (make) in
                    make.bottom.equalTo(contentView).offset(WH(-15))
                    make.centerX.equalTo(contentView)
                    make.height.equalTo(WH(3))
                    make.width.equalTo(bannerBgWidth)
                }
            }
            //recommendLayout.setRowCountAndColumnCount(rowNumber, columnNumber)
        }
        self.fucCollectionView.reloadData()
    }
    
    static func getShopFucListeCellHeight(_ navigationArr:[HomeFucButtonItemModel]?) -> CGFloat {
        if let itemsCount = navigationArr, itemsCount.count > 0{
            if  itemsCount.count <= 5 {
                //一行
                return top_coll_h + HOME_NAV_ITEM_H + WH(11)
            }else if itemsCount.count < 10 {
                //一行有分页
                return top_coll_h + HOME_NAV_ITEM_H + WH(11+18)
            }else if itemsCount.count == 10 {
                return top_coll_h + HOME_NAV_ITEM_H*2 + space_coll_h*2
            }else {
                //两行有分页
                return top_coll_h + HOME_NAV_ITEM_H*2 + space_coll_h + WH(11+18)
            }
        }
        return  WH(0)
    }
}
extension FKYShopFunsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let itemsArr = self.navigationArr {
            return itemsArr.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.nav_w, height:HOME_NAV_ITEM_H)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: WH(0), bottom: 0, right:WH(0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return  space_coll_h
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeFuctionBtCollCell", for: indexPath) as! HomeFuctionBtCollCell
        cell.contentView.backgroundColor = RGBColor(0xf4f4f4)
        if let itemsArr = self.navigationArr {
            if indexPath.item < itemsArr.count {
                cell.config(model: itemsArr[indexPath.item],HomeFucAlign.Center)
            }
        }
        return cell
    }
    
    //选中item会触发的方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let navigations = self.navigationArr {
            if let block = self.clickItem,indexPath.item < navigations.count{
                block(indexPath.item,navigations[indexPath.item])
            }
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    // 已开始滑动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateSelectConentPos()
    }
    
    // 用户手动滑动结束后调用此方法
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
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
}
