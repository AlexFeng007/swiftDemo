//
//  FKYMatchingPackageBuyPackageCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYMatchingPackageBuyPackageCell: UITableViewCell {

    /// 购买套餐事件
    static let FKY_BuyPackageAction = "BuyPackageAction"
    
    /// cellModel
    var cellModel:FKYMatchingPackageCellModel = FKYMatchingPackageCellModel()
    
    /// 容器视图
    lazy var containerView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        return view
    }()
    
    /// 分割线
    lazy var marginView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    /// 套餐价
    lazy var packagePrice:UILabel = {
        let lb = UILabel()
        //lb.text = "套餐价：￥5445.00"
        return lb
    }()
    
    /// 原价
    lazy var originalPrice:UILabel = {
        let lb = UILabel()
        //lb.text = "套餐价：￥5445.00"
        return lb
    }()
    
    /// 购买按钮
    lazy var buyBtn:UIButton = {
        let bt = UIButton()
        bt.setTitle("购买套餐", for: .normal)
        bt.titleLabel?.font = .boldSystemFont(ofSize: WH(16))
        bt.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        bt.backgroundColor = RGBColor(0xFF2D5C)
        bt.layer.cornerRadius = WH(4)
        bt.layer.masksToBounds = true
        bt.addTarget(self, action: #selector(FKYMatchingPackageBuyPackageCell.buyPackageBtnClicked), for: .touchUpInside)
        return bt
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
//MARK: - 数据显示
extension FKYMatchingPackageBuyPackageCell{
    func showData(cellModel:FKYMatchingPackageCellModel){
        self.cellModel = cellModel
        let str1 = NSAttributedString.getAttributedStringWith(contentStr: "套餐价", color: RGBColor(0xFF2D5C), font: .systemFont(ofSize: WH(16)))
        let str2 = NSAttributedString.getAttributedStringWith(contentStr: "￥", color: RGBColor(0xFF2D5C), font: .boldSystemFont(ofSize: WH(14)))
        let str3 = NSAttributedString.getAttributedStringWith(contentStr: String.init(format: "%.2f", cellModel.dinnerPrice), color: RGBColor(0xFF2D5C), font: .boldSystemFont(ofSize: WH(18)))
        let str = NSMutableAttributedString()
        str.append(str1)
        str.append(str2)
        str.append(str3)
        self.packagePrice.attributedText = str
        
        let contentStr = "原价 ￥\(String.init(format: "%.2f", cellModel.originalPrice))"
        let attriString = NSMutableAttributedString(string: contentStr)
        attriString.addAttribute(NSAttributedString.Key.foregroundColor, value:RGBColor(0x999999), range:NSRange.init(location:0, length: contentStr.count))
        attriString.addAttribute(NSAttributedString.Key.font, value:UIFont.systemFont(ofSize: WH(14)) , range:NSRange.init(location:0, length: contentStr.count))
        attriString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.thick.rawValue, range: NSRange.init(location:0, length: contentStr.count))
        if #available(iOS 10.3, *) {
            attriString.addAttribute(NSAttributedString.Key.baselineOffset, value: 0, range: NSRange.init(location:0, length: contentStr.count))
        }
        self.originalPrice.attributedText = attriString
        self.setCorner()
    }
}


//MARK: - UI
extension FKYMatchingPackageBuyPackageCell{
    
    func setupUI(){
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.marginView)
        self.containerView.addSubview(self.packagePrice)
        self.containerView.addSubview(self.originalPrice)
        self.containerView.addSubview(self.buyBtn)
        
        self.containerView.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(10))
            make.right.equalToSuperview().offset(WH(-10))
            make.top.bottom.equalToSuperview()
        }
        
        self.marginView.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(0))
            make.right.equalToSuperview().offset(WH(0))
            make.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        self.packagePrice.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(15))
            make.top.equalToSuperview().offset(WH(14))
        }
        
        self.originalPrice.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(15))
            make.top.equalTo(self.packagePrice.snp_bottom) .offset(WH(3))
            make.bottom.equalToSuperview().offset(WH(-25))
        }
        
        self.buyBtn.snp_makeConstraints { (make) in
            make.right.equalToSuperview().offset(WH(-15))
            make.centerY.equalToSuperview().offset(WH(0))
            make.width.equalTo(WH(117))
            make.height.equalTo(WH(43))
        }
    }
    
    /// 设置圆角
    func setCorner(){
        self.packagePrice.layoutIfNeeded()
        self.originalPrice.layoutIfNeeded()
        self.buyBtn.layoutIfNeeded()
        self.containerView.layoutIfNeeded()
        self.contentView.layoutIfNeeded()
        self.layoutIfNeeded()
        self.superview?.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.001) {
            let borderLayer = CAShapeLayer()
            let borderPath = UIBezierPath(roundedRect: self.containerView.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: WH(4), height: WH(4)))
            borderLayer.path = borderPath.cgPath
            self.containerView.layer.mask = borderLayer
        }
        
    }
}

//MARK: - 事件响应
extension FKYMatchingPackageBuyPackageCell{
    
    @objc func buyPackageBtnClicked(){
        self.routerEvent(withName: FKYMatchingPackageBuyPackageCell.FKY_BuyPackageAction, userInfo: [FKYUserParameterKey:self.cellModel.dinnerID])
        print(self.containerView.bounds)
    }
}
