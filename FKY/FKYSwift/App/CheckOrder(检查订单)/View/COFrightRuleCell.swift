//
//  COFrightRuleCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/3/2.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

// MARK: - Cell
class COFrightRuleCell: UITableViewCell {
    // MARK: - Property

    // 内容
    fileprivate lazy var lblFright: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x666666)
        lbl.textAlignment = .left
        lbl.numberOfLines = 3
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    
    // 底部分隔线
    fileprivate lazy var viewLine: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    
    // MARK: - LifeCycle
    
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
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .white
        
        contentView.addSubview(lblFright)
        contentView.addSubview(viewLine)
        
        lblFright.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: WH(12), left: WH(15), bottom: WH(12), right: WH(10)))
        }
        viewLine.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(15))
            make.right.bottom.equalTo(contentView)
            make.height.equalTo(0.5)
        }
        
        // 默认隐藏
        viewLine.isHidden = true
    }
    
    
    // MARK: - Public
    
    func configCell(_ content: String?) {
        guard let str = content, str.isEmpty == false else {
            lblFright.text = nil
            return
        }
        lblFright.text = str
    }
    
    // 底部分隔线是否显示
    func showBottomLine(_ showFlag: Bool) {
        viewLine.isHidden = !showFlag
    }
}


// MARK: - Header
class COShopNameHeadView: UITableViewHeaderFooterView {
    
    // 背景视图
    fileprivate lazy var viewBg: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = RGBColor(0xF4F4F4)
        return view
    }()
    
    fileprivate lazy var lblName: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = RGBColor(0x333333)
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textAlignment = .left
        return lbl
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
//        backgroundColor = UIColor.white
//        backgroundColor = RGBColor(0xF4F4F4)
//        backgroundColor = .clear
        
        contentView.addSubview(viewBg)
        contentView.addSubview(lblName)
        viewBg.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        lblName.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView).offset(WH(2))
            make.left.equalTo(contentView).offset(WH(15))
            make.right.equalTo(contentView).offset(-WH(10))
        }
    }
    
    func configView(_ name: String?) {
        guard let name = name, name.isEmpty == false else {
            lblName.text = nil
            return
        }
        
        lblName.text = name
    }
}
