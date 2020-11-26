//
//  HomeFucButtonCell.swift
//  FKY
//
//  Created by hui on 2018/6/28.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  功能按钮

import UIKit

let HOME_NAV_ITEM_H = WH(67)

enum HomeFucAlign {
    case Left
    case Right
    case Center
}

class HomeFuctionBtCollCell: UICollectionViewCell {
    
    fileprivate lazy var iconImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        //view.layer.masksToBounds = true
        //view.layer.cornerRadius = WH(22)
        view.image = UIImage.init(named:"")
        return view
    }()
    
    fileprivate lazy var titleLb: UILabel! = {
        let view = UILabel(frame: .zero)
        view.font = t31.font
        view.textAlignment = .center
        view.textColor = ColorConfig.color333333
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLb)
        iconImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(contentView.snp.top)
            make.width.height.equalTo(WH(44))
        }
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.bottom).offset(WH(6))
            make.height.equalTo(WH(17))
            make.centerX.equalTo(iconImageView.snp.centerX)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(model: HomeFucButtonItemModel? ,_ aligment:HomeFucAlign){
        if let tmodel = model {
            if aligment == HomeFucAlign.Left{
                iconImageView.snp.updateConstraints { (make) in
                    make.centerX.equalTo(contentView.snp.centerX).offset(WH(-17/2.0))
                }
            }else if aligment == HomeFucAlign.Center{
                iconImageView.snp.updateConstraints { (make) in
                    make.centerX.equalTo(contentView.snp.centerX)
                }
            }else if aligment == HomeFucAlign.Right{
                iconImageView.snp.updateConstraints { (make) in
                    make.centerX.equalTo(contentView.snp.centerX).offset(WH(17/2.0))
                }
            }
            iconImageView.sd_setImage(with: URL.init(string: tmodel.imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "), placeholderImage:iconImageView.imageWithColor(RGBColor(0xf4f4f4), "icon_home_placeholder_image_logo", CGSize(width: WH(40), height: WH(40))))
            titleLb.text = tmodel.title
        }
    }
}
//设置店铺馆中按钮
extension HomeFuctionBtCollCell {
    func resetShopAttentionFuntionView(_ shopModel : FKYUltimateShopModel) {
        //更新约束
        iconImageView.snp.updateConstraints { (make) in
            make.width.height.equalTo(WH(38))
        }
        titleLb.snp.remakeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.bottom).offset(WH(3))
            make.height.equalTo(WH(17))
            make.centerX.equalTo(iconImageView.snp.centerX)
            make.left.equalTo(contentView.snp.left).offset(WH(2))
            make.right.equalTo(contentView.snp.right).offset(-WH(2))
        }
        titleLb.text = shopModel.title
        titleLb.lineBreakMode = .byTruncatingMiddle
        let defalutImage = iconImageView.imageWithColor(RGBColor(0xf4f4f4), "icon_home_placeholder_image_logo", CGSize(width: WH(38), height: WH(38)))
        iconImageView.image = defalutImage
        if let strProductPicUrl = (shopModel.imgPath ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            iconImageView.sd_setImage(with: urlProductPic , placeholderImage: defalutImage)
        }
    }
}
//8个按钮功能栏
class HomeFucButtonView: UIView {
    
    // MARK: - Property
    // var isVisualAble = true  //是否可见 在首页曝光里使用
    fileprivate lazy var operation: HomePresenter = HomePresenter()
    // closure
    fileprivate var callback: HomeCellActionCallback?
    
    // 数据源
    fileprivate var fucBtModels: HomeFucButtonModel? {
        didSet {
            fucCollectionView.reloadData()
        }
    }
    // MARK: - UI属性
    fileprivate lazy var recommendLayout: FKYHorizontalPageFlowLayout = {
        let layout = FKYHorizontalPageFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.rowCount = self.rowNumber
        layout.itemCountPerRow = self.columnNumber
        layout.rowSpacing = WH(13)
        layout.columnSpacing = (SCREEN_WIDTH - WH(56)*5 - WH(17)*2.0)/4.0
        layout.edgeInsets = UIEdgeInsets.zero
        return layout
    }()
    fileprivate lazy var fucCollectionView: UICollectionView! = {
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.recommendLayout)
        
