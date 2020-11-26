//
//  FKYShopMainContentsTableViewCell.swift
//  FKY
//
//  Created by hui on 2019/10/29.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYShopMainContentsTableViewCell: UITableViewCell {
    //MARK:ui
    //红色标
    fileprivate lazy var tagLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = t73.color
        return label
    }()
    //标题
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = t31.color
        label.font = t33.font
        return label
    }()
    //不可复制内容
    fileprivate lazy var contentNoCopyLabel : UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.fontTuple =  t8
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    //可复制
    fileprivate lazy var contentLabel : UITextView = {
        let label = UITextView()
        label.font =  t31.font
        label.textColor = t31.color
        label.sizeToFit()
        label.isEditable = false
        label.isScrollEnabled = false
        label.textContainer.lineFragmentPadding = 0
        label.textContainerInset  = .zero
        return label
    }()
    //查看详情
    fileprivate lazy var lookDetailView : UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    //查看详情文字
    fileprivate var lookDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "查看详情"
        label.fontTuple = t11
        label.textAlignment = .right
        return label
    }()
    //查看详情箭头
    fileprivate var lookDetailImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "icon_cart_gray_arrow_right")
        return img
    }()
    // 底部分隔线
    fileprivate lazy var bottomLine : UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = bg7
        return view
    }()
    
    //业务属性
    var clickContentView : (()->(Void))? //点击视图
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.isHidden = true
        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(10))
            make.top.equalTo(contentView.snp.top).offset(WH(13))
            make.height.equalTo(WH(12))
            make.width.equalTo(WH(3))
        })
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(tagLabel.snp.right).offset(WH(4))
            make.centerY.equalTo(tagLabel.snp.centerY)
            make.height.equalTo(WH(17))
            make.width.equalTo(WH(30))
        })
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(titleLabel.snp.right).offset(WH(8))
            make.top.equalTo(contentView.snp.top).offset(WH(12))
            make.right.equalTo(contentView.snp.right).offset(-WH(14))
            //make.height.greaterThanOrEqualTo(WH(12))
            make.bottom.equalTo(contentView.snp.bottom).offset(-WH(12))
        })
        
        contentView.addSubview(contentNoCopyLabel)
        contentLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(titleLabel.snp.right).offset(WH(8))
            make.top.equalTo(contentView.snp.top).offset(WH(12))
            make.right.equalTo(contentView.snp.right).offset(-WH(14))
            make.bottom.equalTo(contentView.snp.bottom).offset(-WH(12))
        })
        
        //查看详情
        contentView.addSubview(lookDetailView)
        lookDetailView.snp.makeConstraints({ (make) in
            make.top.equalTo(contentView.snp.top).offset(WH(13))
            make.right.equalTo(contentView.snp.right).offset(-WH(20))
            make.height.equalTo(WH(12))
            make.width.equalTo(WH(67))
        })
        lookDetailView.addSubview(lookDetailImageView)
        lookDetailImageView.snp.makeConstraints({ (make) in
            make.centerY.equalTo(lookDetailView.snp.centerY)
            make.right.equalTo(lookDetailView.snp.right)
        })
        lookDetailView.addSubview(lookDetailLabel)
        lookDetailLabel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(lookDetailView.snp.centerY)
            make.right.equalTo(lookDetailImageView.snp.left).offset(-WH(5))
        })
        lookDetailView.bk_(whenTapped: { [weak self] in
            if let strongSelf = self {
                if let block  = strongSelf.clickContentView{
                    block()
                }
            }
        })
        
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints({ (make) in
            make.bottom.left.right.equalTo(contentView)
            make.height.equalTo(0.5)
        })
        
    }
    
    /// 不要前面的红色标记
    func noMarkIconLayout(){
        self.tagLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0)
        }
        
        self.titleLabel.snp_updateConstraints({ (make) in
            make.left.equalTo(tagLabel.snp.right).offset(WH(0))
        })
    }
}

