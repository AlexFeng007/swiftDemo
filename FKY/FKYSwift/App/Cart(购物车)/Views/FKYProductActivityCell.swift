//
//  FKYProductActivityCell.swift
//  FKY
//
//  Created by 曾维灿 on 2019/12/9.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYProductActivityCell: UITableViewCell {
    var selectItemBlock: emptyClosure?//商品勾选
    var updateAddProductNum: addCarClosure? //加车更新
    var toastAddProductNum : SingleStringClosure? //加车提示
    
    //MARK: -属性
    
    ///cell数据
    var cellModel:BaseCartCellProtocol = BaseCartCellProtocol()
    
    ///边框
    let borderLayer = CAShapeLayer()
    
    ///分割线
    lazy var marginView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    ///容器视图
    lazy var containerView:UIView = {
        let view = UIView()
        view.frame = CGRect(x:WH(5.0),y:0,width: SCREEN_WIDTH - WH(10) ,height:WH(45.0))
        return view
    }()
    
    ///选中按钮
    lazy var selectedBTN:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "img_pd_select_normal")
        img.isUserInteractionEnabled = true
        let tapGestureMsg = UITapGestureRecognizer()
        tapGestureMsg.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.selectItemBlock {
                closure()
            }
        }).disposed(by: disposeBag)
        img.addGestureRecognizer(tapGestureMsg)
        return img
    }()
    //    lazy var selectedBTN:UIButton = {
    //        let bt = UIButton()
    //        bt.setBackgroundImage(UIImage(named: "img_pd_select_normal"), for: UIControl.State.normal)
    //        _ = bt.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
    //            guard let strongSelf = self else {
    //                return
    //            }
    //            if let closure = strongSelf.selectItemBlock {
    //                closure()
    //            }
    //
    //            }, onError: nil, onCompleted: nil, onDisposed: nil)
    //        return bt
    //    }()
    
    ///活动标签
    lazy var tagLB:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(10.0))
        label.textColor = UIColor.white
        label.backgroundColor = RGBColor(0xFF2D5C)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        return label
    }()
    
    ///活动名称
    lazy var activityName:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(12.0))
        label.textColor = RGBColor(0x333333)
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        return label
    }()
    
    ///固定套餐限购信息
    lazy var fixComboLimitInfoLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(12.0))
        label.textColor = RGBColor(0xFF2D5C)
        label.textAlignment = .right
        return label
    }()
    
    ///右箭头
    lazy var rightArrowIcon:UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage(named: "icon_account_black_arrow")
        return imageV
    }()
    
    /// 加车器
    lazy var stepper: CartStepper = {
        let stepper = CartStepper()
        stepper.cartUiUpdatePattern()
        //        stepper.cartUiUpdateFixComboPattern()
        //        stepper.isFixedCombo = true
        stepper.bgView.backgroundColor =  UIColor.clear
        stepper.toastBlock = { [weak self] (str) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.toastAddProductNum {
                closure(str!)
            }
        }
        //修改数量时候
        stepper.updateProductBlock = { [weak self] (count : Int,typeIndex : Int) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.updateAddProductNum {
                closure(count,typeIndex)
            }
        }
        return stepper
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override  init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style,reuseIdentifier:reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: -事件响应
extension FKYProductActivityCell {
    @objc func selectedBTNClicked(){
        print("用户点击选择按钮")
        print(self.containerView.frame)
    }
}


//MARK: -私有方法
extension FKYProductActivityCell {
    
    func configRectCornerAndBorder(view: UIView, corner: UIRectCorner, roundCorner: (leftTop:CGFloat,rightTop:CGFloat,rightBottom:CGFloat,leftBottom:CGFloat)=(0,0,0,0),border:(top:Bool,right:Bool,bottom:Bool,left:Bool)=(false,false,false,false),borderWidth:CGFloat = 2,borderColor:UIColor=UIColor.red)  {
        self.borderLayer.removeFromSuperlayer()
        //切圆角
        var radii:CGFloat = 0;
        if roundCorner.leftTop != 0{
            radii = roundCorner.leftTop
        }
        if roundCorner.leftBottom != 0{
            radii = roundCorner.leftBottom
        }
        if roundCorner.rightTop != 0 {
            radii = roundCorner.rightTop
        }
        if roundCorner.rightBottom != 0{
            radii = roundCorner.rightBottom
        }
        
        let maskPath = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radii ,height: radii ))
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
        
        
        //画边框 从左上角开始
        let pathCenter = borderWidth/2.0
        let path = UIBezierPath()
        path.move(to:CGPoint(x:0,y:0+pathCenter))
        //左上圆角
        if roundCorner.leftTop != 0 {
            path.move(to:CGPoint(x: 0+pathCenter, y: roundCorner.leftTop))
            path.addArc(withCenter: CGPoint(x:roundCorner.leftTop+pathCenter,y:roundCorner.leftTop+pathCenter), radius: roundCorner.leftTop, startAngle:.pi, endAngle: .pi*1.5, clockwise: true)
        }
        
        
        //右上圆角+上方边框
        if roundCorner.rightTop != 0 {
            if border.top{
                if roundCorner.leftTop != 0{
                    path.move(to: CGPoint(x:roundCorner.leftTop+pathCenter, y:0+pathCenter))
                }else{
                    path.move(to:CGPoint(x:0 ,y:0))
                }
                path.addLine(to: CGPoint(x: view.hd_width-roundCorner.rightTop, y: 0+pathCenter))
            }
            
            path.move(to:CGPoint(x: view.hd_width-roundCorner.rightTop, y: 0+pathCenter))
            path.addArc(withCenter: CGPoint(x:(view.hd_width-roundCorner.rightTop)-pathCenter,y:roundCorner.rightTop+pathCenter), radius: roundCorner.rightTop, startAngle: .pi*1.5, endAngle:0, clockwise: true)
        }else{
            if border.top{
                if roundCorner.leftTop != 0{
                    path.move(to: CGPoint(x:roundCorner.leftTop+pathCenter, y:0+pathCenter))
                }else{
                    path.move(to:CGPoint(x:0 ,y:0))
                }
                path.addLine(to: CGPoint(x:view.hd_width,y:0+pathCenter))
            }
        }
        
        //右下圆角+右边边框
        if roundCorner.rightBottom != 0{
            if border.right{
                if roundCorner.rightTop != 0{
                    path.move(to: CGPoint(x:view.hd_width-pathCenter, y:roundCorner.rightTop+pathCenter))
                }else{
                    path.move(to:CGPoint(x:view.hd_width-pathCenter ,y:0))
                }
                path.addLine(to:CGPoint(x: view.hd_width-pathCenter, y: view.hd_height-roundCorner.rightBottom))
            }
            path.move(to:CGPoint(x: view.hd_width-pathCenter, y: view.hd_height-roundCorner.rightBottom))
            path.addArc(withCenter: CGPoint(x:(view.hd_width-roundCorner.rightBottom)-pathCenter,y:(view.hd_height-roundCorner.rightBottom)-pathCenter), radius: roundCorner.rightBottom, startAngle: 0, endAngle:.pi/2.0, clockwise: true)
        }else{
            
            if border.right {
                if roundCorner.rightTop != 0{
                    path.move(to: CGPoint(x:view.hd_width-pathCenter, y:roundCorner.rightTop+pathCenter))
                }else{
                    path.move(to:CGPoint(x:view.hd_width-pathCenter ,y:0))
                }
                path.addLine(to: CGPoint(x:view.hd_width-pathCenter,y:view.hd_height))
            }
        }
        
        //左下圆角+下方边框
        if roundCorner.leftBottom != 0{
            if border.bottom {
                if roundCorner.rightBottom != 0{
                    path.move(to: CGPoint(x:view.hd_width-pathCenter-roundCorner.rightBottom, y:view.hd_height - pathCenter))
                }else{
                    path.move(to:CGPoint(x:view.hd_width ,y:view.hd_height))
                }
                path.addLine(to:CGPoint(x: roundCorner.leftBottom+pathCenter, y: view.hd_height-pathCenter))
            }
            path.move(to:CGPoint(x: roundCorner.leftBottom+pathCenter, y: view.hd_height-pathCenter))
            path.addArc(withCenter: CGPoint(x:roundCorner.leftBottom+pathCenter,y:(view.hd_height-roundCorner.leftBottom)-pathCenter), radius: roundCorner.leftBottom, startAngle: .pi/2.0, endAngle:.pi, clockwise: true)
        }else{
            if border.bottom {
                if roundCorner.rightBottom != 0{
                    path.move(to: CGPoint(x:view.hd_width-pathCenter-roundCorner.rightBottom, y:view.hd_height - pathCenter))
                }else{
                    path.move(to:CGPoint(x:view.hd_width ,y:view.hd_height))
                }
                path.addLine(to: CGPoint(x:0,y:view.hd_height-pathCenter))
            }
        }
        
        //最后一条封闭直线 左边边框
        if roundCorner.leftTop != 0{
            if border.left {
                if roundCorner.leftBottom != 0{
                    path.move(to: CGPoint(x:0+pathCenter, y:view.hd_height - pathCenter-roundCorner.leftBottom))
                }else{
                    path.move(to:CGPoint(x:0+pathCenter ,y:view.hd_height))
                }
                path.addLine(to: CGPoint(x:0+pathCenter,y:roundCorner.leftTop + pathCenter))
            }
        }else{
            if border.left {
                if roundCorner.leftBottom != 0{
                    path.move(to: CGPoint(x:0+pathCenter, y:view.hd_height - pathCenter-roundCorner.leftBottom))
                }else{
                    path.move(to:CGPoint(x:0+pathCenter ,y:view.hd_height))
                }
                path.addLine(to: CGPoint(x:0+pathCenter,y:0))
            }
        }
        
        path.stroke()
        borderLayer.frame = view.bounds
        borderLayer.path = path.cgPath
        borderLayer.lineWidth = borderWidth
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(borderLayer)
    }
}

