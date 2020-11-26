//
//  FKYFreightRuleView.swift
//  FKY
//
//  Created by 路海涛 on 2017/4/27.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

import UIKit

class FKYFreightRuleView: UIView, UITableViewDelegate, UITableViewDataSource {
    //
    @objc static let GloubView = FKYFreightRuleView()

    fileprivate var content : UITableView?
    fileprivate var topName : FKYFreightLabel?
    fileprivate var closeBtn : UIButton?

    fileprivate var model: FKYAlertRuleModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = RGBAColor(0x000000, alpha: 0.2)
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(FKYFreightRuleView.hide))
        self.addGestureRecognizer(tap)
//        self.model = FKYAlertRuleModel()
//        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupView(_ model:FKYAlertRuleModel) -> () {
        let height = 80 + 65 + (model.rules.count * 52)

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
            view.register(UITableViewCell.self, forCellReuseIdentifier: "FreightAlertCell")
            view.delegate = self
            view.dataSource = self
            view.tableHeaderView = self.topName
            view.tableFooterView = self.closeBtn
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

    @objc func config(_ name:String, rules:[String]) -> () {
        if rules.count <= 0 {
            return
        }
        self.hide()
        self.model = nil
        self.model = FKYAlertRuleModel()
        self.model?.initWithDic(name, rules: rules)
        self.setupView(self.model!);
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (model?.rules.count)!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FreightAlertCell")
        cell?.textLabel?.text = model?.rules[indexPath.row]
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell?.textLabel?.numberOfLines = 2;
        return cell!
    }
}

class FKYFreightLabel: UILabel{
    override func draw(_ rect: CGRect) {
        //let insets: UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        //super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        let rec = rect.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        super.drawText(in: rec)
    }
}
