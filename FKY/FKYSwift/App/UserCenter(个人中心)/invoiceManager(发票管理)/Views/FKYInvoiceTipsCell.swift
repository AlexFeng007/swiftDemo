//
//  FKYInvoiceTipsCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/1/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYInvoiceTipsCell: UITableViewCell {

    ///提示标题
    lazy var tipsTitleLB:UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: WH(13))
        lb.textColor = RGBColor(0x333333)
        lb.text = "注意事项"
        return lb
    }()
    
    ///提示描述
    lazy var tipsDesLB:UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: WH(12))
        lb.textColor = RGBColor(0x666666)
        lb.numberOfLines = 0
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
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

//MARK: - 刷新数据
extension FKYInvoiceTipsCell {
    func showData(cellData:FKYInvoiceCellModel){
        let attStr = NSMutableAttributedString.init(string: cellData.inputText)
        let style = NSMutableParagraphStyle.init()
        style.lineSpacing = 3
        attStr.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, cellData.inputText.count))
        attStr.addAttribute(.font, value: UIFont.systemFont(ofSize: WH(13)), range: NSMakeRange(0, cellData.inputText.count))
//        self.tipsDesLB.attributedText = attStr
        self.tipsDesLB.text = cellData.inputText
        if cellData.AccessoryType == .singleTipCell {//单行提示
            noTitleLayout()
        }else{
            haveTitleLayout()
        }
    }
}

//MARK: - UI
extension FKYInvoiceTipsCell {
    func setupView(){
        self.selectionStyle = .none
        
        self.contentView.addSubview(tipsTitleLB)
        self.contentView.addSubview(tipsDesLB)
        
        tipsTitleLB.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(WH(15))
            make.top.equalTo(self.contentView).offset(WH(14))
            make.right.equalTo(self.contentView).offset(WH(-15))
//            make.bottom.equalTo(tipsDesLB.snp_top).offset(WH(-5))
        }
        
        tipsDesLB.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(WH(15))
            make.top.equalTo(self.contentView).offset(WH(11))
            make.right.equalTo(self.contentView).offset(WH(-15))
            make.bottom.equalTo(self.contentView).offset(WH(-11))
        }
    }
    
    //有title布局
    func haveTitleLayout(){
        tipsTitleLB.isHidden = false
        tipsDesLB.snp_updateConstraints { (make) in
            make.top.equalTo(self.contentView).offset(WH(37))
        }
    }
    
    ///无标题cell布局
    func noTitleLayout(){
        tipsTitleLB.isHidden = true
        tipsDesLB.snp_updateConstraints { (make) in
            make.top.equalTo(self.contentView).offset(WH(11))
        }
    }
}

extension FKYInvoiceTipsCell {
    ///获取行高
    static func getCellHeight(cellModel:FKYInvoiceCellModel) -> CGFloat{
        return calculateCellHeight(cellModel: cellModel)
    }
    
    static func calculateCellHeight(cellModel:FKYInvoiceCellModel) -> CGFloat {
        if cellModel.AccessoryType == .singleTipCell {
            return WH(11)+cellModel.inputText.ga_heightForComment(fontSize: WH(13), width: (SCREEN_WIDTH-11-15.0))+WH(11)
        }else{
            return WH(37)+cellModel.inputText.ga_heightForComment(fontSize: WH(13), width: (SCREEN_WIDTH-11-15.0))+WH(13)
        }
    }
}

extension String {
    func ga_widthForComment(fontSize: CGFloat, height: CGFloat = 15) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(rect.width)
    }
    
    func ga_heightForComment(fontSize: CGFloat, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(rect.height)
    }
    
    func ga_heightForComment(fontSize: CGFloat, width: CGFloat, maxHeight: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(rect.height)>maxHeight ? maxHeight : ceil(rect.height)
    }
}
