//
//  COInstalmentPayView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/23.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  选择在线支付方式之花呗分期选择视图view

import UIKit

class COInstalmentPayView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - Property
    
    // closure
    var selectBlock: ((Int)->())?  // 选择分期方式回调
    
    // 分期数组
    var payTypeList = [COAlipayInstallmentItemModel]()
    
    // 当前选择的分期项
    var indexSelected: Int = -1
    
    // 图片视图
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        // 设置滚动的方向
        flowLayout.scrollDirection = .vertical
        // 设置item的大小
        flowLayout.itemSize = CGSize(width: (SCREEN_WIDTH - WH(30) * 2 - WH(20)) / 2, height: WH(58))
        // 设置同一组当中，行与行之间的最小行间距
        flowLayout.minimumLineSpacing = WH(12)
        // 设置同一行的cell中互相之间的最小间隔
        flowLayout.minimumInteritemSpacing = WH(12)
        // 设置section距离边距的距离
        flowLayout.sectionInset = UIEdgeInsets(top: WH(10), left: WH(30), bottom: WH(20), right: WH(30))
        
        let view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.backgroundColor = UIColor.clear
        view.delegate = self
        view.dataSource = self
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.register(COInstalmentTypeCCell.self, forCellWithReuseIdentifier: "COInstalmentTypeCCell")
        return view
    }()
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .white
        
        collectionView.reloadData()
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: WH(0), left: WH(0), bottom: WH(0), right: WH(0)))
        }
    }
    
    
    // MARK: - Public
    
    //
    func configView(_ list: [COAlipayInstallmentItemModel]?) {
        payTypeList.removeAll()
        if let list = list, list.count > 0 {
            payTypeList.append(contentsOf: list)
        }
        collectionView.reloadData()
    }
    
    // 刷新并实时获取内容高度
    func getContentHeight() -> CGFloat {
        guard payTypeList.count > 0 else {
            return 0
        }
        // 刷新
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        // 获取内容高度
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        return height
    }
    
    // 刷新
    func reloadAllInstallmentData() {
        collectionView.reloadData()
    }
    
    
    // MARK: - UICollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return payTypeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:(SCREEN_WIDTH - WH(30) * 2 - WH(20)) / 2, height:WH(58))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(10), left: WH(30), bottom: WH(20), right: WH(30))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return WH(12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return WH(12)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "COInstalmentTypeCCell", for: indexPath) as! COInstalmentTypeCCell
        // 配置cell
        let item: COAlipayInstallmentItemModel = payTypeList[indexPath.row]
        cell.configCell(item)
        // 选中状态更新
        if indexPath.row == indexSelected {
            cell.updateSelectedStatus(true)
        }
        else {
            cell.updateSelectedStatus(false)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 当前选中项索引
        let select = indexPath.row
        // 保存
        indexSelected = select
        // 刷新界面UI
        collectionView.reloadData()
        // 选择回调
        if let block = selectBlock {
            block(indexSelected)
        }
    }
}



// MARK: - 花呗分期类型ccell
class COInstalmentTypeCCell: UICollectionViewCell {
    // MARK: - Property
    
    // 背景视图
    fileprivate lazy var viewBg: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(4)
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.borderWidth = 0.0
        return view
    }()
    
    // 选中图片
    fileprivate lazy var imgviewPic: UIImageView! = {
        let imgview = UIImageView()
        imgview.contentMode = .scaleToFill
        imgview.image = UIImage.init(named: "img_checkorder_selected_alipay")
        return imgview
    }()
    
    // 期数
    fileprivate lazy var lblNumber: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .center
        //lbl.text = "￥7674.06 × 3期"
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    
    // 手续费
    fileprivate lazy var lblCost: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(10))
        lbl.textColor = RGBColor(0x999999)
        lbl.textAlignment = .center
        //lbl.text = "手续费￥172.66/期"
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.9
        return lbl
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = UIColor.clear
        
        contentView.addSubview(viewBg)
        contentView.addSubview(imgviewPic)
        contentView.addSubview(lblNumber)
        contentView.addSubview(lblCost)
        
        viewBg.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        imgviewPic.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(WH(10))
            make.size.equalTo(CGSize.init(width: WH(9), height: WH(7)))
        }
        lblNumber.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(WH(12))
            make.left.equalTo(contentView).offset(WH(23))
            make.right.equalTo(contentView).offset(-WH(5))
            make.height.equalTo(WH(18))
        }
        lblCost.snp.makeConstraints { (make) in
            make.top.equalTo(lblNumber.snp.bottom).offset(WH(4))
            make.left.equalTo(contentView).offset(WH(23))
            make.right.equalTo(contentView).offset(-WH(5))
            make.height.equalTo(WH(16))
        }
        
        imgviewPic.isHidden = true
    }
    
    
    // MARK: - Public
    
    // 配置cell
    func configCell(_ model: COAlipayInstallmentItemModel) {
        // 每期本金
        var eachPrin = "0.00"
        if let value = model.eachPrin, value > 0 {
            eachPrin = String(format: "%.2f", value)
        }
        // 分期数
        var hbFqNum = ""
        if let value = model.hbFqNum, value >= 0 {
            hbFqNum = "\(value)"
        }
        // 每期手续费
        var eachFee = "0.00"
        if let value = model.eachFee, value > 0 {
            eachFee = String(format: "%.2f", value)
        }
        
        lblNumber.text = "￥" + eachPrin + " x " + hbFqNum + "期"
        lblCost.text = "手续费￥" + eachFee + "/期"
    }
    
    // 更新选中状态
    func updateSelectedStatus(_ selected: Bool) {
        if selected {
            // 已选中
            viewBg.backgroundColor = RGBColor(0xFFEDE7)
            lblNumber.textColor = RGBColor(0xFF2D5C)
            lblCost.textColor = RGBColor(0xFF2D5C)
            imgviewPic.isHidden = false
            viewBg.layer.borderColor = RGBColor(0xFF2D5C).cgColor
            viewBg.layer.borderWidth = 1.0
        }
        else {
            // 未选中
            viewBg.backgroundColor = RGBColor(0xF4F4F4)
            lblNumber.textColor = RGBColor(0x333333)
            lblCost.textColor = RGBColor(0x999999)
            imgviewPic.isHidden = true
            viewBg.layer.borderColor = UIColor.clear.cgColor
            viewBg.layer.borderWidth = 0.0
        }
    }
}
