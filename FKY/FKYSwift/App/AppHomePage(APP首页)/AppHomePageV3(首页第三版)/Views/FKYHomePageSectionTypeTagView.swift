//
//  FKYHomePageSectionTypeTagView.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/21.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  给首页豆腐块打的标签

import UIKit

class FKYHomePageSectionTypeTagView: UIView {

    /// 标签点击事件
    static let tagClickAction = "FKYHomePageSectionTypeTagView-tagClickAction"
    
    /// 标签名称
    lazy var tagName:UILabel = {
        let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: WH(11))
        lb.textAlignment = .center
        return lb
    }()
    
    /// 标签右箭头
    lazy var rightArrow:UIImageView = UIImageView()
    
    /// 标签点击按钮
    lazy var actionBtn:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(FKYHomePageSectionTypeTagView.actionBtnClicked), for: .touchUpInside)
        return bt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 数据展示
extension FKYHomePageSectionTypeTagView{
    /*
    func showTestData(){
        configViewType(iconName: "home_shop_dir_violet", borderColor: RGBColor(0x8D56EF), cornerRadius: WH(16/2.0), textColor: RGBColor(0x8D56EF), tagName: "测试豆腐块")
    }
    */
    func configTitle(title:String){
        self.tagName.text = " \(title)"
    }
    
    func configType(iconName:String,borderColor:UIColor,cornerRadius:CGFloat,textColor:UIColor){
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.cgColor
        rightArrow.image = UIImage(named: iconName)
        self.tagName.textColor = textColor
    }
    /*
    /// 配置颜色 icon icon只接受本地图片
    func configViewType(iconName:String,borderColor:UIColor,cornerRadius:CGFloat,textColor:UIColor,tagName:String){
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.cgColor
        rightArrow.image = UIImage(named: iconName)
        self.tagName.text = tagName
        self.tagName.textColor = textColor
    }
    */
}

//MARK: - 事件响应
extension FKYHomePageSectionTypeTagView{
    @objc func actionBtnClicked(){
        self.routerEvent(withName: FKYHomePageSectionTypeTagView.tagClickAction, userInfo: [FKYUserParameterKey:""])
    }
}



//MARK: - UI
extension FKYHomePageSectionTypeTagView{
    func setupUI(){
        self.addSubview(tagName)
        self.addSubview(rightArrow)
        self.addSubview(actionBtn)
        
        tagName.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(4))
            make.top.bottom.equalToSuperview()
        }
        
        rightArrow.snp_makeConstraints { (make) in
            make.left.equalTo(tagName.snp_right).offset(WH(2))
            make.centerY.equalToSuperview()
            make.width.equalTo(WH(3.3))
            make.height.equalTo(WH(5.9))
            make.right.equalToSuperview().offset(WH(-4))
        }
        
        actionBtn.snp_makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
}