        view.register(HomeFuctionBtCollCell.self, forCellWithReuseIdentifier: "HomeFuctionBtCollCell")
        view.backgroundColor = UIColor.white
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        view.isPagingEnabled = true
        return view
    }()
    
    fileprivate lazy var pageControl: NewCirclePageControl = {
        let view = NewCirclePageControl.init(frame: CGRect.zero)
        view.pages = 2
        view.currentPageColor =  RGBColor(0xFF2D5C)
        view.normalPageColor =  RGBColor(0xECE6E7)
        view.dotNomalSize = CGSize(width:WH(6),height:WH(3))   // 正常点的size
        view.dotBigSize = CGSize(width:WH(14),height:WH(3))   // 正常点的size
        view.setPageDotsView()
        return view
    }()
    
    // 每页行数
    var rowNumber = 2
    // 每行单元格item个数（列数）
    var columnNumber = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = bg1
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    func setupView() {
        let bannerWidth = WH(14) + WH(6 + 5)*CGFloat(2 - 1)
        addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.centerX.equalTo(self).offset(-bannerWidth/2.0)
            make.height.equalTo(WH(3))
        }
        addSubview(fucCollectionView)
        fucCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(WH(15))
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(HOME_NAV_ITEM_H)
        }
    }
    // MARK: - Public
    
    // 配置cell
    func configCell(fucBtModel: HomeFucButtonModel?) {
        fucBtModels = fucBtModel
        if let model = self.fucBtModels ,let itemsCount = model.navigations {
            let bannerWidth = WH(14) + WH(6 + 5)*CGFloat(itemsCount.count/5 - 1)
            pageControl.snp.remakeConstraints { (make) in
                make.bottom.equalTo(self)
                make.centerX.equalTo(self).offset(-bannerWidth/2.0)
                make.height.equalTo(WH(3))
            }
            pageControl.isHidden = true
            var sectionNum = itemsCount.count/10
            if itemsCount.count%10 > 0 {
                sectionNum += 1
            }
            pageControl.pages = sectionNum
            if  itemsCount.count <= 5 {
                //一行
                fucCollectionView.snp.updateConstraints { (make) in
                    make.height.equalTo(HOME_NAV_ITEM_H)
                }
            }else if itemsCount.count <= 10 {
                //两行
                fucCollectionView.snp.updateConstraints { (make) in
                    make.height.equalTo(HOME_NAV_ITEM_H*2+WH(13))
                }
            }else {
                //两行有分页
                pageControl.isHidden = false
                //两行
                fucCollectionView.snp.updateConstraints { (make) in
                    make.height.equalTo(HOME_NAV_ITEM_H*2+WH(13))
                }
            }
        }
    }
}

extension HomeFucButtonView: HomeCellInterface {
    static func calculateHeight(withModel model: HomeModelInterface, tableView: UITableView, identifier: String, indexPath: IndexPath) -> CGFloat {
        return WH(102)
    }
    
    func bindOperation(_ callback: @escaping HomeCellActionCallback) {
        self.callback = callback
    }
    
    func bindModel(_ model: HomeModelInterface) {
        if let m = model as? HomeFucButtonModel {
            configCell(fucBtModel: m)
        }
        else {
            configCell(fucBtModel: nil)
        }
    }
}

extension HomeFucButtonView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let model = self.fucBtModels ,let itemsCount = model.navigations {
            var sectionNum = itemsCount.count/10
            if itemsCount.count%10 > 0 {
                sectionNum += 1
            }
            return sectionNum
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let model = self.fucBtModels ,let itemsCount = model.navigations {
            let endNum = itemsCount.count - section*10
            if endNum >= 10 {
                return 10
            }else {
                return endNum
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row % 5 == 0 || (indexPath.row + 1) % 5 == 0 {
            return CGSize(width: WH(56 + 17), height:WH(67))
        }else{
            return CGSize(width: WH(56), height:WH(67))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: WH(0), bottom: 0, right:WH(0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return WH(13)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return  (SCREEN_WIDTH - WH(56)*5 - WH(17)*2.0)/4.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeFuctionBtCollCell", for: indexPath) as! HomeFuctionBtCollCell
        if indexPath.item < (self.fucBtModels?.navigations!.count)! {
            if indexPath.row % 5 == 0   {
                cell.config(model: self.fucBtModels?.navigations![indexPath.item + indexPath.section*10],HomeFucAlign.Right)
            }else if  (indexPath.row + 1) % 5 == 0 {
                cell.config(model: self.fucBtModels?.navigations![indexPath.item + indexPath.section*10],HomeFucAlign.Left)
            }else{
                cell.config(model: self.fucBtModels?.navigations![indexPath.item + indexPath.section*10],HomeFucAlign.Center)
            }
        }
        
        return cell
    }
    
    //选中item会触发的方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let navigations = self.fucBtModels?.navigations {
            let action = HomeTemplateAction()
            action.actionType = .navigation014_clickItem
            let model = navigations[indexPath.item + indexPath.section*5]
            if model.name != nil{
                action.itemName = model.name!
            }
            action.actionParams = [HomeString.ACTION_KEY:model]
            
            action.itemCode = ITEMCODE.HOME_NAVIGATION_CLICK_CODE.rawValue
            action.itemPosition = String(indexPath.item + 1 + indexPath.section*5)
            action.floorPosition = "1"
            action.floorName = "运营首页"
            action.floorCode = FLOORID.HOME_RECOMMEND_PRODUCT_FLOOR.rawValue
            action.sectionName = "导航按钮"
            self.operation.onClickCellAction(action)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    // 已开始滑动
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        showPageIndex()
    //    }
    
    //    // 定时器方法滑动结束后调用此方法
    //    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    //        showPageIndex()
    //    }
    
    // 用户手动滑动结束后调用此方法
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // scrollKeyMethod()
        showPageIndex()
    }
    
    //    // 用户手动滑动开始
    //    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    //        if autoScroll == true, imgDataSource.count > 0 {
    //            stopAutoScroll()
    //        }
    //    }
    
    // 用户手动滑动结束
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //if autoScroll == true, imgDataSource.count > 0 {
        showPageIndex()
        //}
    }
    // 当前图片索引
    var currentPageIndex: Int {
        get {
            var index: Int = Int( (fucCollectionView.contentOffset.x + (SCREEN_WIDTH) * 0.5) / (SCREEN_WIDTH) )
            // if imgDataSource.count > 0  {
            index = index % 2
            //  }
            return max(0, index)
        }
    }
    func showPageIndex(){
        pageControl.setCurrectPage(currentPageIndex)
    }
}


