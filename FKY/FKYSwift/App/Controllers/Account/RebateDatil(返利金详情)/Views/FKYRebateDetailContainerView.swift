//
//  FKYRebateDetailSellerView.swift
//  FKY
//
//  Created by 油菜花 on 2020/2/21.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

/// 展开折叠事件
let FKY_RebateFoldACtion = "RebateFoldACtion"
/// 跳转到店铺首页
let FKY_JumpTofStoreHomePage = "JumpTofStoreHomePage"
/// MP商家跳转到店铺首页
let FKY_MPJumpTofStoreHomePage = "MPJumpTofStoreHomePage"

class FKYRebateDetailContainerView: UIView {
    
    /// 数据对象
    var dataModel = FKYRebateSellerTypeModel()
    
    /// 头部视图
    lazy var headerView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFEF4F3)
        return view
    }()
    
    /// 中部视图
    lazy var middleView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        return view
    }()
    
    /// 头部视图点击按钮
    lazy var headerButton:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(FKYRebateDetailContainerView.headerButtonCicked), for: .touchUpInside)
        return bt
    }()
    
    ///商家列表view
    lazy var sellerListView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        return view
    }()
    
    /// 商家类型
    lazy var sellerTypeLB:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x3B3030)
        lb.text = "暂无商家"
        lb.font = UIFont.systemFont(ofSize: WH(16))
        return lb
    }()
    
    /// 金额
    lazy var moneyLB:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x363531)
        lb.text = "￥ 0.00"
        lb.font = UIFont.systemFont(ofSize: WH(18))
        lb.textAlignment = .right
        return lb
    }()
    
    /// 可用商家
    lazy var canBuySellerLB:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x3B3030)
        lb.text = "可用商家"
        lb.font = UIFont.boldSystemFont(ofSize: WH(12))
        return lb
    }()
    
    /// 展开按钮
    lazy var foldButton:UIButton = {
        let bt = UIButton()
        bt.setBackgroundImage(UIImage(named: "downIcon"), for: .normal)
        bt.setEnlargeEdgeWith(top: 20, right: 20, bottom: 20, left: 20)
        bt.addTarget(self, action: #selector(FKYRebateDetailContainerView.foldButtonClicked), for: .touchUpInside)
        return bt
    }()
    
    /// 商家列表
    var sellerViewArray = [FKYRebateDetailSellerCellView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.installProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - UI
extension FKYRebateDetailContainerView{
    
    func setupUI(){
        self.addSubview(self.headerView)
        self.addSubview(self.middleView)
        self.addSubview(self.sellerListView)
        
        self.headerView.addSubview(self.sellerTypeLB)
        self.headerView.addSubview(self.moneyLB)
        self.headerView.addSubview(self.headerButton)
        
        self.middleView.addSubview(self.canBuySellerLB)
        self.middleView.addSubview(self.foldButton)
        
        /// ------------
        self.headerView.snp_makeConstraints { (make) in
            make.left.top.right.equalTo(self)
            make.height.equalTo(WH(50))
        }
        self.middleView.snp_makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.headerView.snp_bottom)
            make.height.equalTo(WH(26))
        }
        self.sellerListView.snp_makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.top.equalTo(self.middleView.snp_bottom)
            make.height.equalTo(WH(0))
        }
        
        /// ------------
        self.headerButton.snp_makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(self.headerView)
        }
        self.sellerTypeLB.snp_makeConstraints { (make) in
            make.left.equalTo(self.headerView).offset(WH(13))
            make.centerY.equalTo(self.headerView)
            make.right.equalTo(self.moneyLB.snp_left)
        }
        self.moneyLB.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        self.moneyLB.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        self.moneyLB.snp_makeConstraints { (make) in
            make.right.equalTo(self.headerView).offset(WH(-23))
            make.centerY.equalTo(self.headerView)
        }
        
        /// ------------
        self.canBuySellerLB.snp_makeConstraints { (make) in
            make.left.equalTo(self.middleView).offset(WH(13))
            make.centerY.equalTo(self.middleView)
            make.right.equalTo(self.foldButton.snp_left)
        }
        self.foldButton.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.middleView)
            make.right.equalTo(self.middleView).offset(WH(-22))
            make.width.equalTo(WH(12))
            make.height.equalTo(WH(7))
        }
    }
    
    /// 初始化相关属性
    func installProperty(){
        self.layer.cornerRadius = WH(4)
        self.layer.masksToBounds = true
        self.layer.borderWidth = WH(1)
        self.layer.borderColor = RGBColor(0xFF2C5C).cgColor
        
    }
    
    /// 自营商家的布局方案
    func layoutType1(){
        self.sellerListView.isHidden = false
        self.middleView.isHidden = false
        self.headerButton.isUserInteractionEnabled = false
        self.foldButton.isHidden = false
        self.middleView.snp_updateConstraints { (make) in
            make.height.equalTo(WH(26))
        }
        if self.dataModel.isUnfold {// 展开
            self.unfoldSellerList()
            self.foldButton.setBackgroundImage(UIImage(named: "upIcon"), for: .normal)
        }else{// 关闭
            self.foldSellerList()
            self.foldButton.setBackgroundImage(UIImage(named: "downIcon"), for: .normal)
        }
    }
    
    /// 平台通用商家布局方案
    func layoutType2(){
        self.sellerListView.isHidden = true
        self.middleView.isHidden = false
        self.headerButton.isUserInteractionEnabled = false
        self.foldButton.isHidden = true
        self.middleView.snp_updateConstraints { (make) in
            make.height.equalTo(WH(26))
        }
    }
    
    ///单商家布局方案
    func layoutType3(){
        self.sellerListView.isHidden = true
        self.middleView.isHidden = true
        self.headerButton.isUserInteractionEnabled = true
        self.middleView.snp_updateConstraints { (make) in
            make.height.equalTo(WH(0))
        }
        
        self.sellerListView.snp_remakeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.top.equalTo(self.middleView.snp_bottom)
            make.height.equalTo(WH(0))
        }
    }
    
    /// 获取cell高度
    static func getCellHeight(_ data:FKYRebateSellerTypeModel) -> CGFloat{
        
        var cellHeight = WH(0)
        if data.cellType == "1"{// 自营商家通用
            cellHeight = WH(50)+WH(26)+WH(11)
            if data.isUnfold{// 展开
                cellHeight += ((CGFloat(data.sellerList.count + 1)*WH(13)) + CGFloat(data.sellerList.count)*WH(17))
            }
        }else if data.cellType == "2"{// 平台商家通用
            cellHeight = WH(50)+WH(26)+WH(11)
        }else if data.cellType == "3"{// 单商家
            cellHeight = WH(50)+WH(11)
        }
        return cellHeight
    }
}
//MARK: - 数据刷新
extension FKYRebateDetailContainerView{
    func showData(data:FKYRebateSellerTypeModel){
        self.dataModel = data
        self.sellerTypeLB.text = self.dataModel.sellerName
        self.moneyLB.text = String(format: "￥ %.2f", self.dataModel.rebateAmount)
        self.canBuySellerLB.text = self.dataModel.subTitleText
        
        if self.dataModel.cellType == "1"{// 自营商家通用
            self.layoutType1()
        }else if self.dataModel.cellType == "2"{// 平台商家通用
            self.layoutType2()
        }else if self.dataModel.cellType == "3"{// 单商家
            self.layoutType3()
        }
    }
}