extension FKYShopMainContentsTableViewCell {
    //商家信息《开户，发票，入库，公告》(默认样式)
    func configShopMainTabelCellData(_ title:String ,_ content:String,_ type:Int) {
        if content.count == 0 {
            self.isHidden = true
        }else {
            let contentAttStr = content.fky_getAttributedHTMLStringWithLineSpace(WH(5))
            //var lineSpace = WH(0)
            self.isHidden = false
            lookDetailView.isHidden = true
            contentNoCopyLabel.isHidden = true
            if type == 0 {
                //公告类型（带查看详情按钮）
                lookDetailView.isHidden = false
                contentLabel.snp.remakeConstraints({ (make) in
                    make.left.equalTo(contentView.snp.left).offset(round(WH(55)))
                    make.top.equalTo(contentView.snp.top).offset(round(WH(12)))
                    make.right.equalTo(contentView.snp.right).offset(-round(WH(90)))
                    //make.height.greaterThanOrEqualTo(round(WH(12)))
                    make.bottom.equalTo(contentView.snp.bottom) //.offset(-round(WH(14)))
                })
                //                if let content_w = contentAttStr?.boundingRect(with: CGSize(width: SCREEN_WIDTH-round(WH(55))-round(WH(90)), height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .truncatesLastVisibleLine, .usesLineFragmentOrigin], context: nil).width {
                //                    if content_w > WH(18) {
                //                        lineSpace = WH(5)
                //                    }
                //                }
            }else if type == 4 || type == 3 {
                contentLabel.snp.remakeConstraints({ (make) in
                    make.left.equalTo(contentView.snp.left).offset(round(WH(55)))
                    make.top.equalTo(contentView.snp.top).offset(round(WH(12)))
                    make.right.equalTo(contentView.snp.right).offset(-round(WH(14)))
                    //make.height.greaterThanOrEqualTo(round(WH(12)))
                    make.bottom.equalTo(contentView.snp.bottom).offset(-round(WH(12)))
                })
                //                if let content_w = contentAttStr?.boundingRect(with: CGSize(width: SCREEN_WIDTH-round(WH(55)-round(WH(14))), height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .truncatesLastVisibleLine, .usesLineFragmentOrigin], context: nil).width {
                //                    if content_w > WH(18) {
                //                        lineSpace = WH(5)
                //                    }
                //                }
            }else {
                contentLabel.snp.remakeConstraints({ (make) in
                    make.left.equalTo(contentView.snp.left).offset(round(WH(55)))
                    make.top.equalTo(contentView.snp.top).offset(round(WH(12)))
                    make.right.equalTo(contentView.snp.right).offset(-round(WH(14)))
                    // make.height.greaterThanOrEqualTo(round(WH(12)))
                    make.bottom.equalTo(contentView.snp.bottom) //.offset(-round(WH(14)))
                })
            }
            
            //contentAttStr?.yy_setLineSpacing(lineSpace, range: NSMakeRange(0, contentAttStr?.length ?? 0))
            self.contentLabel.attributedText = contentAttStr
            self.contentLabel.font = t31.font
            self.titleLabel.text = title
        }
    }
    func resetBottomLine(_ hideLine:Bool){
        bottomLine.isHidden = hideLine
    }
}
//MARK:企业信息相关赋值
extension FKYShopMainContentsTableViewCell {
    func configEnterpriseInfomationTabelCellData(_ title:String ,_ content:String,_ type:Int) {
        if content.count == 0 {
            self.isHidden = true
        }else {
            self.isHidden = false
            lookDetailView.isHidden = true
            tagLabel.isHidden = true
            titleLabel.isHidden = true
            contentNoCopyLabel.isHidden = true
            if type == 0 {
                //企业介绍
                contentLabel.snp.remakeConstraints({ (make) in
                    make.left.equalTo(contentView.snp.left).offset(round(WH(14)))
                    make.top.equalTo(contentView.snp.top).offset(round(WH(12)))
                    make.right.equalTo(contentView.snp.right).offset(-round(WH(14)))
                    //make.height.greaterThanOrEqualTo(round(WH(12)))
                    make.bottom.equalTo(contentView.snp.bottom).offset(-round(WH(14)))
                })
            }else {
                //经营范围/销售区域/开户流程与说明
                tagLabel.isHidden = false
                titleLabel.isHidden = false
                titleLabel.font = UIFont.boldSystemFont(ofSize: WH(17))
                tagLabel.snp.updateConstraints({ (make) in
                    make.top.equalTo(contentView.snp.top).offset(WH(19))
                })
                titleLabel.snp.remakeConstraints({ (make) in
                    make.left.equalTo(tagLabel.snp.right).offset(WH(7))
                    make.centerY.equalTo(tagLabel.snp.centerY)
                    make.height.equalTo(WH(24))
                    make.right.equalTo(contentView.snp.right).offset(-WH(10))
                })
                contentLabel.snp.remakeConstraints({ (make) in
                    make.left.equalTo(contentView.snp.left).offset(round(WH(14)))
                    make.top.equalTo(contentView.snp.top).offset(round(WH(46)))
                    make.right.equalTo(contentView.snp.right).offset(-round(WH(14)))
                    //make.height.greaterThanOrEqualTo(round(WH(12)))
                    make.bottom.equalTo(contentView.snp.bottom).offset(-round(WH(14)))
                })
                self.titleLabel.text = title
            }
            //标题和内容一行的样式
            let contentAttStr = content.fky_getAttributedHTMLStringWithLineSpace(WH(5))
            var lineSpace = WH(0)
            if let content_w = contentAttStr?.boundingRect(with: CGSize(width: SCREEN_WIDTH-round(WH(14))-round(WH(14)), height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .truncatesLastVisibleLine, .usesLineFragmentOrigin], context: nil).width {
                if content_w > WH(18) {
                    lineSpace = WH(5)
                }
            }
            contentAttStr?.yy_setLineSpacing(lineSpace, range: NSMakeRange(0, contentAttStr?.length ?? 0))
            self.contentLabel.attributedText = contentAttStr
            self.contentLabel.font = t31.font
        }
    }
}
//MARK:发票列表注意cell
extension FKYShopMainContentsTableViewCell {
    func configInvoiceAttentionTabelCellData(_ content:String) {
        if content.count > 0 {
            self.isHidden = false
            lookDetailView.isHidden = true
            tagLabel.isHidden = true
            contentLabel.isHidden = true
            bottomLine.isHidden = true
            
            titleLabel.font = t61.font
            titleLabel.text = "注意事项"
            titleLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(contentView.snp.left).offset(WH(15))
                make.top.equalTo(contentView.snp.top).offset(WH(14))
                make.height.equalTo(WH(17))
                make.width.equalTo(WH(120))
            }
            contentNoCopyLabel.text = content
            contentNoCopyLabel.isHidden = false
            contentNoCopyLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(contentView.snp.left).offset(round(WH(15)))
                make.top.equalTo(self.titleLabel.snp.bottom).offset(round(WH(6)))
                make.right.equalTo(contentView.snp.right).offset(-round(WH(11)))
                make.bottom.equalTo(contentView.snp.bottom).offset(-round(WH(14)))
            }
            
        }else {
            self.isHidden = true
        }
    }
}
//MARK:电子普通发票规则
extension FKYShopMainContentsTableViewCell {
    func configInvoiceRuleTabelCellData(_ content:String) {
        if content.count > 0 {
            self.isHidden = false
            lookDetailView.isHidden = true
            tagLabel.isHidden = true
            contentLabel.isHidden = true
            titleLabel.isHidden = true
            
            contentNoCopyLabel.text = content
            contentNoCopyLabel.isHidden = false
            contentNoCopyLabel.fontTuple = t11
            contentNoCopyLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(contentView.snp.left).offset(round(WH(15)))
                make.top.equalTo(contentView.snp.top).offset(round(WH(11)))
                make.right.equalTo(contentView.snp.right).offset(-round(WH(11)))
                make.bottom.equalTo(contentView.snp.bottom).offset(-round(WH(10)))
            }
            bottomLine.isHidden = false
            bottomLine.snp.remakeConstraints({ (make) in
                make.top.left.right.equalTo(contentView)
                make.height.equalTo(0.5)
            })
        }else {
            self.isHidden = true
        }
    }
}
