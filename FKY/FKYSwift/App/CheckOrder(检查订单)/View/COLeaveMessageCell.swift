//
//  COLeaveMessageCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/18.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  留言cell

import UIKit

class COLeaveMessageCell: UITableViewCell {
    // MARK: - Property
    
    // 激活留言输入框回调
    var inputMessageClosure: (()->())?
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.text = "留言:"
        return lbl
    }()
    
    // 背景视图
    fileprivate lazy var viewBg: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = RGBColor(0xF6F6F6)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(4)
        return view
    }()

    // 内容输入框
    fileprivate lazy var txtview: UITextView = {
        let view = UITextView.init(frame: CGRect.zero)
        view.delegate = self
        view.backgroundColor = .clear
        view.textAlignment = .left
        view.keyboardType = .default
        view.returnKeyType = .done
        view.font = UIFont.systemFont(ofSize: WH(13))
        view.textColor = RGBColor(0x333333)
        view.showsVerticalScrollIndicator = false
        //view.textContainerInset = UIEdgeInsetsMake(WH(2), 0 , 0, 0)
        //view.layoutManager.allowsNonContiguousLayout = false
        return view
    }()
    
    // 提示
    var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x999999)
        lbl.textAlignment = .left
        lbl.text = "请填写您的特殊要求"
        return lbl
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
        contentView.addSubview(viewBg)
        
        
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(11))
            make.centerY.equalTo(contentView)
            make.width.equalTo(WH(50))
        }
        viewBg.snp.makeConstraints { (make) in
            make.left.equalTo(lblTitle.snp.right).offset(WH(10))
            make.right.equalTo(contentView).offset(WH(-11))
            make.top.equalTo(contentView).offset(WH(14))
            make.bottom.equalTo(contentView).offset(-WH(14))
        }
        
        // 上下margin总宽度28
        // 输入框宽度为[屏宽-90-5]
        viewBg.addSubview(lblTip)
        viewBg.addSubview(txtview)
        
        lblTip.snp.makeConstraints { (make) in
            make.top.equalTo(viewBg).offset(WH(8))
            make.left.equalTo(viewBg).offset(WH(5))
        }
        txtview.snp.makeConstraints { (make) in
            make.edges.equalTo(viewBg).inset(UIEdgeInsets(top: WH(0), left: WH(5), bottom: WH(0), right: WH(0)))
        }
        
        // 下分隔线
        let viewLineBottom = UIView()
        viewLineBottom.backgroundColor = RGBColor(0xEBEDEC)
        self.addSubview(viewLineBottom)
        viewLineBottom.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.8)
        }
    }
    
    
    // MARK: - Public
    
    func configCell(_ msg: String?) {
        guard let msg = msg, msg.isEmpty == false else {
            lblTip.isHidden = false
            txtview.text = nil
            return
        }
        
        lblTip.isHidden = true
        txtview.text = msg
    }
}


extension COLeaveMessageCell: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        // 提示语隐藏
        //lblTip.isHidden = true
        if let txt = textView.text, txt.count > 0 {
            lblTip.isHidden = true
        }
        else {
            lblTip.isHidden = false
        }
        // 输入框激活，需弹出定制的输入视图
        if let closure = inputMessageClosure {
            closure()
        }
        return false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let txt = textView.text, txt.count > 0 {
            lblTip.isHidden = true
        }
        else {
            lblTip.isHidden = false
        }
    }
}


extension COLeaveMessageCell {
    // 计算当前cell高度
    class func calculateCellHeight(_ content: String) -> CGFloat {

        // 换一种方式计算textview文字高度
        let heightMax = WH(62) // 最大高度
        let width = SCREEN_WIDTH - WH(5) - WH(90) - WH(12) // 固定宽度
        let txtView: UITextView = UITextView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: heightMax))
        txtView.font = UIFont.systemFont(ofSize: WH(13))
        txtView.text = content
        let size: CGSize = txtView.sizeThatFits(CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude))
        var height = size.height + WH(2)
        if height > heightMax {
            height = heightMax
        }
        else if height < WH(30) {
            height = WH(30)
        }
        return height + WH(28)
    }
}
