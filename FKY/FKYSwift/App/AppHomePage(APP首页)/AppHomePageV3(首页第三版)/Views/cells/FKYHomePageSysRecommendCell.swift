//
//  FKYHomePageSysRecommendCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/26.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  1个系统推荐  2个系统推荐  3个系统推荐

import UIKit

class FKYHomePageSysRecommendCell: UITableViewCell {
    
    /// 埋点事件
    static let ItemBIAction = "FKYHomePageSysRecommendCell-ItemBIAction"
    
    /// 两个商品的系统推荐item样式宽度
    let twoProductTypeWidth = (SCREEN_WIDTH-WH(10)-WH(10))/2.0
    /// 1个商品的系统推荐item样式宽度
    let singleProductTypeWidth = (SCREEN_WIDTH-WH(10)-WH(10))/2.0/2.0
    
    /// cell数据
    var cellModel:FKYHomePageV3CellModel = FKYHomePageV3CellModel()
    
    /// 距离底部的距离
    var bottomMargin:CGFloat = WH(0)
    
    /// 容器视图
    var containerView:UIView = UIView()
    
    /// 底部分割线
    var bottomMarginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        view.isHidden = true
        return view
    }()
    
    /// 集合list
    var twoProductList:[FKYHomePageItemType3] = [FKYHomePageItemType3]()
    var oneProductList:[FKYHomePageItemType2] = [FKYHomePageItemType2]()
    
    /// 组合所需组件
    var fourProductItem:FKYHomePageItemType5 = FKYHomePageItemType5()
    var twoProductItem1:FKYHomePageItemType3 = FKYHomePageItemType3()
    var twoProductItem2:FKYHomePageItemType3 = FKYHomePageItemType3()
    var oneProductItem1:FKYHomePageItemType2 = FKYHomePageItemType2()
    var oneProductItem2:FKYHomePageItemType2 = FKYHomePageItemType2()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        twoProductList = [twoProductItem1,twoProductItem2]
        oneProductList = [oneProductItem1,oneProductItem2]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 数据展示
extension FKYHomePageSysRecommendCell{
    /// 展示数据
    func configCell(cellModel:FKYHomePageV3CellModel){
        self.cellModel = cellModel
        if self.cellModel.cellType == .singleSysRecommend{// 1个系统推荐沾满一整行
            singleSysRecommendLayout()
            showSingleSysRecommendData()
        }else if self.cellModel.cellType == .doubleSysRecommend{// 2个系统推荐沾满一整行
            doubleSysRecommendLayout()
            showDoubleSysRecommendData()
        }else if self.cellModel.cellType == .threeSysRecommend{// 3个系统推荐占满一整行
            threeSysRecommendLayout()
            showThreeSysRecommendData()
        }
    }
    
    /// 1个系统推荐沾满一整行 数据
    func showSingleSysRecommendData(){
        guard cellModel.cellModel.contents.recommendList.count>0 else {
            return
        }
        fourProductItem.showItemData(itemModel: cellModel.cellModel.contents.recommendList[0])
    }
    
    /// 2个系统推荐沾满一整行 数据
    func showDoubleSysRecommendData(){
        guard cellModel.cellModel.contents.recommendList.count > 0 else {
            return
        }
        
        for (index,itemModel) in cellModel.cellModel.contents.recommendList.enumerated() {
            guard index < twoProductList.count else {
                break
            }
            let item = twoProductList[index]
            item.showData(itemModel: itemModel)
        }
        
        if cellModel.cellModel.contents.recommendList.count < 2 {
            twoProductItem2.isHidden = true
            twoProductItem1.rightMarginLine.isHidden = true
        }else{
            twoProductItem2.isHidden = false
            twoProductItem1.rightMarginLine.isHidden = false
        }
        
    }
    
    /// 3个系统推荐占满一整行 数据
    func showThreeSysRecommendData(){
        //FKYHomePageV3ItemModel
        guard cellModel.cellModel.contents.recommendList.count > 0 else {
            return
        }
        for (index,itemModel) in cellModel.cellModel.contents.recommendList.enumerated() {
            
            if index == 0 {
                twoProductItem1.showData(itemModel: itemModel)
            }else if index == 1{
                oneProductItem1.showData(itemModel: itemModel)
            }else if index == 2{
                oneProductItem2.showData(itemModel: itemModel)
            }
        }
        
        if cellModel.cellModel.contents.recommendList.count < 3 {
            oneProductItem2.isHidden = true
            oneProductItem1.rightMarginLine.isHidden = true
        }
        
        if cellModel.cellModel.contents.recommendList.count < 2 {
            oneProductItem1.isHidden = true
            twoProductItem1.rightMarginLine.isHidden = true
        }
        
        if cellModel.cellModel.contents.recommendList.count < 2 {
            oneProductItem1.isHidden = true
            twoProductItem1.rightMarginLine.isHidden = true
        }
    }
}

//MARK: - 事件响应
extension FKYHomePageSysRecommendCell{
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKYHomePageItemType5.ItemBIAction ||
            eventName == FKYHomePageItemType3.ItemBIAction ||
            eventName == FKYHomePageItemType2.ItemBIAction {// 拦截BI事件添加参数
            let itemData = userInfo[FKYUserParameterKey] as! FKYHomePageV3ItemModel
            var index_t = 0
            for (index,item) in cellModel.cellModel.contents.recommendList.enumerated() {
                if itemData == item {
                    index_t = index
                }
            }
            super.routerEvent(withName: FKYHomePageSysRecommendCell.ItemBIAction, userInfo: [FKYUserParameterKey:["index":index_t,"itemData":itemData]])
        }else if eventName == FKYHomePageItemType3.productClickedAction{
            //let dic = userInfo[FKYUserParameterKey] as! [String:Any]
            
            super.routerEvent(withName: eventName, userInfo: userInfo)
            
        }
        else{
            super.routerEvent(withName: eventName, userInfo: userInfo)
        }
    }
}

