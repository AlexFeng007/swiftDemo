//
//  RCListProductListCell.swift
//  FKY
//
//  Created by 乔羽 on 2018/10/30.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import UIKit

class RCListProductListCell: UITableViewCell {
    
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        // 设置item的大小
        flowLayout.itemSize = CGSize(width: WH(80), height: WH(80))
        // 设置滚动的方向
        flowLayout.scrollDirection = .horizontal
        // 设置同一组当中，行与行之间的最小行间距
        flowLayout.minimumLineSpacing = WH(8)
        // 设置同一行的cell中互相之间的最小间隔
        flowLayout.minimumInteritemSpacing = WH(8)
        // 设置section距离边距的距离
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: WH(15), bottom: 0, right: WH(15))
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.register(RCListProductCCell.self, forCellWithReuseIdentifier: "RCListProductCCell")
        cv.backgroundColor = RGBColor(0xf7f7f7)
        cv.isScrollEnabled = false
        cv.delegate = self
        cv.dataSource = self
        cv.isUserInteractionEnabled = false
        return cv
    }()
    
    fileprivate lazy var dataSource: Array<RCListProductModel> = [ ]
    fileprivate lazy var asDataSource: Array<ASListProductModel> = [ ]
    //全部订单的售后列表的商品数组
    fileprivate lazy var allDataSource: Array<FKYAllAfterSaleProductModel> = [ ]
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI
    //(未使用了)
    func configCell(_ model: RCListModel?) {
        dataSource  = model!.rmaDetailList!
        collectionView.reloadData()
    }
    //单个订单的售后列表
    func configASCell(_ model: ASApplyListInfoModel?) {
        asDataSource  = model!.productList!
        collectionView.reloadData()
    }
    //全部订单的售后列表
    func configAllSaleCell(_ model:FKYAllAfterSaleModel)  {
        self.allDataSource = model.productList ?? []
        collectionView.reloadData()
    }
    func setupView() {
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
}

extension RCListProductListCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if asDataSource.isEmpty == false{
            return asDataSource.count > 4 ? 4 : asDataSource.count
        }else if dataSource.isEmpty == false{
            return dataSource.count
        }else if allDataSource.isEmpty == false {
            return allDataSource.count > 4 ? 4 : allDataSource.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RCListProductCCell", for: indexPath) as! RCListProductCCell
        if asDataSource.isEmpty == false{
             cell.configASCell(asDataSource[indexPath.row])
        }else if dataSource.isEmpty == false{
             cell.configCell(dataSource[indexPath.row])
        }else if allDataSource.isEmpty == false {
            cell.configAllSaleProductCell(allDataSource[indexPath.row])
        }
        return cell
    }
}

class RCListProductCCell: UICollectionViewCell {
    
    fileprivate var imageV: UIImageView = {
        let imgV = UIImageView()
        return imgV
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(imageV)
        imageV.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    func configCell(_ model: RCListProductModel?) {
        imageV.sd_setImage(with: URL(string: (model?.img)!), placeholderImage: UIImage(named: "image_default_img"))
    }
    func configASCell(_ model: ASListProductModel?) {
        imageV.sd_setImage(with: URL(string: (model?.mainImgPath)!), placeholderImage: UIImage(named: "image_default_img"))
    }
    //全部订单的售后列表中商品列表
    func configAllSaleProductCell(_ model :FKYAllAfterSaleProductModel) {
        let defalutImage = UIImage(named: "image_default_img")
        imageV.image = defalutImage
        if  let urlStr = model.mainImgPath , let strProductPicUrl = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            imageV.sd_setImage(with: urlProductPic , placeholderImage: defalutImage)
        }
    }
}
