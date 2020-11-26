//
//  COOnlinePayUnfoldCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/7/6.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class COOnlinePayUnfoldCell: UITableViewCell {

    /// 展开隐藏支付方式事件
    static var FKY_ShowHidePayWayAction = "ShowHidePayWayAction"
    
    /// 上方分割线
    fileprivate lazy var viewLine: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    /// 展开/折叠按钮
    lazy var unfoldBtn:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(COOnlinePayUnfoldCell.unfoldBtnClicked), for: .touchUpInside)
        bt.setTitle("其他付款方式", for: .normal)
        bt.setTitleColor(RGBColor(0x999999), for: .normal)
        bt.setImage(UIImage(named:"COSelectOnlinePay_Down_arrow"), for: .normal)
        bt.setTitleLeftImageRightWithSpace(WH(3))
        bt.titleLabel?.font = .systemFont(ofSize: WH(12))
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

//MARK: - 事件响应
extension COOnlinePayUnfoldCell{
    
    /// 展开按钮点击
    @objc func unfoldBtnClicked(){
        self.routerEvent(withName:COOnlinePayUnfoldCell.FKY_ShowHidePayWayAction, userInfo: [FKYUserParameterKey:""])
    }
}

//MARK: - 事件响应
extension COOnlinePayUnfoldCell{

    func setupUI(){
        self.contentView.addSubview(self.viewLine)
        self.contentView.addSubview(self.unfoldBtn)
        
        self.viewLine.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(30))
            make.right.equalToSuperview().offset(-WH(30))
            make.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        self.unfoldBtn.snp_makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        self.unfoldBtn.layoutIfNeeded()
        self.unfoldBtn.layoutButton(style: .Right, imageTitleSpace: WH(3))
    }
}
