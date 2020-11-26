//
//  LiveNoticeCouponCell.swift
//  FKY
//
//  Created by yyc on 2020/8/21.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class LiveNoticeCouponCell: UITableViewCell {
    //MARK:ui属性
    //标题
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = t7.color
        label.font = t21.font
        label.text = "本场可领优惠券"
        return label
    }()
    //优惠券列表
    fileprivate lazy var couponsView: UICollectionView! = {
        let flowLayout = UICollectionViewFlowLayout()
        //设置滚动的方向  horizontal水平混动
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(FKYCouponsViewCell.self, forCellWithReuseIdentifier: "FKYCouponsViewCell")
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = RGBColor(0xffffff)
        view.delegate = self
        view.dataSource = self
        view.isScrollEnabled = false
        return view
    }()
    
    //分隔线
    fileprivate lazy var spaceView: UIView = {
        let view = UIImageView()
        view.backgroundColor =  RGBColor(0xF4F4F4)
        return view
    }()
    
    //业务属性
    var clickCouponsTableView : ((Int,Int,CommonCouponNewModel)->(Void))? //点击视图（1:立即领取 2:查看可用商品 3:可用商家）
    var couponArr = [CommonCouponNewModel]() //优惠券列表
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.isHidden = true
        self.backgroundColor = RGBColor(0xffffff)
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.contentView.snp.left).offset(WH(10))
            make.top.equalTo(self.contentView.snp.top).offset(WH(14))
            make.height.equalTo(WH(12))
            make.right.equalTo(self.contentView.snp.right).offset(-WH(10))
        })
        self.contentView.addSubview(spaceView)
        spaceView.snp.makeConstraints({ (make) in
            make.bottom.left.right.equalTo(self.contentView)
            make.height.equalTo(WH(10))
        })
        
        self.contentView.addSubview(couponsView)
        couponsView.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self.contentView)
            make.top.equalTo(titleLabel.snp.bottom).offset(WH(14))
            make.bottom.equalTo(spaceView.snp.top).offset(-WH(14))
        })
    }
}
extension LiveNoticeCouponCell {
    func configShopCouponsViewData(_ dataArr :[CommonCouponNewModel]){
        if dataArr.count > 0 {
            self.couponArr = dataArr
            couponsView.reloadData()
            self.isHidden = false
        }else {
            self.couponArr = [CommonCouponNewModel]()
            couponsView.reloadData()
            self.isHidden = true
        }
    }
    //计算高度
    static func configShopCouponsTableViewH(_ dataArr : [CommonCouponNewModel]?) -> CGFloat{
        if let arr = dataArr ,arr.count > 0 {
            let numLines = ceil(Double(arr.count)/2.0)
            return CGFloat(numLines)*(SHOP_COUPONS_H+WH(3))-WH(3) + WH(10+14+14+14+10)
        }else {
            return 0
        }
    }
}

extension LiveNoticeCouponCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.couponArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:(SCREEN_WIDTH-WH(23))/2.0, height:SHOP_COUPONS_H)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:WH(0), left: WH(10), bottom: WH(0), right: WH(10))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return WH(3)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYCouponsViewCell", for: indexPath) as! FKYCouponsViewCell
        cell.configLiveNoticeCell(self.couponArr[indexPath.item])
        cell.clickCouponsView = { [weak self] (typeIndex) in
            if let strongSelf = self {
                if let block = strongSelf.clickCouponsTableView {
                    block(typeIndex,indexPath.item,strongSelf.couponArr[indexPath.item])
                }
            }
        }
        return cell
    }
    
}
