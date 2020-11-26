//
//  COSaleAgreementWithProductCell.swift
//  FKY
//
//  Created by 寒山 on 2019/12/24.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class COSaleAgreementWithProductCell: UITableViewCell {
    
    //1 - 随货  0 - 不随货
    var selectedFollowTypeClosure: ((Int) -> ())?
    
    
    fileprivate lazy var upView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    fileprivate lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        let tapGestureMsg = UITapGestureRecognizer()
        tapGestureMsg.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.showSaleInfo()
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGestureMsg)
        return view
    }()
    
    // 下分隔线
    private var configLabelClosure: (UIColor, UIFont, String) -> UILabel = {
        (textColor, font, text) in
        let label = UILabel()
        label.textColor = textColor
        label.font = font
        label.text = text
        return label
    }
    
    private var configBtnClosure: () -> UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage(named: "img_pd_select_normal"), for: .normal)
        btn.setImage(UIImage(named: "img_pd_select_select"), for: .selected)
        return btn
    }
    
    // 下分隔线
    fileprivate lazy var viewLine: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xEBEDEC)
        return view
    }()
    
    
    private lazy var lblTitle: UILabel = self.configLabelClosure(RGBColor(0x333333), UIFont.boldSystemFont(ofSize: WH(13)), "销售合同 (纸质版)")
    
    private lazy var lineLb: UILabel = self.configLabelClosure(RGBColor(0x333333), UIFont.systemFont(ofSize: WH(13)), "随货")
    
    private lazy var offLb: UILabel = self.configLabelClosure(RGBColor(0x333333), UIFont.systemFont(ofSize: WH(13)), "不随货")
    
    //随货
    private lazy var offBtn: UIButton = self.configBtnClosure()
    //不随货
    private lazy var lineBtn: UIButton = self.configBtnClosure()
    
    //查看销售合同示例
    fileprivate lazy var saleAgreementLabel : UILabel = {
        let label = UILabel()
        label.font =  UIFont.boldSystemFont(ofSize: WH(13))
        label.textColor = RGBColor(0x999999)
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        selectionStyle = .none
        clipsToBounds = true
        layer.cornerRadius = WH(8)
        configContentViews()
        configBtnActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension COSaleAgreementWithProductCell {
    func configContentViews() {
        contentView.addSubview(upView)
        contentView.addSubview(bottomView)
        upView.addSubview(lblTitle)
        upView.addSubview(lineLb)
        upView.addSubview(offLb)
        upView.addSubview(offBtn)
        upView.addSubview(lineBtn)
        bottomView.addSubview(saleAgreementLabel)
        contentView.addSubview(viewLine)
        
        saleAgreementLabel.attributedText = self.saleAgreementString()
        
        upView.snp_makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(contentView.snp.centerY)
        }
        
        bottomView.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(contentView.snp.centerY)
            make.bottom.equalTo(contentView).offset(-0.8)
        }
        
        lblTitle.snp_makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(WH(-5))
            make.left.equalToSuperview().offset(WH(11))
        }
        
        offLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(lblTitle.snp.centerY)
            make.right.equalToSuperview().offset(-WH(11))
        }
        
        offBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(lblTitle.snp.centerY)
            make.right.equalTo(offLb.snp_left)
            make.size.equalTo(CGSize(width: WH(30), height: WH(30)))
        }
        
        lineLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(lblTitle.snp.centerY)
            make.right.equalTo(offBtn.snp_left).offset(-WH(5))
        }
        
        lineBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(lblTitle.snp.centerY)
            make.right.equalTo(lineLb.snp_left)
            make.size.equalTo(CGSize(width: WH(30), height: WH(30)))
        }
        
        saleAgreementLabel.snp_makeConstraints { (make) in
            make.top.equalToSuperview().offset(WH(5))
            make.left.equalToSuperview().offset(WH(11))
        }
        
        viewLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(0.8)
        }
    }
    
    func configBtnActions() {
        _ = offBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self](_) in
            guard let strongSelf = self else {
                return
            }
            //选中则不选
            guard strongSelf.offBtn.isSelected == false else {
                return
            }
            strongSelf.offBtn.isSelected = true
            strongSelf.lineBtn.isSelected = false
            
            strongSelf.selectedFollowTypeClosure?(0)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        
        _ = lineBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self](_) in
            guard let strongSelf = self else {
                return
            }
            //选中则不选
            guard strongSelf.lineBtn.isSelected == false else {
                return
            }
            
            strongSelf.lineBtn.isSelected = true
            strongSelf.offBtn.isSelected = false
            
            strongSelf.selectedFollowTypeClosure?(1)
            
            }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
    
    func configCellStatus(_ FollowType: Int?) {
        lineBtn.isSelected = false
        offBtn.isSelected = false
        guard let type = FollowType else {
            return
        }
        
        if type == 1 {
            lineBtn.isSelected = true
        } else if type == 0 {
            offBtn.isSelected = true
        }
    }
    fileprivate func saleAgreementString() -> (NSMutableAttributedString) {
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        let arrowImage = UIImage(named: "co_sale_agree_dir")
        
        let textAttachment : NSTextAttachment = NSTextAttachment()
        textAttachment.image = arrowImage
        
        
        
        let lineHeight = UIFont.boldSystemFont(ofSize: WH(13)).lineHeight
        //  let pointSize = UIFont.boldSystemFont(ofSize: WH(13)).pointSize
        textAttachment.bounds = CGRect(x: 2, y: lineHeight/2.0 - 7, width: 4, height:7)
        
        let productNameStr : NSAttributedString = NSAttributedString(string: "查看销售合同示例", attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x999999), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(13))])
        
        attributedStrM.append(productNameStr)
        attributedStrM.append(NSAttributedString(attachment: textAttachment))
        return attributedStrM
    }
    // 跳转到销售单示例界面
    fileprivate func showSaleInfo(){
        FKYNavigator.shared().openScheme(FKY_Web.self, setProperty: { (vc) in
            let controller = vc as! FKY_Web
            controller.urlPath = "http://yhycstatic.yaoex.com/pc/shoppingV2/checkorder/images/img_saleInfo@2x.png"
            controller.title = "销售合同示例"
            controller.barStyle = FKYWebBarStyle.barStyleWhite
        })
    }
}
