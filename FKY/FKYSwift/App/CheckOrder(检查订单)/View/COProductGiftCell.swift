//
//  COProductGiftCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/18.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  赠品cell

import UIKit

class COProductGiftCell: UITableViewCell {
    // MARK: - Property
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.text = "赠品"
        return lbl
    }()
    
    //  箭头
    fileprivate lazy var imgviewArrow: UIImageView = {
        let imgview = UIImageView()
        imgview.image = UIImage.init(named: "img_checkorder_arrow")
        imgview.contentMode = UIView.ContentMode.scaleAspectFit
        return imgview
    }()
    
    // 内容
    fileprivate lazy var lblContent: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .right
        lbl.text = "退热贴3盒"
        return lbl
    }()
    
    // 下分隔线
    fileprivate lazy var viewLine: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xEBEDEC)
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
        backgroundColor = .white
        
        contentView.addSubview(lblTitle)
        contentView.addSubview(imgviewArrow)
        contentView.addSubview(lblContent)
        contentView.addSubview(viewLine)
        
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(11))
            make.centerY.equalTo(contentView)
        }
        
        imgviewArrow.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(WH(-11))
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: WH(7), height: WH(12)))
        }
        
        lblContent.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-WH(26));
            make.centerY.equalTo(contentView)
        }
        
        viewLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(0.8)
        }
    }
    
    
    // MARK: - Public
    func configCell(_ giftList: [String]) {
        guard giftList.count > 0 else {
            return
        }
        lblContent.text = giftList[0]
        // 有赠品
        if giftList.count > 1 {
            // 多个赠品
            imgviewArrow.isHidden = false
            // 更新约束
            lblContent.snp.updateConstraints { (make) in
                make.right.equalTo(contentView).offset(WH(-26))
            }
        }
        else {
            // 1个赠品
            imgviewArrow.isHidden = true
            // 更新约束
            lblContent.snp.updateConstraints { (make) in
                make.right.equalTo(contentView).offset(WH(-11))
            }
        }
    }
}
