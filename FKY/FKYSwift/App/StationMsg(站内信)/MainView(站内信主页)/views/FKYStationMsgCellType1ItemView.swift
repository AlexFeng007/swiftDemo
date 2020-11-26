//
//  FKYStationMsgCellType1ItemView.swift
//  FKY
//
//  Created by 油菜花 on 2020/9/15.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYStationMsgCellType1ItemView: UIView {

    /// item点击事件
    static let itemClickAction = "FKYStationMsgCellType1ItemView-itemClickAction"
    
    /// model
    var model = FKYStationMsgModel()
    
    /// 整个item的btn
    lazy var itemBtn:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(FKYStationMsgCellType1ItemView.itemBtnClicked), for: .touchUpInside)
        return bt
    }()
    
    /// 前面icon
    var titleIcon:UIImageView = UIImageView()
    
    /// 主标题
    lazy var titleLabel:UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 1
        lb.textColor = RGBColor(0x333333)
        lb.font = .systemFont(ofSize:WH(15))
        return lb
    }()
    
    /// 副标题
    lazy var subTitle:UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 1
        lb.textColor = RGBColor(0x999999)
        lb.font = .systemFont(ofSize:WH(12))
        return lb
    }()
    
    /// 未读消息
    var countView:FKYMsgCountView = FKYMsgCountView()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

//MARK: - 数据展示
extension FKYStationMsgCellType1ItemView {
    func showTestData(){
        self.titleLabel.text = ""
        self.subTitle.text = ""
        //self.titleIcon.image = UIImage(named:"mess_icon_pic")
        self.countView.showCount(count: 28, WH(15))
    }
    
    func showData(model:FKYStationMsgModel){
        self.model = model
        self.titleLabel.text = self.model.title
        self.subTitle.text = self.model.content
        self.titleIcon.sd_setImage(with: URL(string:self.model.imgUrl), placeholderImage: nil)
        if self.model.unreadCount > 0 {
            self.countView.isHidden = false
            self.countView.showCount(count: self.model.unreadCount, WH(15))
        }else{
            self.countView.isHidden = true
        }
    }
}

//MARK: - 事件响应
extension FKYStationMsgCellType1ItemView{
    @objc func itemBtnClicked(){
        self.routerEvent(withName: FKYStationMsgCellType1ItemView.itemClickAction, userInfo: [FKYUserParameterKey:self])
    }
}

//MARK: - UI
extension FKYStationMsgCellType1ItemView{
    func setupUI(){
        self.addSubview(self.titleIcon)
        self.addSubview(self.titleLabel)
        self.addSubview(self.subTitle)
        self.addSubview(self.countView)
        self.addSubview(self.itemBtn)
        self.titleIcon.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.height.width.equalTo(WH(39))
        }
        
        self.titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.titleIcon)
            make.left.equalTo(self.titleIcon.snp_right).offset(WH(9))
            make.right.equalTo(self.countView.snp_left).offset(-2)
        }
        self.subTitle.snp_makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.right.bottom.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp_bottom)
        }
        
        self.countView.snp_makeConstraints { (make) in
            //make.top.equalToSuperview()
            make.centerY.equalTo(self.titleLabel)
            make.right.equalToSuperview()
            make.height.equalTo(WH(15))
        }
        
        self.itemBtn.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        self.countView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        self.countView.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal);
        
    }
}
