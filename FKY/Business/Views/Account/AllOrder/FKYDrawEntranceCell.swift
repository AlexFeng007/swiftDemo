//
//  FKYDrawEntranceCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/4/21.
//  Copyright © 2020 yiyaowang. All rights reserved.
// 订单详情入口

import UIKit

/// 入口按钮点击事件
let FKY_entranceButtonClicked = "entranceButtonClicked"

class FKYDrawEntranceCell: UITableViewCell {

    /// 入口按钮
    var entranceButton:UIButton = {
        let bt  = UIButton()
        bt.addTarget(self, action: #selector(FKYDrawEntranceCell.entranceButtonClicked), for: .touchDown)
        bt.isUserInteractionEnabled = false
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

// MARK: - UI
extension FKYDrawEntranceCell {
    func setupUI(){
        
        self.selectionStyle = .none
        //self.contentView.addSubview(self.entranceButton)
        contentView.addSubview(self.entranceButton)
        
        self.entranceButton.snp_makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
            //make.height.equalTo(WH(88))
        }
        self.bringSubviewToFront(self.entranceButton)
    }
    
    @objc static func getCellHeight() ->CGFloat {
        let cellHeight:CGFloat = SCREEN_WIDTH * 168 / 710
        return cellHeight
    }
}

// MARK: - 响应事件
extension FKYDrawEntranceCell {
    
    /// 入口按钮点击
    @objc func entranceButtonClicked(){
        self.routerEvent(withName: FKY_entranceButtonClicked, userInfo: [FKYUserParameterKey:""])
    }
    
}

// MARK: - 数据显示
extension FKYDrawEntranceCell {
    
    /// 配置显示的图片
    /// - Parameter cellData: 图片地址
    @objc func configCellData(cellData:String){
        self.entranceButton.sd_setBackgroundImage(with: URL(string: cellData), for: .normal)
    }
    
}
