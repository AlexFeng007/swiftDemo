//
//  COFollowQualityHeadView.swift
//  FKY
//
//  Created by 寒山 on 2020/11/9.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  企业和商品首营资质选择头部

import UIKit

class COFollowQualityHeadView: UIView {
    //背景
    fileprivate lazy var contentView: UIView = {
        let label = UIView()
        label.backgroundColor = bg1
        return label
    }()
    
    // 资质类型
    fileprivate lazy var qualificationTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "资质类型"
        label.font = t61.font
        label.textColor = t9.color
        return label
    }()
    
    //企业首营资料 选择按钮
    fileprivate lazy var typeOneBtn: COFollowQualitySelTypeView = {
        let typeView = COFollowQualitySelTypeView()
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.clickTypeBtnBlock {
                strongSelf.enterpriseTypeSelState = !strongSelf.enterpriseTypeSelState
                block(0,strongSelf.enterpriseTypeSelState)
            }
        }).disposed(by: disposeBag)
        typeView.addGestureRecognizer(tapGesture)
         
        return typeView
    }()
    
    //商品首营资料 选择按钮
    fileprivate lazy var typeTwoBtn: COFollowQualitySelTypeView = {
        let typeView = COFollowQualitySelTypeView()
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.clickTypeBtnBlock {
                strongSelf.productTypeSelState = !strongSelf.productTypeSelState
                block(1,strongSelf.productTypeSelState)
            }
        }).disposed(by: disposeBag)
        typeView.addGestureRecognizer(tapGesture)
    
        return typeView
    }()
    
    var clickTypeBtnBlock : ((Int,Bool)->(Void))? //点击类型按钮
    var enterpriseTypeSelState: Bool = false //企业首营资质
    var productTypeSelState: Bool = false  //商品首营资质
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView()  {
        self.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        contentView.addSubview(qualificationTypeLabel)
        qualificationTypeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(WH(14))
            make.left.equalTo(contentView.snp.left).offset(WH(15))
            make.height.equalTo(WH(17))
           // make.width.lessThanOrEqualTo(WH(80))
        }
        
        let btnW = (SCREEN_WIDTH-WH(40))/3.0
        contentView.addSubview(typeOneBtn)
        typeOneBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.qualificationTypeLabel.snp.bottom).offset(WH(8))
            make.left.equalTo(contentView.snp.left).offset(WH(15))
            make.height.equalTo(WH(40))
            make.width.equalTo(btnW)
        }
        contentView.addSubview(typeTwoBtn)
        typeTwoBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.typeOneBtn.snp.centerY)
            make.left.equalTo(self.typeOneBtn.snp.right).offset(WH(10))
            make.height.equalTo(WH(40))
            make.width.equalTo(btnW)
        }
    }
}
extension COFollowQualityHeadView {
    func configqualificationTypeData(_ titleArr:[COFollowQualificationsInfoVoModel] ,_ enterpriseSelState:Bool,_ productSelState:Bool)  {
        typeOneBtn.isHidden = true
        typeTwoBtn.isHidden = true
        self.enterpriseTypeSelState = enterpriseSelState
        self.productTypeSelState = productSelState
        for  model in titleArr{
             if model.type == "a"{
                //企业首营资质
                typeOneBtn.isHidden = false
                let titleSize =  (model.name ?? "").boundingRect(with: CGSize(width:SCREEN_WIDTH/3.0, height: WH(200)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(14)) as Any], context: nil).size
                typeOneBtn.snp.updateConstraints { (make) in
                    make.width.equalTo(titleSize.width + WH(26))
                }
                typeOneBtn.configTypeSelView(self.enterpriseTypeSelState, model.name ?? "")
             }else {
                typeTwoBtn.isHidden = false
                //商品首营资质
                let titleSize =  (model.name ?? "").boundingRect(with: CGSize(width:SCREEN_WIDTH/3.0, height: WH(200)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(14)) as Any], context: nil).size
                typeTwoBtn.snp.updateConstraints { (make) in
                    make.width.equalTo(titleSize.width + WH(26))
                }
                typeTwoBtn.configTypeSelView(self.productTypeSelState, model.name ?? "")
             }
        }
    }
    
}
//首营资质选择按钮
class COFollowQualitySelTypeView: UIView {
    //选中状态 默认没有选中
    var viewSelState: Bool = false
    //选中背景
    fileprivate lazy var contentSelView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        view.layer.cornerRadius = WH(4)
        view.layer.masksToBounds = true
        return view
    }()
    // 选中勾勾
    public lazy var selImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "follow_quality_type")
        return iv
    }()
    
    fileprivate lazy var typeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(14))
        label.textColor = RGBColor(0x333333)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView()  {
        self.backgroundColor = .clear
        self.addSubview(contentSelView)
        contentSelView.addSubview(typeTitleLabel)
        contentSelView.addSubview(selImageView)
        contentSelView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        typeTitleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(contentSelView)
        }
        selImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(WH(18))
            make.right.bottom.equalToSuperview()
        }
    }
    func configTypeSelView(_ selState:Bool,_ selTitle:String){
        self.viewSelState = selState
        typeTitleLabel.text = selTitle
        selImageView.isHidden = true
        if self.viewSelState == true{
            //选中状态
            selImageView.isHidden = false
            contentSelView.backgroundColor = RGBColor(0xFFEDE7)
            contentSelView.layer.borderWidth = 1
            contentSelView.layer.borderColor = RGBColor(0xFF2D5C).cgColor
            typeTitleLabel.textColor = RGBColor(0xFF2D5C)
        }else{
            contentSelView.backgroundColor = RGBColor(0xF4F4F4)
            contentSelView.layer.borderWidth = 0
            typeTitleLabel.textColor = RGBColor(0x333333)
        }
    }
}
