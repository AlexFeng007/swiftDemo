//
//  FKYMactchingPackageMarginCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYMactchingPackageMarginCell: UITableViewCell {

    /// 容器视图
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        return view
    }()

    /// 文描LB
    lazy var desLB: UILabel = {
        let lb = UILabel()
        lb.text = "-请选择其他搭售商品-"
        lb.textAlignment = .center
        lb.textColor = RGBColor(0x666666)
        lb.font = .systemFont(ofSize: WH(12))
        lb.backgroundColor = RGBColor(0xF4F4F4)
        return lb
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

//MARK: - ui
extension FKYMactchingPackageMarginCell {
    func setupUI() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.desLB)

        self.containerView.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(10))
            make.right.equalToSuperview().offset(WH(-10))
            make.top.bottom.equalToSuperview()
        }

        self.desLB.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(10))
            make.right.equalToSuperview().offset(WH(-10))
            make.top.bottom.equalToSuperview()
            make.height.equalTo(WH(30))
        }

    }
    
    
}