//MARK: -UI
extension FKYProductActivityCell {
    
    func  setupView(){
        
        self.contentView.addSubview(containerView)
        
        self.containerView.addSubview(selectedBTN)
        self.containerView.addSubview(tagLB)
        self.containerView.addSubview(activityName)
        self.containerView.addSubview(rightArrowIcon)
        self.containerView.addSubview(stepper)
        self.containerView.addSubview(marginView)
        self.containerView.addSubview(fixComboLimitInfoLabel)
        configLayout()
    }
    
    func configLayout (){
        
        //容器视图
        //        containerView.snp_makeConstraints { (make) in
        //            make.edges.equalTo(UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5))
        //        }
        
        //选择按钮
        selectedBTN.snp_makeConstraints { (make) in
            make.left.equalTo(self.containerView).offset(WH(8.0))
            make.top.equalTo(self.containerView).offset(WH(9.5))
            make.width.height.equalTo(26.0)
        }
        
        //活动类型标签
        tagLB.snp_makeConstraints { (make) in
            make.left.equalTo(self.selectedBTN.snp_right).offset(WH(4.0))
            make.centerY.equalTo(self.selectedBTN.snp.centerY)
            make.width.equalTo(WH(30.0))
            make.height.equalTo(WH(15))
        }
        
        //活动名称
        activityName.snp_makeConstraints { (make) in
            make.left.equalTo(self.tagLB.snp_right).offset(WH(7.0))
            make.centerY.equalTo(self.selectedBTN.snp.centerY)
        }
        
        //右箭头
        rightArrowIcon.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.selectedBTN.snp.centerY)
            make.right.equalTo(self.containerView).offset(WH(-9))
            make.width.equalTo(WH(7))
            make.height.equalTo(WH(14.0))
        }
        
        //加车器
        stepper.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.selectedBTN.snp.centerY)
            make.right.equalTo(self.containerView).offset(WH(-8))
            make.width.equalTo(WH(0))
            make.height.equalTo(WH(0))
        }
        
        fixComboLimitInfoLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.stepper.snp.bottom).offset(WH(10))
            make.right.equalTo(self.containerView).offset(WH(-11))
            make.height.equalTo(WH(12))
        }
        
        //分割线
        marginView.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.containerView).offset(WH(-0.5))
            make.left.equalTo(self.containerView).offset(0.5)
            make.right.equalTo(self.containerView).offset(-0.5)
            make.height.equalTo(WH(0.5))
        }
    }
}

