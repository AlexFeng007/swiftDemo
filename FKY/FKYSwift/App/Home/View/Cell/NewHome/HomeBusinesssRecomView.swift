//
//  HomeBusinesssRecomView.swift
//  FKY
//
//  Created by 寒山 on 2020/4/23.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class HomeBusinesssRecomView: UIView {
    // var checkRecommendBlock: ((HomeSecdKillProductModel)->())? //查看推荐的楼层
    var clickProductBlock: ((HomeRecommendProductItemModel?,HomeSecdKillProductModel)->())? //点击商品进楼层
    var cellType:HomeCellType? //更具celltye 判断商品展示数量
    var cellModel : HomeSecdKillProductModel? //数据模型
    /// 当前页面的布局类型 1 代表1个商家推荐占一整个楼层 2代表2个商家推荐占一整个楼层
    var layoutType:Int = 0
    //顶部视图
    fileprivate lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    //一级标题
    fileprivate lazy var proTypeNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(15))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.textColor = RGBColor(0x333333)
        label.backgroundColor = .clear
        
        return label
    }()
    //    //倒计时视图背景
    fileprivate lazy var descBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.masksToBounds = true
        view.layer.borderWidth = WH(1)
        view.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        view.layer.cornerRadius =  WH(8)
        view.isUserInteractionEnabled = false
        return view
    }()
    //倒计时title
    fileprivate lazy var descTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(10))
        label.textColor = RGBColor(0xFF2D5C)
        label.backgroundColor = UIColor.clear
        label.textAlignment  = .center
        
        return label
    }()
    //描述箭头
    fileprivate var dirImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "home_shop_dir")
        img.contentMode = .center
        return img
    }()
    //商品列表
    fileprivate lazy var bottomView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        //设置滚动的方向  horizontal水平混动
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(HomeSecKillProductCell.self, forCellWithReuseIdentifier: "HomeSecKillProductCell")
        view.backgroundColor = UIColor.white
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = false
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func setupView() {
        backgroundColor = UIColor.white
        self.addSubview(topView)
        self.addSubview(proTypeNameLabel)
        self.addSubview(descTitleLabel)
        self.addSubview(descBgView)
        self.addSubview(bottomView)
        self.addSubview(dirImageView)
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.right.equalTo(self)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        proTypeNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(WH(13))
            make.left.equalTo(self).offset(WH(14))
            make.width.lessThanOrEqualTo(WH(72))
        }
        
        descTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(proTypeNameLabel.snp.centerY)
            make.left.equalTo(proTypeNameLabel.snp.right).offset(WH(13))
            make.height.equalTo(WH(16))
            make.width.lessThanOrEqualTo(WH(72))
        }
        dirImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(descTitleLabel.snp.centerY)
            make.left.equalTo(descTitleLabel.snp.right).offset(WH(3))
            make.height.equalTo(WH(6))
            make.width.equalTo(WH(4))
        }
        descBgView.snp.makeConstraints { (make) in
            make.top.equalTo(descTitleLabel.snp.top)
            make.bottom.equalTo(descTitleLabel.snp.bottom)
            make.left.equalTo(descTitleLabel.snp.left).offset(WH(-4))
            make.right.equalTo(dirImageView.snp.right).offset(WH(4))
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(WH(39))
            make.left.right.bottom.equalTo(self)
        }
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.clickProductBlock,strongSelf.cellModel != nil {
                closure(nil,strongSelf.cellModel!)
            }
        }).disposed(by: disposeBag)
        topView.addGestureRecognizer(tapGesture)
    }
    
}

//MAKR: 数据展示
extension HomeBusinesssRecomView{
    
    func configCell(_ cellModel : HomeSecdKillProductModel,_ layoutType:Int) {
        self.layoutType = layoutType
        self.cellModel = cellModel
        self.configData(cellModel)
        self.bottomView.reloadData()
    }
    
    func configViewData(_ cellModel : HomeSecdKillProductModel){
        self.proTypeNameLabel.text = cellModel.name
        self.descTitleLabel.text = cellModel.title
        let contentSize = (cellModel.title ?? "").boundingRect(with: CGSize(width:SCREEN_WIDTH, height: WH(14)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(10))], context: nil).size
        // return ((contentSize.width + 1) > WH(14) ? (contentSize.width + 1 - WH(14)):0) + WH(58)
        if self.layoutType == 2{
            let lessWidth = ((SCREEN_WIDTH - WH(20))/2.0 - (contentSize.width + 1) - WH(14) - WH(8) - WH(7) - WH(13) ) > 0 ? (SCREEN_WIDTH - WH(20))/2.0 - (contentSize.width + 1) - WH(14) - WH(8) - WH(7) - WH(13) :0
            descTitleLabel.snp.updateConstraints { (make) in
                make.width.lessThanOrEqualTo((SCREEN_WIDTH - WH(20))/2.0 - WH(14) - WH(8) - WH(7) - WH(13))
            }
            proTypeNameLabel.snp.updateConstraints { (make) in
                make.width.lessThanOrEqualTo(lessWidth)
            }
        }else if self.layoutType == 1{
            let lessWidth = (SCREEN_WIDTH - WH(20) - (contentSize.width + 1) - WH(14) - WH(7) - WH(8) - WH(13) ) > 0 ? SCREEN_WIDTH - WH(20) - (contentSize.width + 1) - WH(14) - WH(8) - WH(7) - WH(13) :0
            descTitleLabel.snp.updateConstraints { (make) in
                make.width.lessThanOrEqualTo(SCREEN_WIDTH - WH(20) - WH(14) - WH(7) - WH(8) - WH(13))
            }
            proTypeNameLabel.snp.updateConstraints { (make) in
                make.width.lessThanOrEqualTo(lessWidth)
            }
        }
    }

}

