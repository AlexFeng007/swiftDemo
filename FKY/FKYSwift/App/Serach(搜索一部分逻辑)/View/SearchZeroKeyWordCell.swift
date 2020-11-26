//
//  SearchZeroKeyWordCell.swift
//  FKY
//
//  Created by 寒山 on 2020/7/6.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class SearchZeroKeyWordCell: UITableViewCell {
    
    // icon
    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // 提示
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = RGBColor(0x666666)
        lbl.textAlignment = .left
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.numberOfLines = 2 // 最多3行
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//MARK: - UI
extension SearchZeroKeyWordCell{
    /// 设置内容视图
    func setupView(){
        backgroundColor = RGBColor(0xF4F4F4)
        self.contentView.addSubview(bgView)
        bgView.addSubview(self.lblTip)
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(WH(10))
            make.left.right.bottom.equalTo(self.contentView)
        }
        self.lblTip.snp.makeConstraints { (make) in
            make.bottom.equalTo(bgView).offset(WH(-2))
            make.left.equalTo(bgView).offset(WH(14))
            make.right.equalTo(bgView).offset(WH(-19))
        }
        
    }
    
}

//MARK: - 外部接口
extension SearchZeroKeyWordCell{
    
    /// 展示零搜索词数据
    func showZeroKeyWordData(_ keyWord:String,_ isShow:Bool){
        lblTip.textAlignment = .left
        lblTip.font = UIFont.systemFont(ofSize: WH(11))
        lblTip.attributedText = SearchZeroKeyWordCell.subLowRecallString(keyWord)
        if isShow == true{
            lblTip.isHidden = false
        }else{
            lblTip.isHidden = true
        }
    }
    
    //零搜索词富文本
    static func subLowRecallString(_ keyWord:String) -> (NSMutableAttributedString) {
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        let str1 : NSAttributedString = NSAttributedString(string: "抱歉，没有找到相关商品。根据\"", attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x666666), NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(11.0))])
        let str2 : NSAttributedString = NSAttributedString(string:"\(keyWord)", attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0xFF2D5C), NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(11.0))])
        let str3 : NSAttributedString = NSAttributedString(string: "\"为您找到以下结果：", attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x666666), NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(11.0))])
        attributedStrM.append(str1)
        attributedStrM.append(str2)
        attributedStrM.append(str3)
        return attributedStrM
    }
}