//MARK: - UI
extension FKYHomePageSysRecommendCell{
    override func configCellDisplayInfo() {
        super.configCellDisplayInfo()
        setCorners()
    }
    
    func setCorners(){
        var flag = 0
        if self.cellModel.isNeedTopCorner {
            flag += 1
        }
        
        if self.cellModel.isNeedBottomCorner{
            flag += 2
            bottomMarginLine.isHidden = true
            self.bottomMargin = WH(8)
        }else{
            bottomMarginLine.isHidden = false
            self.bottomMargin = WH(0)
        }
        configBottomMargin()
        configCorners(type: flag)
        
    }
    
    /// 设置圆角
    /// - Parameter type: 1 只设置上左上右  2 只设置下左 下右  3上下左右全设置 0啥也不设置
    func configCorners(type:Int){
        containerView.layoutIfNeeded()
        containerView.layer.mask = nil
        if type == 1{
            containerView.setRoundedCorners([UIRectCorner.topLeft, UIRectCorner.topRight], radius: WH(8))
        }else if type == 2{
            containerView.setRoundedCorners([UIRectCorner.bottomLeft, UIRectCorner.bottomRight], radius: WH(8))
        }else if type == 3{
            containerView.setRoundedCorners([UIRectCorner.bottomLeft, UIRectCorner.bottomRight,UIRectCorner.topLeft, UIRectCorner.topRight], radius: WH(8))
        }
    }
    
    /// 移除所有组件,初始化属性
    func installItems(){
        
        fourProductItem.removeFromSuperview()
        twoProductItem1.removeFromSuperview()
        twoProductItem2.removeFromSuperview()
        oneProductItem1.removeFromSuperview()
        oneProductItem2.removeFromSuperview()
        
        twoProductItem1.rightMarginLine.isHidden = true
        twoProductItem2.rightMarginLine.isHidden = true
        oneProductItem1.rightMarginLine.isHidden = true
        oneProductItem2.rightMarginLine.isHidden = true
        
        fourProductItem.isHidden = true
        twoProductItem1.isHidden = true
        twoProductItem2.isHidden = true
        oneProductItem1.isHidden = true
        oneProductItem2.isHidden = true
        
    }
    
    /// 一个系统推荐占满一整行
    func singleSysRecommendLayout(){
        installItems()
        containerView.addSubview(fourProductItem)
        fourProductItem.isHidden = false
        fourProductItem.snp_remakeConstraints{ (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(WH(0))
            make.right.equalToSuperview().offset(WH(0))
        }
    }
    
    /// 两个系统推荐占满一整行
    func doubleSysRecommendLayout(){
        installItems()
        twoProductItem1.rightMarginLine.isHidden = false
        twoProductItem1.isHidden = false
        twoProductItem2.isHidden = false
        containerView.addSubview(twoProductItem1)
        containerView.addSubview(twoProductItem2)
        twoProductItem1.snp_remakeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.right.equalTo(containerView.snp_centerX)
        }
        
        twoProductItem2.snp_remakeConstraints { (make) in
            make.left.equalTo(containerView.snp_centerX)
            make.top.right.bottom.equalToSuperview()
        }
    }
    
    /// 三个系统推荐占满一整行
    func threeSysRecommendLayout(){
        installItems()
        twoProductItem1.rightMarginLine.isHidden = false
        oneProductItem1.rightMarginLine.isHidden = false
        twoProductItem1.isHidden = false
        oneProductItem1.isHidden = false
        oneProductItem2.isHidden = false
        containerView.addSubview(twoProductItem1)
        containerView.addSubview(oneProductItem1)
        containerView.addSubview(oneProductItem2)
        twoProductItem1.snp_remakeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.right.equalTo(containerView.snp_centerX)
        }
        
        oneProductItem1.snp_remakeConstraints { (make) in
            make.left.equalTo(containerView.snp_centerX)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(oneProductItem2.snp_left)
            make.width.equalTo(oneProductItem2)
        }
        
        oneProductItem2.snp_remakeConstraints { (make) in
            make.left.equalTo(oneProductItem1.snp_right)
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(oneProductItem1)
        }
    }
    
    /// 配置底部的空白距离
    func configBottomMargin(){
        containerView.snp_updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(-bottomMargin)
        }
    }
    
    func setupUI(){
        selectionStyle = .none
        backgroundColor = .clear
        containerView.backgroundColor = RGBColor(0xFFFFFF)
        
        contentView.addSubview(containerView)
        containerView.addSubview(bottomMarginLine)
        containerView.snp_makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-bottomMargin)
            make.left.equalToSuperview().offset(WH(10))
            make.right.equalToSuperview().offset(WH(-10))
        }
        
        bottomMarginLine.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

extension  FKYHomePageSysRecommendCell{
    //设置圆角
    /*
    func setMutiBorderRoundingCorners(_ view:UIView,_ corner:CGFloat,_ corners: UIRectCorner){
        let maskPath = UIBezierPath.init(roundedRect: view.bounds,
                                         
                                         byRoundingCorners: corners,
                                         
                                         cornerRadii: CGSize(width: corner, height: corner))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.frame = view.bounds
        
        maskLayer.path = maskPath.cgPath
        
        view.layer.mask = maskLayer
        
    }
    */
}