//MARK: -刷新数据
extension FKYProductActivityCell {
    func showData(cellModel:BaseCartCellProtocol) {
        self.cellModel = cellModel
        containerView.frame = CGRect(x:WH(5.0),y:0,width: SCREEN_WIDTH - WH(10) ,height:FKYProductActivityCell.getCellHeight(cellModel))
        configData()
        drawBorderAndCorner()
    }
    
    func configData(){
        switch self.cellModel.cellType {
        case .CartCellTypeFixTaoCanName://固定套餐名
            GDTaoCanLayoutType(cellData: self.cellModel as! CartCellFixTaoCanProtocol)
            
        case .CartCellTypeTaoCanName:// 搭配套餐名
            DPTaoCanLayoutType(cellData: self.cellModel as! CartCellTaoCanProtocol)
            
        case .CartCellTypePromotion://促销信息
            let cellData = self.cellModel as! CartCellPromotionInfoProtocol
            if cellData.promotionType == .CartPromotionTypeMJ {//满减
                promotionMJLayoutType(cellData: cellData)
            }else if cellData.promotionType == .CartPromotionTypeMZ {//满折
                promotionMZLayoutType(cellData:cellData)
            }
            
        default:
            
            break
        }
    }
    
    //固定套餐布局方案
    func GDTaoCanLayoutType(cellData:CartCellFixTaoCanProtocol){
        
        //选中按钮
        selectedBTN.snp_remakeConstraints { (make) in
            make.top.equalTo(self.containerView).offset(WH(9.5))
            make.left.equalTo(self.containerView).offset(WH(8.0))
            make.width.height.equalTo(26.0)
        }
        
        //活动类型标签
        tagLB.text = "套餐  "
        //tagLB.sizeToFit()
        tagLB.layer.cornerRadius = WH(7.5)
        tagLB.layer.masksToBounds = true
        tagLB.snp_updateConstraints { (make) in
            make.left.equalTo(self.selectedBTN.snp_right).offset(WH(8.0))
            make.width.equalTo(WH(30.0))
            make.height.equalTo(WH(15))
        }
        
        //活动名称
        activityName.text = cellData.taoCanName
        activityName.snp_remakeConstraints { (make) in
            make.left.equalTo(self.tagLB.snp_right).offset(WH(7.0))
            make.centerY.equalTo(self.selectedBTN.snp.centerY)
            make.right.equalTo(self.stepper.snp_left).offset(-5)
        }
        
        //右箭头
        rightArrowIcon.snp_remakeConstraints { (make) in
            make.right.equalTo(self.containerView).offset(WH(0))
            make.width.equalTo(WH(0))
        }
        
        //加车器
        stepper.snp_updateConstraints { (make) in
            make.centerY.equalTo(self.selectedBTN.snp.centerY)
            make.right.equalTo(self.containerView).offset(WH(-8))
            make.width.equalTo(WH(140))
            make.height.equalTo(WH(30.0))
        }
        if cellData.fixComobLimitFlag == true{
            fixComboLimitInfoLabel.text = "每天限购\(cellData.fixComobLimitNum)套"
            fixComboLimitInfoLabel.isHidden = false
        }else{
            fixComboLimitInfoLabel.isHidden = true
        }
        let model  = cellData.modelInfo
        
        if model == nil {
            return
        }
        //商品选中状态
        selectedBTN.isUserInteractionEnabled = true
        if model?.checkedAll == true{
            self.selectedBTN.image = UIImage.init(named: "img_pd_select_select")
        }else{
            self.selectedBTN.image = UIImage.init(named: "img_pd_select_normal")
        }
        
        if model?.valid == false{
            //产品失效
            selectedBTN.isUserInteractionEnabled = false
            self.selectedBTN.image = UIImage.init(named: "img_pd_select_none")
        }
        
        if model?.editStatus != 0 {
            selectedBTN.isUserInteractionEnabled = true
            if model?.editStatus == 1 {
                self.selectedBTN.image = UIImage.init(named: "img_pd_select_normal")
            }
            else {
                self.selectedBTN.image = UIImage.init(named: "img_pd_select_select")
            }
        }
        
        // 购物车中套餐数量...<默认为1>
        var  comboNumber:Int = 1
        // 最大可购买数...<库存>...<默认为最大值>
        var maxNumber:Int = Int(SELF_SHOP_CartCount_Max)
        // 接口返回数量
        if  model!.comboNum != nil {
            comboNumber = model!.comboNum ?? 0
        }
        if model!.comboMaxNum  != nil{
            maxNumber = model!.comboMaxNum ?? 0
        }
        //        @param baseCount   起订量（门槛）
        //        *  @param stepCount   最小拆零包装（步长）
        //        *  @param stockCount   库存（最大可加车数量）
        //        *  @param quantity   当前展示(已加车)的数量
        //        *  @param isTJ   是否是特价商品
        //        *  @param minCount   限购商品最低数量
        //        *  @param maxReason  最大的提示语
        //        *  @param minReason 最小提示语
        // 门槛（起批量）固定为1; 步长固定为1;
        self.stepper.configStepperInfoBaseCount(1, stepCount: 1, stockCount: maxNumber, limitBuyNum:maxNumber, quantity: comboNumber, and: false, and: 0, and: model?.outMaxReason ?? "", and: model?.lessMinReson ?? "")
        
    }
    
