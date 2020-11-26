//
//  DelayInfoDetailCell.swift
//  FKY
//
//  Created by 寒山 on 2019/2/19.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
typealias CheckOrderInfo = ()->()
class DelayInfoDetailCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate var titleLabel : UILabel?
    fileprivate var detailLabel : UILabel?
    
    fileprivate func setupView() -> () {
        
        titleLabel = {
            let view = UILabel()
            self.contentView.addSubview(view);
            view.snp.makeConstraints({ (make) in
                make.left.equalTo(self.contentView.snp.left).offset(WH(15))
                make.centerY.equalTo(self.contentView)
            })
            view.font = UIFont.boldSystemFont(ofSize: WH(16))
            view.textColor = RGBColor(0x333333)
            return view
        }()
        
        detailLabel = {
            let view = UILabel()
            self.contentView.addSubview(view);
            view.snp.makeConstraints({ (make) in
                make.right.equalTo(self.contentView.snp.right).offset(WH(-17))
                make.centerY.equalTo(self.contentView)
            })
            view.font = t12.font
            view.textColor = t9.color
            return view
        }()
        // 底部分隔线
        let v = UIView()
        v.backgroundColor = bg7
        contentView.addSubview(v)
        v.snp.makeConstraints({ (make) in
            make.right.equalTo(contentView)
            make.left.equalTo(contentView).offset(WH(15))
            make.bottom.equalTo(contentView)
            make.height.equalTo(0.5)
        })
    }
    func configCell(_ index:Int,_ model:DelayRebateInfoModel) -> () {
        //_ titleStr:String,_ detailStr:String
        var titleStr:String?
        var detailStr:String?
        if index == 2{
            //显示价格
            detailLabel!.font = t73.font
            detailLabel!.textColor = t73.color
        }else{
            detailLabel!.font = t12.font
            detailLabel!.textColor = t9.color
        }
        if index == 0{
            titleStr = "商家"
            detailStr = model.enterprise_name
        }else if index == 1{
            titleStr = "订单号"
            detailStr = model.order_id
        }
        else if index == 2{
            titleStr = "返利金额"
            detailStr = String(format:"%.2f元",model.rebate_money!)
        }
        detailLabel!.text = detailStr
        titleLabel!.text = titleStr
    }
}
class DelayTimeInfoCell: UITableViewCell {
    var checkOrderInfo: CheckOrderInfo?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate var titleLabel : UILabel?
    fileprivate var detailLabel : UILabel?
    fileprivate var tipLabel : UILabel?
    fileprivate var orderButton : UIButton?
    fileprivate var footView:UIView?
    fileprivate var lineView:UIView?
    fileprivate func setupView() -> () {
        
        titleLabel = {
            let view = UILabel()
            view.text = "到账时间"
            self.contentView.addSubview(view);
            view.snp.makeConstraints({ (make) in
                make.left.equalTo(self.contentView.snp.left).offset(WH(15))
                make.top.equalTo(self.contentView).offset(WH(14))
            })
            view.font = UIFont.boldSystemFont(ofSize: WH(16))
            view.textColor = RGBColor(0x333333)
            return view
        }()
        
        detailLabel = {
            let view = UILabel()
            view.text = "订单确认后展示具体到账时间"
            self.contentView.addSubview(view);
            view.snp.makeConstraints({ (make) in
                make.right.equalTo(self.contentView.snp.right).offset(WH(-17))
                make.centerY.equalTo(titleLabel!.snp.centerY)
            })
            view.font = t12.font
            view.textColor = RGBColor(0x2D8AFF)
            return view
        }()
        
        tipLabel = {
            let view = UILabel()
            
            self.contentView.addSubview(view);
            view.isHidden = true
            view.snp.makeConstraints({ (make) in
                make.right.equalTo(self.contentView.snp.right).offset(WH(-17))
                make.top.equalTo(self.detailLabel!.snp.bottom).offset(WH(2))
            })
            view.font = t24.font
            view.textColor = RGBColor(0x9F9F9F)
            return view
        }()
        
        orderButton = { [weak self] in
            let btn = UIButton(type: .system)
            self!.contentView.addSubview(btn)
            btn.setTitle("查看订单", for: .normal)
            btn.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(13))
            btn.layer.borderColor = RGBColor(0xFF2D5C).cgColor
            btn.layer.borderWidth = 0.5
            btn.layer.cornerRadius = 3
            btn.clipsToBounds = true
            btn.bk_addEventHandler({ (btn) in
                if self!.checkOrderInfo != nil {
                    self!.checkOrderInfo!()
                }
            }, for: .touchUpInside)
            btn.snp.makeConstraints({ (make) in
                make.right.equalTo(self!.contentView.snp.right).offset(WH(-17))
                make.top.equalTo(self!.detailLabel!.snp.bottom).offset(WH(12))
                make.height.equalTo(WH(30))
                make.width.equalTo(WH(70))
            })
            return btn
        }()
        
        self.footView = {
            let view = UIView.init()
            view .backgroundColor = RGBColor(0xf5f5f5)
            contentView.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.right.equalTo(contentView)
                make.left.equalTo(contentView)
                make.bottom.equalTo(contentView)
                make.height.equalTo(10)
            })
            return view
        }()
        
        self.lineView = {
            let view = UIView.init()
            view .backgroundColor = bg7
            contentView.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.right.equalTo(contentView)
                make.left.equalTo(contentView).offset(WH(15))
                make.bottom.equalTo(self.footView!.snp.top)
                make.height.equalTo(0.5)
            })
            return view
        }()
        
        // 底部分隔线
//        let v = UIView()
//        v.backgroundColor = bg7
//        self.addSubview(v)
//        v.snp.makeConstraints({ (make) in
//            make.right.equalTo(self)
//            make.left.equalTo(self).offset(WH(15))
//            make.bottom.equalTo(self.footView!.snp.top)
//            make.height.equalTo(0.5)
//        })
    }
    func configCell(_ model:DelayRebateInfoModel,_ isLast:Bool){
        if model.rebate_time != nil && model.rebate_time!.isEmpty == false{
            self.orderButton!.isHidden = true
            self.tipLabel!.isHidden = false
            self.detailLabel!.text = dateChangeFormat(model.rebate_time!)
            self.tipLabel!.text =  "(" + model.remark! + ")"//String(format:"(%.2f)",model.remark!)
            
        }else{
            self.orderButton!.isHidden = false
            self.tipLabel!.isHidden = true
            self.detailLabel!.text = "订单确认后展示具体到账时间"
        }
        if isLast{
            self.footView!.isHidden = true
            self.lineView!.snp.remakeConstraints({ (make) in
                make.right.equalTo(contentView)
                make.left.equalTo(contentView).offset(WH(15))
                make.bottom.equalTo(contentView.snp.bottom)
                make.height.equalTo(0.5)
            })
        }else{
            self.footView!.isHidden = false
            self.lineView!.snp.remakeConstraints({ (make) in
                make.right.equalTo(contentView)
                make.left.equalTo(contentView).offset(WH(15))
                make.bottom.equalTo(self.footView!.snp.top)
                make.height.equalTo(0.5)
            })
        }
    }
    func dateChangeFormat(_ timeStr:String)->(String){
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date = formatter.date(from: timeStr)
        let chineseFormatter = DateFormatter()
        chineseFormatter.dateFormat = "yyyy年MM月dd日 HH时mm分ss秒"
        return chineseFormatter.string(from: date!)
    }
}
