//
//  RCTypeSelectHeadView.swift
//  FKY
//
//  Created by 寒山 on 2018/11/26.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import UIKit

typealias AllCheckStausChange = ()->()
typealias ApplyChangeGoodAction = ()->()//申请换货
typealias ApplyReturnGoodAction = ()->()//申请退货


// MARK: - Header
class RCTypeSelectHeadView: UITableViewHeaderFooterView {
    //
    var allCheckStausChange : AllCheckStausChange?
    
    fileprivate lazy var selectIcon: UIButton = {
        let button = UIButton ()
        button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        button.setImage(UIImage(named:"cart_list_unselect_new"), for: .normal)
        button.bk_addEventHandler({ (btn) in
            if self.allCheckStausChange != nil {
                self.allCheckStausChange!()
            }
        }, for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var titleL: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.fontTuple = t7
        label.text = "订单"
        return label
    }()
    
    fileprivate lazy var orderNumL: UILabel = {
        let label = UILabel()
        label.fontTuple = t72
        //label.text = "xxd20180909289667889000"
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        let backgroundV = UIView()
        backgroundV.backgroundColor = UIColor.white
        
        //        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(10)))
        //        headView.backgroundColor = RGBColor(0xf7f7f7)
        
        contentView.addSubview(backgroundV)
        //   contentView.addSubview(headView)
        contentView.addSubview(selectIcon)
        contentView.addSubview(titleL)
        contentView.addSubview(orderNumL)
        
        backgroundV.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(contentView)
            make.top.equalTo(contentView)
        }
        
        selectIcon.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView)
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(WH(36))
        }
        titleL.snp.makeConstraints { (make) in
            make.left.equalTo(selectIcon.snp.right).offset(WH(11))
            make.centerY.equalTo(contentView)
        }
        
        orderNumL.snp.makeConstraints { (make) in
            make.left.equalTo(titleL.snp.right).offset(WH(5))
            make.centerY.equalTo(contentView)
        }
        
        let line = UIView()
        line.backgroundColor = RGBColor(0xE5E5E5)
        backgroundV.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(backgroundV)
            make.height.equalTo(0.5)
        }
    }
    
    func configView(_ childOrderID:String?,_ checkStatus:Bool?){
        orderNumL.text = childOrderID
        if checkStatus == true {
            selectIcon.setImage(UIImage(named:"cart_new_selected"), for: .normal)
        }else{
            selectIcon.setImage(UIImage(named:"cart_list_unselect_new"), for: .normal)
        }
    }
}

// MARK: - Footer
class RCTypeSelectFooterView: UITableViewHeaderFooterView {
    
    var applyChangeGoodAction : ApplyChangeGoodAction?
    var applyReturnGoodAction : ApplyReturnGoodAction?
    
    fileprivate lazy var topV: UIView = {
        let iv = UIView()
        iv.backgroundColor = UIColor.white
        return iv
    }()
    fileprivate lazy var bottomV: UIView = {
        let iv = UIView()
        iv.backgroundColor = UIColor.white
        return iv
    }()
    fileprivate lazy var line: UIView = {
        let iv = UIView()
        iv.backgroundColor = RGBColor(0xE5E5E5)
        return iv
    }()
    