extension HomeBusinesssRecomView{
    func configHomePromotionCell(_ cellModel : HomeSecdKillProductModel,_ cellType:HomeCellType?) {
        self.cellType = cellType
        self.cellModel = cellModel
        self.configData(cellModel)
        self.bottomView.reloadData()
    }
    func configData(_ cellModel : HomeSecdKillProductModel){
        //隐藏动态ui视图
        self.proTypeNameLabel.text = cellModel.name
        self.descTitleLabel.text = cellModel.title
        let contentSize = (cellModel.title ?? "").boundingRect(with: CGSize(width:SCREEN_WIDTH, height: WH(14)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(10))], context: nil).size
        // return ((contentSize.width + 1) > WH(14) ? (contentSize.width + 1 - WH(14)):0) + WH(58)
//        if self.cellType == .HomeCellTypeSecKillAndShopRecomm{
//            let lessWidth = ((SCREEN_WIDTH - WH(20))/2.0 - (contentSize.width + 1) - WH(14) - WH(8) - WH(7) - WH(13) ) > 0 ? (SCREEN_WIDTH - WH(20))/2.0 - (contentSize.width + 1) - WH(14) - WH(8) - WH(7) - WH(13) :0
//            descTitleLabel.snp.updateConstraints { (make) in
//                make.width.lessThanOrEqualTo((SCREEN_WIDTH - WH(20))/2.0 - WH(14) - WH(8) - WH(7) - WH(13))
//            }
//            proTypeNameLabel.snp.updateConstraints { (make) in
//                make.width.lessThanOrEqualTo(lessWidth)
//            }
//        }else if self.cellType == .HomeCellTypeOnlyShopRecomm{
//            let lessWidth = (SCREEN_WIDTH - WH(20) - (contentSize.width + 1) - WH(14) - WH(7) - WH(8) - WH(13) ) > 0 ? SCREEN_WIDTH - WH(20) - (contentSize.width + 1) - WH(14) - WH(8) - WH(7) - WH(13) :0
//            descTitleLabel.snp.updateConstraints { (make) in
//                make.width.lessThanOrEqualTo(SCREEN_WIDTH - WH(20) - WH(14) - WH(7) - WH(8) - WH(13))
//            }
//            proTypeNameLabel.snp.updateConstraints { (make) in
//                make.width.lessThanOrEqualTo(lessWidth)
//            }
//        }
    }
}
extension  HomeBusinesssRecomView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let model = self.cellModel ,let arr = model.floorProductDtos {
            //商家推荐 layoutType
            if self.layoutType == 2{
                return (arr.count > 2) ? 2 : arr.count
            }else if self.layoutType == 1{
                return (arr.count > 4) ? 4 : arr.count
            }
            /*
            if self.cellType == .HomeCellTypeSecKillAndShopRecomm{
                return (arr.count > 2) ? 2 : arr.count
            }else if self.cellType == .HomeCellTypeOnlyShopRecomm{
                return (arr.count > 4) ? 4 : arr.count
            }
            */
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if self.layoutType == 2{
            return CGSize(width:(SCREEN_WIDTH/2.0 - WH(10) - WH(16))/2.0, height:WH(106))
        }else if self.layoutType == 1{
            return CGSize(width:(SCREEN_WIDTH - WH(20) - WH(16))/4.0, height:WH(106))
        }
        /*
        if self.cellType == .HomeCellTypeSecKillAndShopRecomm{
            return CGSize(width:(SCREEN_WIDTH/2.0 - WH(10) - WH(16))/2.0, height:WH(106))
        }else if self.cellType == .HomeCellTypeOnlyShopRecomm{
            return CGSize(width:(SCREEN_WIDTH - WH(20) - WH(16))/4.0, height:WH(106))
        }
        */
        return CGSize(width:WH(68), height:WH(106))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(0), left: WH(8), bottom: WH(0), right: WH(8))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let model = self.cellModel ,let arr = model.floorProductDtos {
            //秒杀
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeSecKillProductCell", for: indexPath) as! HomeSecKillProductCell
            cell.configCell(arr[indexPath.item],model)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeSecKillProductCell", for: indexPath) as! HomeSecKillProductCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = self.cellModel ,let arr = model.floorProductDtos{
            if let bolck = self.clickProductBlock,self.cellModel != nil{
                bolck(arr[indexPath.item],self.cellModel!)
            }
        }
    }
}
