//
//  ShopDetailCouponView.swift
//  FKY
//
//  Created by 乔羽 on 2018/5/22.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class ShopDetailCouponView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    fileprivate lazy var imgviewDetail: UIImageView! = {
        let imgview = UIImageView()
        imgview.image = UIImage.init(named: "icon_shopdetail_arrow_down_black")
        imgview.contentMode = UIView.ContentMode.scaleAspectFit
        return imgview
    }()
    
    fileprivate lazy var lblTitle: UILabel! = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.text = "优惠券"
        lbl.textAlignment = .left
        lbl.textColor = RGBColor(0x5C5C5C)
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    
    fileprivate lazy var collectionview: UICollectionView! = {
        let layout = UICollectionViewLeftAlignedLayout.init()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = WH(5)
        layout.minimumLineSpacing = WH(10)
        //layout.itemSize = CGSize(width: WH(88), height: WH(20))
        
        let view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self;
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.register(PDCouponItemCCell.self, forCellWithReuseIdentifier: "PDCouponItemCCell")
        return view
    }()
    
    // 优惠券数据源
    var arrayCoupon = [CouponTempModel]()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    
    func setupView() {
        self.backgroundColor = RGBColor(0xFFF0F1)
        
        self.addSubview(self.lblTitle)
        self.lblTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(WH(10))
            make.left.equalTo(self).offset(j1)
            make.height.equalTo(WH(20))
            make.width.equalTo(WH(40))
        }
        self.addSubview(self.collectionview)
        
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFF0F1)
        view.addSubview(self.imgviewDetail)
        self.addSubview(view)
        
        view.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.right.equalTo(self).offset(-j1)
            make.width.equalTo(WH(12))
        }
        
        self.imgviewDetail.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(view)
            make.width.equalTo(WH(12))
            make.height.equalTo(WH(6))
        }
        
        self.collectionview.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(j1)
            make.bottom.equalTo(self).offset(-j1)
            make.left.equalTo(self.lblTitle.snp.right).offset(j1)
            make.right.equalTo(self).offset(-j1)
        }
    }
    
    
    // MARK: - Public
    
    // 配置view
    func configView(_ showContent: Bool, couponList: Array<CouponTempModel>?) {
        self.lblTitle?.isHidden = !showContent
        self.imgviewDetail?.isHidden = !showContent
        self.collectionview?.isHidden = !showContent
        
        self.arrayCoupon.removeAll()
        if let list = couponList, list.isEmpty == false {
            // 最多只显示4条
            let count = list.count > 4 ? 4 : list.count
            for index in 0..<count {
                self.arrayCoupon.append(list[index])
            }
        }
        self.collectionview.reloadData()
    }
    
    // 获取collectionview的内容高度 + 上下margin高度
    func getCollectionviewContentHeight() -> CGFloat {
        return 44
    }
    
    
    // MARK: - Private
    
    
    
    // MARK: - UICollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayCoupon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 动态适配宽度
        // let width = FKYPDCouponItemCCell.getCouponItemWidth(self.arrayCoupon[indexPath.row])
        // return CGSize(width: width, height: WH(20))
        // 固定宽度
        return CGSize(width: WH(88), height: WH(20))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PDCouponItemCCell", for: indexPath) as! PDCouponItemCCell
        cell.configCell(true, self.arrayCoupon[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }

}
