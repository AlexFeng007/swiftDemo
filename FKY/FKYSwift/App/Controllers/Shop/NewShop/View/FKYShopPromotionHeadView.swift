//
//  FKYShopPromotionHeadView.swift
//  FKY
//
//  Created by hui on 2019/10/30.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYShopPromotionHeadView: UIView {
    //MARK:ui属性
    //促销类型
    fileprivate lazy var promotionView: UICollectionView! = {
        let flowLayout = UICollectionViewFlowLayout()
        //设置滚动的方向  horizontal水平混动
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(FKYPromotionViewCell.self, forCellWithReuseIdentifier: "FKYPromotionViewCell")
        view.backgroundColor = RGBColor(0xFFFFFF)
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(8)
        return view
    }()
    
    // 底部分隔线
    fileprivate lazy var bottomLine : UIView = {
        let view = UIView()
        view.backgroundColor = bg7
        view.isHidden = true
        return view
    }()
    
    //功能属性
    var clickViewBock : ((Int)->(Void))? //点击视图
    var selectIndexItem = 0 //选中的item
    var tabModelArr : [FKYShopPromotionTabModel]? //数据源
    fileprivate var remainingSpaceNum : CGFloat = 0 //剩余间隔
    fileprivate var itemTotalNum :CGFloat = WH(14) //计算的总宽度
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.backgroundColor = RGBColor(0xF4F4F4)
        self.addSubview(promotionView)
        promotionView.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(self.snp.left).offset(WH(10))
            make.right.equalTo(self.snp.right).offset(-WH(10))
        })
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints({ (make) in
            make.bottom.left.right.equalTo(self)
            make.height.equalTo(0.5)
        })
    }
    
}
extension FKYShopPromotionHeadView {
    //赋值
    func configShopPromotionViewData(_ tabArr:[FKYShopPromotionTabModel]){
        self.tabModelArr = tabArr
        if tabArr.count > 0 {
            for tabModel in tabArr {
                self.itemTotalNum = self.itemTotalNum + tabModel.str_w + WH(20)
            }
            //计算去除需要的宽度后，还剩余的宽度来平分
            let num = (SCREEN_WIDTH-WH(20)) - (self.itemTotalNum+WH(20))
            if num >= 0 {
                self.remainingSpaceNum = num/CGFloat(tabArr.count+1)
            }
        }
        promotionView.reloadData()
    }
    //重置选中项
    func changeSelectedViewData(_ seletedIndex:Int){
        if let tabArr = self.tabModelArr ,tabArr.count >= 4 ,seletedIndex < tabArr.count {
            self.selectIndexItem = seletedIndex
            //计算去除需要的宽度后，还剩余的宽度来平分
            let num = (SCREEN_WIDTH-WH(20)) - (self.itemTotalNum+WH(20))
            if num >= 0 {
                self.remainingSpaceNum = num/CGFloat(tabArr.count+1)
            }
            promotionView.reloadData()
            promotionView.scrollToItem(at: IndexPath.init(row: seletedIndex, section: 0), at: .centeredHorizontally, animated: true)
            
        }
    }
    //设置视图的布局
    func resetPromotionLayout(_ leftOrRightW :CGFloat){
        if let tabArr = self.tabModelArr ,tabArr.count >= 4 {
            if leftOrRightW == WH(0) {
                promotionView.layer.cornerRadius = WH(0)
                bottomLine.isHidden = false
            }else {
                promotionView.layer.cornerRadius = WH(8)
                bottomLine.isHidden = true
            }
            promotionView.snp.updateConstraints({ (make) in
                make.left.equalTo(self.snp.left).offset(leftOrRightW)
                make.right.equalTo(self.snp.right).offset(-leftOrRightW)
            })
            //计算去除需要的宽度后，还剩余的宽度来平分
            let num = (SCREEN_WIDTH - leftOrRightW - leftOrRightW) - (self.itemTotalNum+WH(20))
            if num >= 0 {
                self.remainingSpaceNum = num/CGFloat(tabArr.count+1)
                self.promotionView.reloadData()
            }
        }
    }
}
extension FKYShopPromotionHeadView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let arr = self.tabModelArr {
            return arr.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let arr = self.tabModelArr {
            let tabModel = arr[indexPath.item]
            if indexPath.row == self.selectIndexItem {
                return CGSize(width:tabModel.str_w+WH(20+14)+self.remainingSpaceNum, height:WH(40))
            }else {
                return CGSize(width:tabModel.str_w+WH(20)+self.remainingSpaceNum, height:WH(40))
            }
        }
        return CGSize(width:WH(0), height:WH(0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(0), left: WH(0), bottom: WH(0), right: WH(20)+self.remainingSpaceNum)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return WH(0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYPromotionViewCell", for: indexPath) as! FKYPromotionViewCell
        if let arr = self.tabModelArr {
            cell.configCell(indexPath.row == self.selectIndexItem,arr[indexPath.item])
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        if let block = self.clickViewBock {
            block(indexPath.item)
            self.selectIndexItem = indexPath.item
            collectionView.reloadData()
        }
    }
    
}
//MARK:促销类型视图
class FKYPromotionViewCell: UICollectionViewCell {
    //定位图标
    fileprivate var iconView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named:"shop_promotion_icon_pic")
        return img
    }()
    //使用条件描述
    fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t7
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.right.equalTo(contentView.snp.right)
        }
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.right.equalTo(titleLabel.snp.left).offset(-WH(4))
        }
    }
    
    func configCell(_ selected: Bool,_ model:FKYShopPromotionTabModel) {
        iconView.isHidden = !selected
        titleLabel.textColor = selected ? t73.color : t7.color
        titleLabel.text = model.theme
    }
    
}
