//
//  RISelectLongInfoCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/8/28.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  [资料管理]文字输入界面之长内容点击选择ccell
//  包括：经营范围

import UIKit

class RISelectLongInfoCell: UITableViewCell {
    // MARK: - Property
    
    // 用户点击当前cell中btn的回调block
    var callback: ( (RITextInputType)->(Void) )?
    
    // cell类型...<默认为经营范围>
    var cellType: RITextInputType = .drugScope
    
    // 星号
    fileprivate lazy var lblStar: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.textAlignment = .center
        lbl.text = "*"
        return lbl
    }()
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.text = ""
        return lbl
    }()
    
    // 输入框
    fileprivate lazy var txtview: UITextView = {
        let view = UITextView.init(frame: CGRect.zero)
        //view.delegate = self
        view.backgroundColor = .clear
        view.textAlignment = .left
        view.keyboardType = .default
        view.returnKeyType = .done
        view.font = UIFont.systemFont(ofSize: WH(14))
        view.textColor = RGBColor(0x333333)
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = false
        //view.textContainerInset = UIEdgeInsetsMake(WH(2), 0 , 0, 0)
        //view.layoutManager.allowsNonContiguousLayout = false
        view.isEditable = false // 禁止输入...<只作展示>
        return view
    }()
    
    // 提示
    var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x999999).withAlphaComponent(0.6)
        lbl.textAlignment = .left
        lbl.text = ""
        return lbl
    }()
    
    // 箭头
    fileprivate lazy var imgviewArrow: UIImageView! = {
        let view = UIImageView.init()
        view.image = UIImage.init(named: "img_pd_arrow_gray")
        view.contentMode = UIView.ContentMode.scaleAspectFit
        return view
    }()
    
    // 选择btn
    fileprivate lazy var btnSelect: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.callback else {
                return
            }
            block(strongSelf.cellType)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
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
        
        contentView.addSubview(lblStar)
        contentView.addSubview(lblTitle)
        contentView.addSubview(imgviewArrow)
        contentView.addSubview(lblTip)
        contentView.addSubview(txtview)
        contentView.addSubview(btnSelect)
        
        lblStar.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(WH(15))
        }
        lblTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(WH(15))
            make.width.lessThanOrEqualTo(WH(110))
        }
        imgviewArrow.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-WH(10))
            make.size.equalTo(CGSize.init(width: WH(20), height: WH(20)))
        }
        lblTip.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(WH(132))
        }
        txtview.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(128))
            make.right.equalTo(contentView).offset(-WH(25))
            make.top.equalTo(contentView).offset(WH(9))
            make.bottom.equalTo(contentView).offset(-WH(7))
            //make.height.greaterThanOrEqualTo(WH(30))
            make.height.equalTo(WH(30))
        }
        btnSelect.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(contentView)
            make.left.equalTo(txtview.snp.left).offset(0)
        }
    }
}

extension RISelectLongInfoCell {
    //
    func configCell(_ show: Bool, _ type: RITextInputType, _ content: String?) {
        guard show else {
            // 隐藏
            contentView.isHidden = true
            return
        }
        
        // 显示
        contentView.isHidden = false
        // 保存类型
        cellType = type
        // 赋值
        txtview.text = content
        
        // 根据类型设置输入框属性
        lblTitle.text = type.typeName
        lblTip.text = type.typeDescription
        
        // 判断placeholder是否显示
        if let txt = content, txt.isEmpty == false {
            // 有值
            lblTip.isHidden = true
        }
        else {
            // 无值
            lblTip.isHidden = false
        }
        
        // 是否必填...<必填显示星号>
        lblStar.isHidden = !type.typeInputMust
        if lblStar.isHidden {
            // 非必填
            lblTitle.snp.updateConstraints { (make) in
                make.left.equalTo(contentView).offset(WH(15))
            }
        }
        else {
            // 必填...<显示星号>
            lblTitle.snp.updateConstraints { (make) in
                make.left.equalTo(contentView).offset(WH(22))
            }
        }
        
        // 计算文字高度
        let height = calcuateTextHeight()
        // 更新
        txtview.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
        
        layoutIfNeeded()
    }
}

extension RISelectLongInfoCell {
    // 计算txtview高度
    func calcuateTextHeight() -> CGFloat {
        // 固定宽度
        let width = SCREEN_WIDTH - WH(153)
        // 计算尺寸
        let size = txtview.sizeThatFits(CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude))
        // 获取实际高度
        var height = size.height + 2
        if height <= WH(30) {
            // 下限
            height = WH(30)
        }
        return height
    }
}