//MARK: - 响应事件
extension FKYRebateDetailContainerView{
    
    /// 展开按钮点击
    @objc func foldButtonClicked(){
        self.dataModel.isUnfold = !self.dataModel.isUnfold
        self.routerEvent(withName: FKY_RebateFoldACtion, userInfo:[FKYUserParameterKey:""])
    }
    
    /// 头部按钮点击事件
    @objc func headerButtonCicked(){
        self.routerEvent(withName: FKY_MPJumpTofStoreHomePage, userInfo:[FKYUserParameterKey:self.dataModel])
    }
    
    /// 收起商家列表
    func foldSellerList(){
        for view in self.sellerViewArray {
            view.removeFromSuperview()
        }
        self.sellerListView.snp_remakeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.top.equalTo(self.middleView.snp_bottom)
            make.height.equalTo(WH(0))
        }
    }
    
    /// 展开商家列表
    func unfoldSellerList(){
        self.sellerListView.snp_remakeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.top.equalTo(self.middleView.snp_bottom)
        }
        for view in self.sellerViewArray {
            view.removeFromSuperview()
        }
        self.sellerViewArray.removeAll()
        var lastView = FKYRebateDetailSellerCellView()
        for (index,model) in self.dataModel.sellerList.enumerated() {
            let view = FKYRebateDetailSellerCellView()
            self.sellerListView.addSubview(view)
            if index == 0{// 第一个
                view.snp_makeConstraints { (make) in
                    make.left.equalTo(self.sellerListView)
                    make.right.equalTo(self.sellerListView)
                    make.top.equalTo(self.sellerListView).offset(WH(13))
                    make.height.equalTo(WH(17))
                }
            }
            
            if index != 0 && index != self.dataModel.sellerList.count-1{// 中间的
                view.snp_makeConstraints { (make) in
                    make.left.equalTo(self.sellerListView)
                    make.right.equalTo(self.sellerListView)
                    make.top.equalTo(lastView.snp_bottom).offset(WH(13))
                    make.height.equalTo(WH(17))
                }
            }
            
            if index == self.dataModel.sellerList.count-1 {/// 最后一个
                if index == 0{// 只有一个
                    view.snp_remakeConstraints{ (make) in
                        make.left.equalTo(self.sellerListView)
                        make.right.equalTo(self.sellerListView)
                        make.top.equalTo(self.sellerListView).offset(WH(13))
                        make.height.equalTo(WH(17))
                        make.bottom.equalTo(self.sellerListView).offset(WH(-13))
                    }
                }else{//一个以上
                    view.snp_makeConstraints { (make) in
                        make.left.equalTo(self.sellerListView)
                        make.right.equalTo(self.sellerListView)
                        make.top.equalTo(lastView.snp_bottom).offset(WH(13))
                        make.height.equalTo(WH(17))
                        make.bottom.equalTo(self.sellerListView).offset(WH(-13))
                    }
                }
                
            }
            self.sellerViewArray.append(view)
            lastView = view
            view.showSeller(model)
        }
    }
}


