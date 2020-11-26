//
//  FKYNewFreightRuleView.swift
//  FKY
//
//  Created by 寒山 on 2018/5/4.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import Foundation
import UIKit

class FKYNewFreightRuleView: UIView,
    UITableViewDelegate,
UITableViewDataSource{
    
    static let GloubView = FKYNewFreightRuleView()
    
    fileprivate var content : UITableView?
    fileprivate var topName : FKYFreightLabel?
    fileprivate var closeBtn : UIButton?
    
    fileprivate var model: FKYNewAlertRuleModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = RGBAColor(0x000000, alpha: 0.2)
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(FKYNewFreightRuleView.hide))
        self.addGestureRecognizer(tap)
        //        self.model = FKYAlertRuleModel()
        //        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView(_ model:FKYNewAlertRuleModel) -> () {
        
        let height = 80 + 65 + ( (model.rules?.count)! * 52)
        
        topName = {
            let view = FKYFreightLabel()
            view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 80)
            view.numberOfLines = 2
            view.fontTuple = t42
            view.text = model.name
            return view
        }()
        
        closeBtn = {
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 65)
            btn.setTitle("关闭", for: UIControl.State())
            btn.setTitleColor(RGBColor(0x8f8e94), for: UIControl.State())
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.hide()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            
            let view = UIView()
            view.backgroundColor = RGBColor(0xeeeeee)
            btn.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.top.equalTo(btn.snp.top).offset(0)
                make.left.equalTo(btn.snp.left).offset(10)
                make.right.equalTo(btn.snp.right).offset(-10)
                make.height.width.equalTo(1)
            })
            return btn
        }()
        
        content = {
            let view = UITableView()
            view.backgroundColor = bg1
            view.register(FKYFreightRuleCell.self, forCellReuseIdentifier: "FreightAlertCell")
            view.delegate = self
            view.dataSource = self
            view.tableHeaderView = self.topName
            view.tableFooterView = self.closeBtn
            view.separatorStyle = UITableViewCell.SeparatorStyle.none
            view.estimatedRowHeight = 44.0
            view.rowHeight = UITableView.automaticDimension
            self.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.bottom.equalTo(self.snp.bottom).offset(0)
                make.left.right.equalTo(self)
                make.height.width.equalTo(height)
            })
            return view
        }()
        
        self.content?.reloadData()
    }
    
    @objc func hide() -> () {
        self.topName?.removeFromSuperview()
        self.topName = nil
        self.closeBtn?.removeFromSuperview()
        self.closeBtn = nil
        self.content?.removeFromSuperview()
        self.content = nil
        self.removeFromSuperview()
    }
    
    func config(_ name:String,rules:NSArray) -> () {
        if rules.count <= 0 {
            return
        }
        self.hide()
        self.model = nil
        self.model = FKYNewAlertRuleModel()
        self.model?.initWithDic(name, rules: rules)
        self.setupView(self.model!);
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (model?.rules!.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FKYFreightRuleCell = tableView.dequeueReusableCell(withIdentifier: "FreightAlertCell") as! FKYFreightRuleCell
        /// 配置cell
        let model : FKYFreightRulesModel = self.model?.rules![indexPath.row] as! FKYFreightRulesModel
        cell.configCell(model, index: indexPath.row)
        return cell
    }
}


