//
//  HomeOftenBuyCell.swift
//  FKY
//
//  Created by hui on 2018/12/12.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class HomeOftenBuyCell: UITableViewCell {
    //头部栏
    fileprivate lazy var homeSegment: HMSegmentedControl = {
        let sv = HMSegmentedControl()
        sv.selectionIndicatorColor = RGBColor(0xFF2D5C)
        sv.titleTextAttributes = [NSAttributedString.Key.font : t12.font]
        sv.selectedTitleTextAttributes = [NSAttributedString.Key.font : t12.font ,NSAttributedString.Key.foregroundColor : RGBColor(0xFF2D5C)]
        sv.selectionIndicatorHeight = 1
        sv.selectionStyle = .textWidthStripe
        sv.selectionIndicatorLocation = .down
        sv.indexChangeBlock = { index in
            if let closure = self.getCurrentType {
                closure(self.getType(index))
            }
            UIView.animate(withDuration: 0.25, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.homeScrollView.contentOffset = CGPoint(x: SCREEN_WIDTH.multiple(index), y: 0)
            }) { (ret) in
                
            }
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I6205", itemPosition: self.getItemPosition(index), itemName: self.getItemName(index), itemContent: nil, itemTitle: nil, extendParams: nil, viewController:CurrentViewController.shared.item)
        }
        return sv
    }()
    //底层左右滑动cell
    fileprivate lazy var homeScrollView: UIScrollView = {
        let sv = UIScrollView(frame:CGRect.zero)
        sv.delegate = self
        sv.isPagingEnabled = true
        sv.bounces = false
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.backgroundColor = .white
        return sv
    }()
    
    fileprivate var oneView:HomeOftenBuyView?
    fileprivate var twoView:HomeOftenBuyView?
    fileprivate var threeView:HomeOftenBuyView?
    fileprivate var countViewNum:Int = 0 //当前显示多少个tab
    var getTypeMoreData : ((FKYOftenBuyType)->(Void))? //加载更多
    var getCurrentType : ((FKYOftenBuyType)->(Void))? //当前的type
    var goAllTableTop : (()->(Void))? //回到顶部
    var updateCarNumView :((OftenBuyProductItemModel?,Int)->(Void))? //更新商品数量
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView(reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setupView(_ reuseIdentifier: String?) {
        self.backgroundColor = bg7
        self.contentView.addSubview(homeSegment)
        homeSegment.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(contentView)
            make.height.equalTo(WH(44))
        }
        self.contentView.addSubview(homeScrollView)
        homeScrollView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(homeSegment.snp.bottom).offset(WH(1))
        }
        //初始化常购清单/
        for index in 0...2 {
            let oftenBuyView = HomeOftenBuyView()
            oftenBuyView.index = index
            //跳转到下一页
            oftenBuyView.goNextTab = { index in
                if index < self.countViewNum-1 {
                    if let closure = self.getCurrentType {
                        closure(self.getType(Int(index+1)))
                    }
                    self.homeSegment.setSelectedSegmentIndex(UInt(index+1), animated: true)
                    UIView.animate(withDuration: 0.25, animations: {[weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.homeScrollView.contentOffset = CGPoint(x: SCREEN_WIDTH.multiple(index+1), y: 0)
                    }) { (ret) in
                        
                    }
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I6205", itemPosition: self.getItemPosition(index), itemName: self.getItemName(index), itemContent: nil, itemTitle: nil, extendParams: nil, viewController:CurrentViewController.shared.item)
                }
            }
            //加载更多
            oftenBuyView.getMoreData = { type in
                if let closure = self.getTypeMoreData {
                    closure(type)
                }
            }
            //回到顶部
            oftenBuyView.goTableTop = {[weak self] in
                if let closure = self!.goAllTableTop {
                    //重置tableView的偏移量
                    self!.oneView?.resetTableViewOffsetY()
                    self!.twoView?.resetTableViewOffsetY()
                    self!.threeView?.resetTableViewOffsetY()
                    closure()
                }
            }
            //点击加入购物车按钮
            oftenBuyView.updateCarNum = { [weak self] (productModel,selectedNum) in
                if let block = self!.updateCarNumView {
                    block(productModel,selectedNum)
                }
            }
            
            var oftenBuyViewH = SCREEN_HEIGHT-naviBarHeight() - WH(44)
            if let str = reuseIdentifier ,str == "HomeOftenBuyCell" {
                //底部有导航栏的界面
                oftenBuyViewH  = oftenBuyViewH -  FKYTabBarController.shareInstance().tabbarHeight
            }
            oftenBuyView.frame = CGRect(x: SCREEN_WIDTH.multiple(index), y: 0, width:SCREEN_WIDTH, height: oftenBuyViewH)
            self.homeScrollView.addSubview(oftenBuyView)
            if index == 0 {
                oneView = oftenBuyView
            }else if  index == 1 {
                twoView = oftenBuyView
            }else {
                threeView = oftenBuyView
            }
        }
    }
}
//AMRK:处理数据
extension HomeOftenBuyCell {
    //初始化
    func configCellData(_ viewModel:FKYOftenBuyViewModel,_ isFirstFresh:Bool,_ viewTag:Int) {
        homeSegment.sectionTitles = viewModel.titleArr.map({$0.title!})
        homeScrollView.contentSize = CGSize(width: SCREEN_WIDTH.multiple(viewModel.titleArr.count), height:0)
        countViewNum = viewModel.titleArr.count
        if viewModel.titleArr.count > 0 {
            for i in 0...viewModel.titleArr.count-1 {
                let model = viewModel.titleArr[i]
                if i == 0 {
                    self.oneView?.type = model.type!
                }else if i == 1 {
                    self.twoView?.type = model.type!
                }else {
                    self.threeView?.type = model.type!
                }
            }
        }
        if viewModel.currentType == self.oneView?.type {
            self.oneView?.configData(viewModel,isFirstFresh)
        }else if viewModel.currentType == self.twoView?.type {
            self.twoView?.configData(viewModel,isFirstFresh)
        }else if viewModel.currentType == self.threeView?.type {
            self.threeView?.configData(viewModel,isFirstFresh)
        }
        //更新购物车数量
        self.oneView?.refreshArr()
        self.twoView?.refreshArr()
        self.threeView?.refreshArr()
        //首页的常购清单view的标识符(用于区分多个通知的问题)
        self.oneView?.tag = viewTag
        self.twoView?.tag = viewTag
        self.threeView?.tag = viewTag
        
        //第一次刷新，初始化到第一页
        if isFirstFresh == true {
            self.homeSegment.setSelectedSegmentIndex(0, animated: true)
            UIView.animate(withDuration: 0.05, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.homeScrollView.contentOffset = CGPoint(x: SCREEN_WIDTH.multiple(0), y: 0)
            }) { (ret) in
                
            }
        }
    }
    func getType(_ index:Int) -> FKYOftenBuyType {
        if index == 0 {
            return self.oneView?.type ?? .oftenLook
        }else if index == 1 {
            return self.twoView?.type ?? .oftenLook
        }else {
            return self.threeView?.type ?? .oftenLook
        }
    }
    //根据类型获取itemPosition(
    func getItemPosition(_ index:Int) -> String {
        let type = self.getType(index)
        if type == .oftenLook {
            return "2"
        }else if type == .hotSale {
            return "3"
        }else {
            return "1"
        }
    }
    //根据类型获取itemName
       func getItemName(_ index:Int) -> String {
           let type = self.getType(index)
           if type == .oftenLook {
               return "您常看的"
           }else if type == .hotSale {
               return "当地热销"
           }else {
               return "您常买的"
           }
       }
}
//AMRK:UIScrollViewDelegate代理
extension HomeOftenBuyCell :UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.homeScrollView {
            let index = scrollView.contentOffset.x / SCREEN_WIDTH
            self.homeSegment.setSelectedSegmentIndex(UInt(index), animated: true)
            if let closure = self.getCurrentType {
                closure(self.getType(Int(index)))
            }
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I6205", itemPosition: self.getItemPosition(Int(index)), itemName: self.getItemName(Int(index)), itemContent: nil, itemTitle: nil, extendParams: nil, viewController:CurrentViewController.shared.item)
        }
    }
}
