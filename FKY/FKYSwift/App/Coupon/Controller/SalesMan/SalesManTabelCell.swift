//
//  SalesManTabelCell.swift
//  FKY
//
//  Created by fengbo on 2020/11/25.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import Foundation

class SalesManTableCell : UITableViewCell {
    fileprivate var bdcate : UILabel?
    fileprivate var nickName : UILabel?
    fileprivate var contactA : contactView?
    
    fileprivate var servicecate : UILabel?
    fileprivate var contactB : contactView?
    
    fileprivate var complaintcate : UILabel?
    fileprivate var contactC : contactView?
    fileprivate var contactD : contactView?
    fileprivate var isHasContacts : Bool?
    
    fileprivate var bottomLine : UIView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupView() -> () {
        
        bdcate = {
            let lab = UILabel()
            lab.fontTuple = t10
            lab.text = "业务员"
            lab.textColor = UIColor.black
            
            self.contentView.addSubview(lab)
            lab.snp.makeConstraints({ (make) in
                make.top.equalTo(self.contentView.snp.top).offset(18)
                make.left.equalTo(self.contentView.snp.left).offset(12)
                make.height.equalTo(21)
                make.width.equalTo(46)
            })
            return lab
        }()
        
        nickName = {
            let lab = UILabel()
            lab.fontTuple = t9
            lab.text = "张三"
            
            self.contentView.addSubview(lab)
            lab.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self.bdcate!.snp.centerY)
                make.left.equalTo(self.bdcate!.snp.right).offset(10)
                make.height.equalTo(20)
                make.width.equalTo(80)
            })
            return lab
        }()
        
        contactA = {
            let contactA = contactView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 40))
            contactA.layer.cornerRadius = 2
            contactA.layer.borderWidth = 1
            contactA.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
            self.contentView.addSubview(contactA)
            contactA.snp.makeConstraints { (make) in
                make.centerY.equalTo(self.bdcate!.snp.centerY)
                make.right.equalTo(self.contentView.snp.right).offset(-15)
                make.height.equalTo(30)
                make.width.equalTo(120)
            }
            return contactA
        }()
        
        //Second Row
        servicecate = {
            let lab = UILabel()
            lab.fontTuple = t10
            lab.text = "服务电话"
            lab.textColor = UIColor.black
            
            self.contentView.addSubview(lab)
            lab.snp.makeConstraints({ (make) in
                make.top.equalTo(self.bdcate!.snp.bottom).offset(24)
                make.left.equalTo(self.snp.left).offset(12)
                make.height.equalTo(21)
                make.width.equalTo(80)
            })
            return lab
        }()
        
        contactB = {
            let contactB = contactView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 40))
            contactB.layer.cornerRadius = 2
            contactB.layer.borderWidth = 1
            contactB.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
            self.contentView.addSubview(contactB)
            contactB.snp.makeConstraints { (make) in
                make.centerY.equalTo(self.servicecate!.snp.centerY)
                make.right.equalTo(self.contentView.snp.right).offset(-15)
                make.height.equalTo(30)
                make.width.equalTo(120)
            }
            return contactA
        }()
        
        
        //Third Row
        complaintcate = {
            let lab = UILabel()
            lab.fontTuple = t10
            lab.text = "投诉电话"
            lab.textColor = UIColor.black
            
            self.contentView.addSubview(lab)
            lab.snp.makeConstraints({ (make) in
                make.top.equalTo(self.servicecate!.snp.bottom).offset(24)
                make.left.equalTo(self.snp.left).offset(12)
                make.height.equalTo(21)
                make.width.equalTo(80)
            })
            return lab
        }()
        
        contactC = {
            let contactC = contactView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 40))
            contactC.layer.cornerRadius = 2
            contactC.layer.borderWidth = 1
            contactC.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
            self.contentView.addSubview(contactC)
            contactC.snp.makeConstraints { (make) in
                make.centerY.equalTo(self.complaintcate!.snp.centerY)
                make.right.equalTo(self.contentView.snp.right).offset(-15)
                make.height.equalTo(30)
                make.width.equalTo(120)
            }
            return contactC
        }()
        
        contactD = {
            let contactD = contactView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 40))
            contactD.layer.cornerRadius = 2
            contactD.layer.borderWidth = 1
            contactD.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
            self.contentView.addSubview(contactD)
            contactD.snp.makeConstraints { (make) in
                make.centerY.equalTo(self.complaintcate!.snp.centerY)
                make.right.equalTo(self.contactC!.snp.left).offset(-7)
                make.height.equalTo(30)
                make.width.equalTo(120)
            }
            return contactD
        }()
        
        bottomLine = {
            let spView = UIView()
            spView.backgroundColor = UIColor.gray
            self.contentView.addSubview(spView)
            spView.snp.makeConstraints { (make) in
                make.left.equalTo(self.contentView.snp.left).offset(0)
                make.right.equalTo(self.contentView.snp.right).offset(0)
                make.height.equalTo(0.5)
                make.bottom.equalTo(self.contentView.snp.bottom).offset(0)
            }
            return spView
        }()
    }

    func config(_ model: OftenBuySellerModel) -> () {
//        self.logo!.sd_setImage(with: URL.init(string: model.logo!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!),
//                                     placeholderImage: UIImage.init(named: "image_default_img"))
//        self.name?.text = model.shopName
//        let str = String(format: "%.2f", Double(model.orderSamount!)!)
//        self.count?.text = "最低发货金额：¥\(str)"
    }
}

//MARK: ContactView
class contactView : UIView {
    fileprivate var icon : UIImageView?
    fileprivate var phoneNum : UILabel?
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.setupSubViews()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        icon = {
            let img = UIImageView()
            img.image = UIImage.init(named: "img_phone_icon")
            self.addSubview(img)
            img.snp.makeConstraints({ (make) in
                make.left.equalTo(self.snp.left).offset(8)
                make.centerY.equalTo(self.snp.centerY)
                make.height.equalTo(14)
                make.width.equalTo(14)
            })
            return img
        }()
        
        phoneNum = {
            let lab = UILabel()
            lab.fontTuple = t8
            lab.text = "15972183581"
            lab.textColor = UIColor.black
            
            self.addSubview(lab)
            lab.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self.snp.centerY)
                make.left.equalTo(self.icon!.snp.right).offset(8)
                make.height.equalTo(14)
                make.width.equalTo(87)
            })
            return lab
        }()
    }
}