    //搭配套餐布局方案
    func DPTaoCanLayoutType(cellData:CartCellTaoCanProtocol){
        
        //选中按钮
        selectedBTN.snp_remakeConstraints { (make) in
            make.top.equalTo(self.containerView).offset(WH(9.5))
            make.left.equalTo(self.containerView).offset(WH(8.0))
            make.width.height.equalTo(WH(26.0))
        }
        
        //活动类型标签
        tagLB.text = "套餐"
        // tagLB.sizeToFit()
        tagLB.layer.cornerRadius = WH(7.5)
        tagLB.layer.masksToBounds = true
        tagLB.snp_updateConstraints { (make) in
            make.left.equalTo(self.selectedBTN.snp_right).offset(WH(8.0))
            make.width.equalTo(WH(30.0))
            make.height.equalTo(WH(15))
        }
        
        //活动名称
        activityName.text = cellData.taoCanName
        activityName.snp_remakeConstraints { (make) in
            make.left.equalTo(self.tagLB.snp_right).offset(WH(7.0))
            make.centerY.equalTo(self.selectedBTN.snp.centerY)
            make.right.equalTo(self.containerView).offset(-8)
        }
        
        //右箭头
        rightArrowIcon.snp_remakeConstraints { (make) in
            make.right.equalTo(self.containerView).offset(WH(0))
            make.width.equalTo(WH(0))
        }
        
        //加车器
        stepper.snp_updateConstraints { (make) in
            make.centerY.equalTo(self.selectedBTN.snp.centerY)
            make.right.equalTo(self.containerView).offset(WH(-8))
            make.width.equalTo(WH(0))
            make.height.equalTo(WH(30))
        }
        
        let model  = cellData.modelInfo
        
        if model == nil {
            return
        }
        //商品选中状态
        selectedBTN.isUserInteractionEnabled = true
        if model?.checkedAll == true{
            self.selectedBTN.image = UIImage.init(named: "img_pd_select_select")
        }else{
            self.selectedBTN.image = UIImage.init(named: "img_pd_select_normal")
        }
        
        if model?.valid == false || (model?.comboStatus == 1 && model?.valid == true){
            //产品不可选
            selectedBTN.isUserInteractionEnabled = false
            self.selectedBTN.image = UIImage.init(named: "img_pd_select_none")
        }
        
        if model?.editStatus != 0 {
            selectedBTN.isUserInteractionEnabled = true
            if model?.editStatus == 1 {
                self.selectedBTN.image = UIImage.init(named: "img_pd_select_normal")
            }
            else {
                self.selectedBTN.image = UIImage.init(named: "img_pd_select_select")
            }
        }
        
    }
    
