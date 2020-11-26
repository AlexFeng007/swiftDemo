//
//  HomeHotSellFloorCell.swift
//  FKY
//
//  Created by 寒山 on 2020/4/23.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class HomeHotSellFloorCell: UITableViewCell {
    var cellTypeInfo:HomeCellType = .HomeCellTypeThreeSystemRecomm
    var cellLsit : [HomeSecdKillProductModel] = [] //数据模型
    var checkRecommendBlock: ((HomeRecommendProductItemModel?,HomeSecdKillProductModel,Int)->())? //查看推荐的楼层
    //商品列表
    fileprivate lazy var contentCollectView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        //设置滚动的方向  horizontal水平混动
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(HomeNewArriveInfoCell.self, forCellWithReuseIdentifier: "HomeNewArriveInfoCell")
        view.backgroundColor = UIColor.white
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = false
        //        view.layer.masksToBounds = true
        //        view.layer.cornerRadius = WH(8)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI
    
    func setupView() {
        self.backgroundColor =  RGBColor(0xF4F4F4)
        contentView.addSubview(contentCollectView)
        contentCollectView.frame = CGRect.init(x: WH(10), y: 0, width: SCREEN_WIDTH - WH(20), height: WH(145))
        //        contentCollectView.snp.makeConstraints { (make) in
        //            make.top.equalTo(self)
        //            make.left.equalTo(self).offset(WH(10))
        //            make.right.equalTo(self).offset(WH(-10))
        //            make.height.equalTo(WH(145))
        //        }
    }
    func configHomePromotionCell(_ cellModel : HomeBaseCellProtocol) {
        if let floorInfo = cellModel as? HomeOneSystemRecommCellModel{
            if let modelList = floorInfo.modelList,modelList.isEmpty == false{
                self.cellLsit = modelList
                if floorInfo.hasTop == true{
                    self.setMutiBorderRoundingCorners(contentCollectView,WH(8),[UIRectCorner.bottomLeft, UIRectCorner.bottomRight])
                }else{
                    self.setMutiBorderRoundingCorners(contentCollectView,WH(8),[UIRectCorner.allCorners])
                }
            }
        }else if let floorInfo = cellModel as? HomeTwoSystemRecommCellModel{
            if let modelList = floorInfo.modelList,modelList.isEmpty == false{
                self.cellLsit = modelList
            }
            if floorInfo.hasTop == true{
                self.setMutiBorderRoundingCorners(contentCollectView,WH(8),[UIRectCorner.bottomLeft, UIRectCorner.bottomRight])
            }else{
                self.setMutiBorderRoundingCorners(contentCollectView,WH(8),[UIRectCorner.allCorners])
            }
        }else if let floorInfo = cellModel as? HomeThreeSystemRecommCellModel{
            if let modelList = floorInfo.modelList,modelList.isEmpty == false{
                self.cellLsit = modelList
            }
            if floorInfo.hasTop == true{
                self.setMutiBorderRoundingCorners(contentCollectView,WH(8),[UIRectCorner.bottomLeft, UIRectCorner.bottomRight])
            }else{
                self.setMutiBorderRoundingCorners(contentCollectView,WH(8),[UIRectCorner.allCorners])
            }
        }
        self.cellTypeInfo = cellModel.cellType ?? .HomeCellTypeThreeSystemRecomm
        self.contentCollectView.reloadData()
    }
}
extension  HomeHotSellFloorCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellLsit.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.cellTypeInfo == .HomeCellTypeThreeSystemRecomm{
            if indexPath.row == 0{
                //摆在第一个的最少展示两个商品
                return CGSize(width:(SCREEN_WIDTH - WH(20))/2.0, height:WH(145))
            }
            return CGSize(width:(SCREEN_WIDTH - WH(20))/4.0, height:WH(145))
        }else if self.cellTypeInfo == .HomeCellTypeTwoSystemRecomm{
            return CGSize(width:(SCREEN_WIDTH - WH(20))/2.0, height:WH(145))
        }else if self.cellTypeInfo == .HomeCellTypeOneSystemRecomm{
            return CGSize(width:SCREEN_WIDTH - WH(20) , height:WH(145))
        }
        return CGSize(width:(SCREEN_WIDTH - WH(20))/3.0, height:WH(145))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(0), left: WH(0), bottom: WH(0), right: WH(0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeNewArriveInfoCell", for: indexPath) as! HomeNewArriveInfoCell
        let productInfo = self.cellLsit[indexPath.row]
        cell.configCell(productInfo,self.cellTypeInfo,(self.cellLsit.count - 1) == indexPath.row,indexPath.row == 0)
        //点击
        cell.clicProductBlock = {[weak self] (productModel) in
            if let strongSelf = self{
                if let closure = strongSelf.checkRecommendBlock {
                    closure(productModel,productInfo,indexPath.row)
                }
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productInfo = self.cellLsit[indexPath.row]
        if let closure = self.checkRecommendBlock {
            closure(nil,productInfo,indexPath.row)
        }
    }
}
extension  HomeHotSellFloorCell{
    //设置圆角
    func setMutiBorderRoundingCorners(_ view:UIView,_ corner:CGFloat,_ corners: UIRectCorner){
        let maskPath = UIBezierPath.init(roundedRect: view.bounds,
                                         
                                         byRoundingCorners: corners,
                                         
                                         cornerRadii: CGSize(width: corner, height: corner))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.frame = view.bounds
        
        maskLayer.path = maskPath.cgPath
        
        view.layer.mask = maskLayer
        
    }
    
}
