//
//  FKYBillListView.swift
//  FKY
//
//  Created by hui on 2019/7/25.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

class FKYBillCell: UITableViewCell {
    //MARK: - Property
    
    fileprivate lazy var lblTitle: UILabel! = {
        let label = UILabel()
        label.textColor = RGBColor(0x333333)
        label.font = UIFont.systemFont(ofSize: WH(14))
        return label
    }()
    
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - UI
    func setupView() {
        contentView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.left.equalTo(contentView.snp.left).offset(WH(30))
            make.right.equalTo(contentView.snp.right).offset(-WH(30))
        }
        //下划线
        let bottomLine = UIView.init()
        bottomLine.backgroundColor = RGBColor(0xE5E5E5)
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(30))
            make.right.equalTo(contentView.snp.right).offset(-WH(30))
            make.bottom.equalTo(contentView.snp.bottom)
            make.height.equalTo(WH(1))
        }
    }
    
    // MARK: - Public
    func configCell(_ title:String?) {
        self.lblTitle.text = title
    }
}

class FKYBillListView: UIView {
    //ui相关
    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = bg1
        return view
    }()
    fileprivate var cancleBtn: UIButton?
    fileprivate lazy var tableView: UITableView = { [weak self] in
        let tableV = UITableView(frame: CGRect.null, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.isScrollEnabled = false
        tableV.showsVerticalScrollIndicator = false
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.register(FKYBillCell.self, forCellReuseIdentifier: "FKYBillCell")
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
        }()
    
    //属性
    @objc var dismissClourse : emptyClosure?
    @objc var dismissComplete : DismissCompleteCallBack?
    @objc var appearClourse : emptyClosure?
    
    @objc var dataSource: Array<FKYBillInfoModel> = []
    @objc var orderModel : FKYOrderModel?
    fileprivate var bgViewHeight: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        
        self.appearClourse = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.isUserInteractionEnabled = true
            strongSelf.superview?.bringSubviewToFront(strongSelf)
            UIView.animate(withDuration: 0.35, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.backgroundColor =  RGBAColor(0x000000, alpha: 0.4)
                strongSelf.bgView.frame = CGRect(x: 0, y: SCREEN_HEIGHT-strongSelf.bgViewHeight, width: SCREEN_WIDTH, height: strongSelf.bgViewHeight)
            })
        }
        
        self.dismissClourse = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.35, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.backgroundColor =  RGBAColor(0x000000, alpha: 0.0)
                strongSelf.bgView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: strongSelf.bgViewHeight)
                }, completion: {[weak self] (finished) in
                    guard let strongSelf = self else {
                        return
                    }
                    if let dismissCompleteCallBack = strongSelf.dismissComplete {
                        dismissCompleteCallBack(strongSelf)
                    }
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        self.backgroundColor =  RGBAColor(0x000000, alpha: 0.0)
        self.isUserInteractionEnabled = false
        bgViewHeight = WH(55+1) + bootSaveHeight()
        let bottomH: CGFloat = bootSaveHeight()
        bgView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: bgViewHeight)
        addSubview(bgView)
        
        cancleBtn = {
            let btn = UIButton()
            bgView.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.left.equalTo(bgView).offset(WH(12))
                make.top.equalTo(bgView).offset(WH(5.5))
                make.width.height.equalTo(WH(44))
            })
            btn.setImage(UIImage.init(named:"btn_pd_group_close"), for: UIControl.State())
            _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                if strongSelf.dismissClourse != nil {
                    strongSelf.dismissClourse!()
                }
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            return btn
        }()
        
        let titleL = UILabel()
        titleL.text = "查看电子发票"
        titleL.font = UIFont.systemFont(ofSize: 17.0)
        titleL.textColor = RGBColor(0x000000)
        bgView.addSubview(titleL)
        titleL.snp.makeConstraints({ (make) in
            make.centerY.equalTo(cancleBtn!)
            make.centerX.equalTo(bgView)
        })
        //标题下划线
        let centerLine = UIView()
        bgView.addSubview(centerLine)
        centerLine.snp.makeConstraints({ (make) in
            make.left.right.equalTo(bgView)
            make.top.equalTo(bgView.snp.top).offset(WH(55))
            make.height.equalTo(WH(1))
        })
        
        bgView.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) in
            make.top.equalTo(centerLine.snp.bottom)
            make.left.right.equalTo(bgView)
            make.bottom.equalTo(bgView.snp.bottom).offset(-bottomH)
        })
    }
    
    //刷新视图
    @objc func updateView(_ list: Array<FKYBillInfoModel>,_ model:FKYOrderModel) {
        if list.count > 0 {
            self.orderModel = model
            dataSource = list
            bgViewHeight = CGFloat(dataSource.count)*WH(45) + WH(55+1) + bootSaveHeight()
            if bgViewHeight > WH(420){
                bgViewHeight = WH(420)
            }
            tableView.reloadData()
            bgView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: bgViewHeight)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if (touch.view == self && self.dismissClourse != nil) {
                self.dismissClourse!()
            }
        }
    }
}
extension FKYBillListView: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return WH(45)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FKYBillCell = tableView.dequeueReusableCell(withIdentifier: "FKYBillCell", for: indexPath) as! FKYBillCell
        let model = dataSource[indexPath.row]
        cell.configCell(model.invoiceName)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = self.orderModel {
            let dic = dataSource[indexPath.row]
            FKYNavigator.shared().openScheme(FKY_Web.self, setProperty: { (vc) in
                let v = vc as! GLWebVC
                v.urlPath = dic.filePath
                v.barStyle = .barStyleWhite
                v.isLookInvocie = 1
                v.orderId = model.orderId
                v.orderTotalNum =  String.init(format: "¥%.2f", model.orderTotal.floatValue)
                v.fromFuson = true
            })
        }
    }
}