    //促销-满减布局方案
    func promotionMJLayoutType(cellData:CartCellPromotionInfoProtocol){
        tagLB.text = "满减"
        promotionLayoutType(cellData: cellData)
    }
    
    //促销-满折布局方案
    func promotionMZLayoutType(cellData:CartCellPromotionInfoProtocol){
        tagLB.text = "满折"
        promotionLayoutType(cellData: cellData)
    }
    
    //促销-满减和满折公共布局方案
    func promotionLayoutType(cellData:CartCellPromotionInfoProtocol){
        
        //   tagLB.sizeToFit()
        tagLB.layer.cornerRadius = WH(7.5)
        tagLB.layer.masksToBounds = true
        
        //选择按钮
        selectedBTN.snp_remakeConstraints { (make) in
            make.centerY.equalTo(self.containerView)
            make.left.equalTo(self.containerView).offset(WH(0))
            make.width.height.equalTo(0)
        }
        
        //活动名称
        activityName.text = cellData.promotionName ?? ""
        activityName.snp_remakeConstraints { (make) in
            make.left.equalTo(self.tagLB.snp_right).offset(WH(7.0))
            make.right.equalTo(self.rightArrowIcon.snp_left).offset(-18.0)
            make.centerY.equalTo(self.selectedBTN.snp.centerY)
        }
        if let promotionModel = cellData.promationInfoModel{
            if promotionModel.type == 15{
                //右箭头
                rightArrowIcon.isHidden = true
            }else{
                rightArrowIcon.isHidden = false
            }
        }
        //右箭头
        rightArrowIcon.snp_remakeConstraints { (make) in
            make.centerY.equalTo(self.selectedBTN.snp.centerY)
            make.right.equalTo(self.containerView).offset(WH(-9))
            make.width.equalTo(WH(17.0))
            make.height.equalTo(WH(17.0))
        }
        
        //加车器
        stepper.snp_updateConstraints { (make) in
            make.centerY.equalTo(self.selectedBTN.snp.centerY)
            make.right.equalTo(self.containerView).offset(WH(-9))
            make.width.equalTo(WH(0))
            make.height.equalTo(WH(30))
        }
    }
    