//MARK: - --------------------单条商家view----------------------
class FKYRebateDetailSellerCellView:UIView {
    
    /// 商家对象
    var sellerModel = FKYRebteSellerModel()
    
    ///商家名称
    lazy var sellerNameLB:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x666666)
        lb.numberOfLines = 0
        lb.font = UIFont.systemFont(ofSize: WH(12))
        return lb
    }()
    
    /// 右箭头icon
    lazy var rightImageIcon:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "rebate_right_Arrow_icon")
        return image
    }()
    
    /// 点击按钮
    lazy var actionButton:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(FKYRebateDetailSellerCellView.actionButtonClicked), for: .touchUpInside)
        return bt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UI
extension FKYRebateDetailSellerCellView {
    
    func setupUI(){
        self.addSubview(self.sellerNameLB)
        self.addSubview(self.rightImageIcon)
        self.addSubview(self.actionButton)
        
        self.sellerNameLB.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal);
        self.sellerNameLB.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(self).offset(WH(13))
            make.right.equalTo(self.rightImageIcon.snp_left).offset(WH(-10))
        }
        
        self.rightImageIcon.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.width.height.equalTo(WH(11))
            make.right.lessThanOrEqualTo(self).offset(WH(-22))
            make.left.equalTo(self.sellerNameLB.snp_right)
        }
        
        self.actionButton.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(self.sellerNameLB)
            make.right.equalTo(self.rightImageIcon)
        }
    }
}


//MARK: - 响应事件
extension FKYRebateDetailSellerCellView {
    
    /// 点击事件
    @objc func actionButtonClicked(){
        self.routerEvent(withName: FKY_JumpTofStoreHomePage, userInfo: [FKYUserParameterKey:self.sellerModel])
    }
}

//MARK: - 数据刷新
extension FKYRebateDetailSellerCellView {
    func showSeller(_ seller:FKYRebteSellerModel){
        self.sellerModel = seller
        self.sellerNameLB.text = seller.enterprise_name
    }
}
