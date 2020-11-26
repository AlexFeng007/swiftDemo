//
//  FKYWrongNumHeaderCell.swift
//  FKY
//
//  Created by 寒山 on 2019/5/20.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYWrongNumHeaderCell: UITableViewCell {
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.numberOfLines = 2
        return lbl
    }()
    
    // 顶部分隔线
    fileprivate lazy var viewTopLine: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.isHidden = true
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    // 分隔线
    fileprivate lazy var viewLine: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    fileprivate lazy var  backgroundV: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
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
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        
        let topV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(10)))
        topV.backgroundColor = RGBColor(0xf7f7f7)
        contentView.addSubview(topV)
        
        contentView.addSubview(backgroundV)
        backgroundV.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(contentView)
            make.top.equalTo(contentView).offset(WH(10))
        }
        
        backgroundV.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(backgroundV).offset(WH(15))
            make.right.equalTo(backgroundV).offset(WH(-10))
            make.centerY.equalTo(backgroundV)
        }
        
        backgroundV.addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.equalTo(backgroundV).offset(WH(15))
            make.right.equalTo(backgroundV).offset(WH(-15))
            make.bottom.equalTo(backgroundV)
            make.height.equalTo(0.5)
        }
        
        backgroundV.addSubview(viewTopLine)
        viewTopLine.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(backgroundV)
            make.height.equalTo(0.5)
        }
    }
    //显示标题
    func configTitleCell(_ title: String?) {
        lblTitle.text = title
    }

}
