//
//  PDCouponCell.swift
//  FKY
//
//  Created by 夏志勇 on 2017/12/29.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  商详之优惠券cell

import UIKit

class PDCouponCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //MARK: - Property
    
    fileprivate lazy var imgviewArrow: UIImageView! = {
        let imgview = UIImageView()
        //imgview.image = UIImage.init(named: "icon_account_black_arrow")
        //imgview.image = UIImage.init(named: "img_pd_group_arrow")
        imgview.image = UIImage.init(named: "img_pd_arrow_gray")
        imgview.contentMode = UIView.ContentMode.scaleAspectFit
        return imgview
    }()
    
    fileprivate lazy var lblTitle: UILabel! = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.text = "优惠券"
        lbl.textAlignment = .left
        lbl.textColor = RGBColor(0x000000)
        lbl.font = UIFont.boldSystemFont(ofSize: WH(14))
        return lbl
    }()
    
    fileprivate lazy var collectionview: UICollectionView! = {
        let layout = UICollectionViewFlowLayout()
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
    var arrayCoupon = [CommonCouponNewModel]()
//    var arrayCoupon = [FKYProductCouponModel]() {
//        didSet {
//            // 每次设置／更新数据源后均自动刷新
//            collectionview.reloadData()
//        }
//    }
    
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = RGBColor(0xFFFFFF)
        contentView.backgroundColor = RGBColor(0xFFFFFF)
        
        contentView.addSubview(imgviewArrow)
        imgviewArrow.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(WH(15))
            make.right.equalTo(contentView).offset(WH(-5))
            make.size.equalTo(CGSize.init(width: WH(20), height: WH(20)))
        }
        
        contentView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { (make) in
            //make.centerY.equalTo(contentView)
            make.top.equalTo(contentView).offset(WH(15))
            make.left.equalTo(contentView).offset(WH(10))
            make.height.equalTo(WH(20))
        }
        
        contentView.addSubview(collectionview)
        collectionview.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(WH(15))
            make.bottom.equalTo(contentView).offset(WH(-15))
            make.left.equalTo(lblTitle.snp.right).offset(WH(10))
            make.right.equalTo(imgviewArrow.snp.left).offset(WH(-5))
        }
    }
    
    
    // MARK: - Public
    
    // 配置cell
    @objc func configCell(_ showContent: Bool, couponList: Array<CommonCouponNewModel>?) {
        lblTitle?.isHidden = !showContent
        imgviewArrow?.isHidden = !showContent
        collectionview?.isHidden = !showContent
        
        arrayCoupon.removeAll()
        if let list = couponList, list.isEmpty == false {
            // 最多只显示3条
            let count = (list.count > 3 ? 3 : list.count)
            for index in 0..<count {
                arrayCoupon.append(list[index])
            }
            //arrayCoupon.append(contentsOf: list)
        }
        collectionview.reloadData()
    }
    
    // 获取collectionview的内容高度 + 上下margin高度
    func getCollectionviewContentHeight() -> CGFloat {
        collectionview.reloadData()
        return collectionview.collectionViewLayout.collectionViewContentSize.height + WH(15) * 2
    }
    
    
    // MARK: - UICollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayCoupon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 动态适配宽度
//        let width = FKYPDCouponItemCCell.getCouponItemWidth(arrayCoupon[indexPath.row])
//        return CGSize(width: width, height: WH(20))
        // 固定宽度
        return CGSize(width: WH(88), height: WH(20))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PDCouponItemCCell", for: indexPath) as! PDCouponItemCCell
        cell.configCell(true, arrayCoupon[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
}
