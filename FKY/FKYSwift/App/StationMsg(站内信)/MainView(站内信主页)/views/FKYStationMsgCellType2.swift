//
//  FKYStationMsgCellType2.swift
//  FKY
//
//  Created by 油菜花 on 2020/9/15.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYStationMsgCellType2: UITableViewCell {

    /// model
    var cellModel:FKYStationMsgCellModel = FKYStationMsgCellModel()
    
    /// 前面的icon
    var titleIcon:UIImageView = UIImageView()
    
    /// 主标题
    lazy var titleLB:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x333333)
        lb.font = .systemFont(ofSize:WH(14))
        return lb
    }()
    
    /// 副标题
    lazy var subTitleLB:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x999999)
        lb.font = .systemFont(ofSize:WH(12))
        return lb
    }()
    
    /// 时间
    lazy var timeLB:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x999999)
        lb.font = .systemFont(ofSize:WH(12))
        return lb
    }()
    
    /// 未读消息
    var countView:FKYMsgCountView = FKYMsgCountView()
    
    /// 分割线
    lazy var marginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
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
extension FKYStationMsgCellType2 {
    func showTestData(){
        self.titleIcon.image = UIImage(named:"mess_icon_pic")
        self.titleLB.text = "广东大康华药业有限公司"
        self.subTitleLB.text = "需要提供电子版盖公章，并且文字应该可以"
        self.timeLB.text = "昨天"
        self.countView.showCount(count: 8, WH(15))
    }
    
    func showCellData(cellModel:FKYStationMsgCellModel){
        self.cellModel = cellModel
        self.titleIcon.sd_setImage(with: URL(string:self.cellModel.data.imgUrl), placeholderImage: nil)
        self.titleLB.text = self.cellModel.data.title
        self.subTitleLB.text = self.cellModel.data.content
        self.timeLB.text = self.cellModel.data.createTime
        if self.cellModel.data.unreadCount > 0{
            self.countView.isHidden = false
            self.countView.showCount(count: self.cellModel.data.unreadCount, WH(15))
        }else{
            self.countView.isHidden = true
        }
        
    }
}


//MARK: - UI
extension FKYStationMsgCellType2 {
    func setupUI(){
        self.selectionStyle = .none
        self.contentView.addSubview(self.titleIcon)
        self.contentView.addSubview(self.titleLB)
        self.contentView.addSubview(self.subTitleLB)
        self.contentView.addSubview(self.timeLB)
        self.contentView.addSubview(self.countView)
        self.contentView.addSubview(self.marginLine)
        
        self.titleIcon.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(16))
            make.top.equalToSuperview().offset(WH(16))
            make.width.height.equalTo(WH(38))
            make.bottom.lessThanOrEqualTo(self.marginLine).offset(WH(-14))
        }
        
        self.titleLB.snp_makeConstraints { (make) in
            make.left.equalTo(self.titleIcon.snp_right).offset(WH(12))
            make.top.equalTo(self.titleIcon).offset(WH(0))
            make.right.equalTo(self.timeLB.snp_left)
        }
        
        self.subTitleLB.snp_makeConstraints { (make) in
            make.left.equalTo(self.titleLB)
            make.top.equalTo(self.titleLB.snp_bottom).offset(WH(5))
            make.right.equalTo(self.countView.snp_left).offset(WH(-10))
            make.bottom.lessThanOrEqualTo(self.marginLine).offset(WH(-14))
        }
        
        self.timeLB.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.titleLB)
            make.right.equalToSuperview().offset(WH(-15))
        }
        
        self.countView.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.subTitleLB)
            make.right.equalToSuperview().offset(WH(-15))
            //make.left.equalTo(self.subTitleLB.snp_right).offset(WH(10))
            make.height.equalTo(WH(15))
        }
        
        self.marginLine.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.timeLB.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1001), for: .horizontal)
        self.timeLB.setContentHuggingPriority(UILayoutPriority(rawValue: 1001), for: .horizontal);
    }
}
