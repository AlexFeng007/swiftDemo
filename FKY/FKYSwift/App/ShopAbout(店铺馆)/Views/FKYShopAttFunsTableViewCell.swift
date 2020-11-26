//
//  FKYShopAttFunsTableViewCell.swift
//  FKY
//
//  Created by yyc on 2020/10/15.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYShopAttFunsTableViewCell: UITableViewCell {
    // MARK: - Property
    var clickNavItemBlock : ((Int,FKYUltimateShopModel)->(Void))? //点击导航按钮or全部商品
    var ultimageList : [FKYUltimateShopModel]? //数据源
    //背景
    fileprivate lazy var bgView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = WH(8)
        view.layer.masksToBounds = true
        return view
    }()
    
    fileprivate lazy var titleView : FKYShopAttHeadView = {
        let view = FKYShopAttHeadView()
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
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(WH(9))
            make.right.equalTo(contentView.snp.right).offset(-WH(10))
            make.left.equalTo(contentView.snp.left).offset(WH(10))
            make.bottom.equalTo(contentView.snp.bottom).offset(-WH(2))
        }
        bgView.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(bgView)
            make.height.equalTo(WH(43))
        }
        
        bgView.addSubview(fucCollectionView)
        fucCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom).offset(WH(6))
            make.left.equalTo(bgView.snp.left)
            make.right.equalTo(bgView.snp.right)
            make.height.equalTo(WH(58))
        }
        bgView.addSubview(contentBgView)
        contentBgView.addSubview(selectedBgView)
        let bannerWidth = WH(14)
        contentBgView.snp.makeConstraints { (make) in
            make.bottom.equalTo(bgView).offset(WH(-15))
            make.centerX.equalTo(bgView)
            make.height.equalTo(WH(3))
            make.width.equalTo(bannerWidth)
        }
        selectedBgView.frame = CGRect(x: 0, y: 0, width: bannerWidth, height: WH(3))
    }
    // MARK: - Public
    
    // 配置cell
    func configCell(_ ultimateArr: [FKYUltimateShopModel]?) {
        self.isHidden = true
        contentBgView.isHidden = true
        if let arr = ultimateArr ,arr.count > 0 {
            self.isHidden = false
            self.ultimageList = arr
            contentBgView.isHidden = false
            bannerBgWidth = WH(14) * CGFloat(arr.count/5)
            if arr.count%5 == 0{
                bannerBgWidth = WH(14) * CGFloat(arr.count/5)
            }else{
                bannerBgWidth = WH(14) * CGFloat(arr.count/5 + 1)
            }
            if arr.count < 6 {
                contentBgView.isHidden = true
            }
            contentBgView.snp.remakeConstraints { (make) in
                make.bottom.equalTo(bgView).offset(WH(-15))
                make.centerX.equalTo(bgView)
                make.height.equalTo(WH(3))
                make.width.equalTo(bannerBgWidth)
            }
            titleView.resetShopAttentionHeadView(1)
            fucCollectionView.reloadData()
        }
    }

}
extension FKYShopAttFunsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let arr = ultimageList, arr.count > 0 {
            return  arr.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (SCREEN_WIDTH-WH(20))/5.0, height:WH(58))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: WH(0), bottom: 0, right:WH(0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeFuctionBtCollCell", for: indexPath) as! HomeFuctionBtCollCell
        if let arr = ultimageList, indexPath.item < arr.count {
            cell.resetShopAttentionFuntionView(arr[indexPath.item])
        }
        return cell
    }
    
    //选中item会触发的方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let arr = ultimageList, indexPath.item < arr.count {
            if let block = self.clickNavItemBlock {
                block(indexPath.item,arr[indexPath.item])
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
    static func  getCellContentHeight(_ ultimateArr: [FKYUltimateShopModel]?) -> CGFloat{
        var cell_H = WH(0)
        if let arr = ultimateArr , arr.count > 0 {
            cell_H = WH(9) + WH(43) + WH(6) + WH(58)
            if arr.count < 6 {
                cell_H = cell_H + WH(7)
            }else {
                cell_H = cell_H + WH(25)
            }
        }
        return cell_H
    }
}