    fileprivate lazy var applyBackImageV: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "returnGood_icon")
        return imgV
    }()
    
    fileprivate lazy var applyChangeImageV: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "replaceGood_icon")
        return imgV
    }()
    
    fileprivate lazy var applyBackL: UILabel = {
        let label = UILabel()
        label.text = "申请退货"
        label.textColor = RGBColor(0x000000)
        label.font = UIFont.boldSystemFont(ofSize: WH(18))
        return label
    }()
    
    fileprivate lazy var applyChangeL: UILabel = {
        let label = UILabel()
        label.text = "申请换货"
        label.textColor = RGBColor(0x000000)
        label.font = UIFont.boldSystemFont(ofSize: WH(18))
        return label
    }()
    
    fileprivate lazy var applyBackDescL: UILabel = {
        let label = UILabel()
        label.text = "已收货，需要退回该商品"
        label.textColor = RGBColor(0x959595)
        label.font = UIFont.systemFont(ofSize: WH(12))
        return label
    }()
    
    fileprivate lazy var applyChangeDescL: UILabel = {
        let label = UILabel()
        label.text = "已收货，需要更换已收到的商品"
        label.textColor = RGBColor(0x959595)
        label.font = UIFont.systemFont(ofSize: WH(12))
        return label
    }()
    
    fileprivate lazy var applyBackDir: UIImageView = {
        let imgV = UIImageView(image: UIImage(named: "icon_cart_gray_arrow_right"))
        return imgV
    }()
    
    fileprivate lazy var applyChangeDir: UIImageView = {
        let imgV = UIImageView(image: UIImage(named: "icon_cart_gray_arrow_right"))
        return imgV
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        //        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(10)))
        //        headView.backgroundColor = RGBColor(0xf7f7f7)
        //        contentView.addSubview(headView)
        
        
        contentView.addSubview(topV)
        topV.addSubview(applyBackImageV)
        topV.addSubview(applyBackL)
        topV.addSubview(applyBackDescL)
        topV.addSubview(applyBackDir)
        
        
        contentView.addSubview(line)
        
        contentView.addSubview(bottomV)
        bottomV.isUserInteractionEnabled = true
        bottomV.bk_(whenTapped:  {
            if self.applyChangeGoodAction != nil {
                self.applyChangeGoodAction!()
            }
        })
        
        topV.isUserInteractionEnabled = true
        topV.bk_(whenTapped:  {
            if self.applyReturnGoodAction != nil {
                self.applyReturnGoodAction!()
            }
        })
        
        bottomV.addSubview(applyChangeImageV)
        bottomV.addSubview(applyChangeL)
        bottomV.addSubview(applyChangeDescL)
        bottomV.addSubview(applyChangeDir)
        
        topV.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(contentView)
            make.height.equalTo(WH(59.5))
        }
        
        applyBackImageV.snp.makeConstraints { (make) in
            make.left.equalTo(topV).offset(WH(23))
            make.centerY.equalTo(topV)
        }
        
        applyBackL.snp.makeConstraints { (make) in
            make.left.equalTo(applyBackImageV.snp.right).offset(WH(16))
            make.centerY.equalTo(topV)
        }
        
        applyBackDir.snp.makeConstraints { (make) in
            make.right.equalTo(topV).offset(-WH(10))
            make.centerY.equalTo(topV)
        }
        
        applyBackDescL.snp.makeConstraints { (make) in
            make.right.equalTo(applyBackDir.snp.left).offset(-WH(5))
            make.centerY.equalTo(topV)
        }
        
        line.snp.makeConstraints { (make) in
            make.left.right.centerY.equalTo(contentView)
            make.height.equalTo(0.5)
        }
        
        bottomV.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(WH(59.5))
        }
        
        applyChangeImageV.snp.makeConstraints { (make) in
            make.left.equalTo(bottomV).offset(WH(23))
            make.centerY.equalTo(bottomV)
        }
        
        applyChangeL.snp.makeConstraints { (make) in
            make.left.equalTo(applyChangeImageV.snp.right).offset(WH(16))
            make.centerY.equalTo(bottomV)
        }
        
        applyChangeDir.snp.makeConstraints { (make) in
            make.right.equalTo(bottomV).offset(-WH(10))
            make.centerY.equalTo(bottomV)
        }
        
        applyChangeDescL.snp.makeConstraints { (make) in
            make.right.equalTo(applyChangeDir.snp.left).offset(-WH(5))
            make.centerY.equalTo(bottomV)
        }
    }
}
extension RCTypeSelectFooterView {
    func configSelectFooterView(_ rcType:Int , _ showReplace:Bool)  {
        topV.isHidden = true
        bottomV.isHidden = true
        line.isHidden = true
        applyBackImageV.isHidden = false
        applyBackDescL.isHidden = true
        topV.snp.updateConstraints { (make) in
            make.height.equalTo(WH(59.5))
        }
        applyBackL.snp.remakeConstraints { (make) in
            make.left.equalTo(applyBackImageV.snp.right).offset(WH(16))
            make.centerY.equalTo(topV)
        }
        applyBackL.textColor = RGBColor(0x000000)
        applyBackL.font = UIFont.boldSystemFont(ofSize: WH(18))
        
        if rcType == 2 {
            if showReplace == true {
                topV.snp.updateConstraints { (make) in
                    make.height.equalTo(WH(0))
                }
                bottomV.isHidden = false
            }else {
                topV.isHidden = false
                bottomV.isHidden = false
                line.isHidden = false
                applyBackDescL.isHidden = false
            }
        }else {
            topV.isHidden = false
            if rcType == 1 {
                //mp退货
                applyBackImageV.image = UIImage(named: "returnGood_icon")
                applyBackL.text = "申请退货"
                applyBackDescL.text = "已收货，需要退回该商品"
                applyBackDescL.isHidden = false
            }else if rcType == 3 {
                //自营极速理赔
                applyBackImageV.image = UIImage(named: "returnGood_icon")
                applyBackL.text = "极速理赔"
                applyBackDescL.text = ""
                
                applyBackL.textColor = RGBColor(0x333333)
                applyBackL.font = UIFont.boldSystemFont(ofSize: WH(14))
                applyBackImageV.isHidden = true
                topV.snp.updateConstraints { (make) in
                    make.height.equalTo(WH(44))
                }
                applyBackL.snp.remakeConstraints { (make) in
                    make.left.equalTo(self.topV.snp.left).offset(WH(15))
                    make.centerY.equalTo(topV)
                }
            }
        }
    }
}
