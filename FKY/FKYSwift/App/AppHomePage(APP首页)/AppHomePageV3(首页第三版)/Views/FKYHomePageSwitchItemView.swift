//
//  FKYHomePageSwitchItemView.swift
//  FKY
//
//  Created by 油菜花 on 2020/11/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYHomePageSwitchItemView: UIView {

    static let itemClicked = "FKYHomePageSwitchItemView-itemClicked"
    
    lazy var titleLabel:UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = .boldSystemFont(ofSize: WH(15))
        lb.textColor = RGBColor(0x333333)
        return lb
    }()
    
    lazy var subTitle:UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = .boldSystemFont(ofSize: WH(13))
        lb.layer.cornerRadius = WH(18/2.0)
        lb.layer.masksToBounds = true
        lb.textColor = RGBColor(0x999999)
        return lb
    }()
    
    lazy var rightMarginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xCCCCCC)
        return view
    }()
    
    lazy var actionBtn:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(FKYHomePageSwitchItemView.actionBtnClicked), for: .touchUpInside)
        return bt
    }()
    
    var itemData:FKYHomePageV3SwitchTabModel = FKYHomePageV3SwitchTabModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

//MARK: - 展示数据
extension FKYHomePageSwitchItemView{
    
    func showData(itemData:FKYHomePageV3SwitchTabModel){
        self.itemData = itemData
        if itemData.isSelected {
            displayType(type: 1)
        }else{
            displayType(type: 2)
        }
        showText(titleText: self.itemData.name, subTitleText: self.itemData.title)
    }
    
    func showText(titleText:String,subTitleText:String){
        titleLabel.text = titleText
        subTitle.text = "\(subTitleText)    "
    }
}

//MARK: - 响应事件
extension FKYHomePageSwitchItemView{
    @objc func actionBtnClicked(){
        routerEvent(withName: FKYHomePageSwitchItemView.itemClicked, userInfo: [FKYUserParameterKey:itemData])
    }
}


//MARK: - ui
extension FKYHomePageSwitchItemView{
    func setupUI(){
        addSubview(titleLabel)
        addSubview(subTitle)
        addSubview(rightMarginLine)
        addSubview(actionBtn)
        
        titleLabel.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(WH(0))
            make.right.equalToSuperview().offset(WH(0))
            //make.top.equalToSuperview().offset(WH(10))
            make.bottom.equalTo(self.snp_centerY).offset(-1)
        }
        
        subTitle.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(WH(18))
            //make.top.equalTo(titleLabel.snp_bottom).offset(WH(2))
            make.top.equalTo(self.snp_centerY).offset(1)
            make.width.greaterThanOrEqualTo(WH(68))
        }
        
        rightMarginLine.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(WH(24))
            make.width.equalTo(1)
        }
        
        actionBtn.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
    /// 显示样式
    /// - Parameter type: 1选中2未选中
    func displayType(type:Int){
        if type == 1{
            titleLabel.font = .boldSystemFont(ofSize: WH(17))
            subTitle.backgroundColor = RGBColor(0xFF6247)
            subTitle.textColor = RGBColor(0xFFFFFF)
        }else{
            titleLabel.font = .boldSystemFont(ofSize: WH(15))
            subTitle.backgroundColor = .clear
            subTitle.textColor = RGBColor(0x999999)
        }
    }
}