    //绘制边框
    func drawBorderAndCorner(){
        self.containerView.layoutIfNeeded()
        var isFirst:Bool = false
        switch self.cellModel.cellType {
        case .CartCellTypeFixTaoCanName://固定套餐名
            let cellData = self.cellModel as! CartCellFixTaoCanProtocol
            isFirst = cellData.firstObject
            
        case .CartCellTypeTaoCanName:// 搭配套餐名
            let cellData = self.cellModel as! CartCellTaoCanProtocol
            isFirst = cellData.firstObject
            
        case .CartCellTypePromotion://促销信息
            let cellData = self.cellModel as! CartCellPromotionInfoProtocol
            isFirst = cellData.firstObject
            
        default:
            
            break
        }
        
        if isFirst {
            self.marginView.isHidden = false
            configRectCornerAndBorder(view: self.containerView, corner: [.topLeft,.topRight], roundCorner: (WH(4),WH(4),0,0), border: (true,true,false,true), borderWidth: 0.5, borderColor: RGBColor(0xFF2D5C))
            self.containerView.backgroundColor = RGBColor(0xFFFAFB)
        }else{
            self.marginView.isHidden = true
            self.borderLayer.removeFromSuperlayer()
            self.containerView.backgroundColor = .white
        }
    }
}

//MARK: -类方法
extension FKYProductActivityCell {
    
    //获取cell高度
    static func getCellHeight(_ cellModel:BaseCartCellProtocol) -> CGFloat{
        switch cellModel.cellType {
        case .CartCellTypeFixTaoCanName://固定套餐名
            if let fixComobModel = cellModel as? CartCellFixTaoCanProtocol{
                if fixComobModel.fixComobLimitFlag == true{
                    return WH(67.0)
                }
            }
            return WH(45.0)
        case .CartCellTypeTaoCanName:// 搭配套餐名
            return WH(45.0)
        case .CartCellTypePromotion://促销信息
            return WH(45.0)
            
        default:
            return WH(45.0)
        }
    }
}
