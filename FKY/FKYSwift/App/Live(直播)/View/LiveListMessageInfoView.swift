//
//  LiveListMessageInfoView.swift
//  FKY
//
//  Created by yyc on 2020/8/18.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

//列表的宽短
let MESSAGE_LIST_W = SCREEN_WIDTH - WH(129) - WH(14)
//列表的高度
let MESSAGE_TAB_H = WH(168)
//欢迎视图宽度
let WELCOM_VIEW_W = WH(169)
let WELCOM_VIEW_H = WH(26)

let NICK_NAME_COLORS = [RGBColor(0xFFFA74),RGBColor(0x7FFFF7),RGBColor(0xFFB580)]

//MARK:消息列表视图及欢迎新进观众提示
class LiveListMessageInfoView: UIView {
    //新观众
    fileprivate lazy var welcomNameLabel : UILabel = {
        let label = UILabel.init()
        label.textColor = RGBColor(0xffffff)
        label.font = UIFont.boldSystemFont(ofSize: WH(12))
        label.textAlignment = .center
        label.layer.cornerRadius = WH(4)
        label.layer.masksToBounds = true
        label.backgroundColor = RGBColor(0xFF9347)
//        label.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0xF3AD40), to: RGBColor(0xEB6408), withWidth: Float(WELCOM_VIEW_W))
        return label
    }()
    fileprivate lazy var bgView : UIView = {
        let view = UIView()
        view.layer.mask = self.overlayLayer
        return view
    }()
    
    fileprivate lazy var messageInfoTableView: UITableView = { [weak self] in
        let tableV = UITableView(frame: CGRect.null, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.backgroundColor = UIColor.clear
        tableV.showsVerticalScrollIndicator = false
        tableV.estimatedRowHeight = WH(500)
        tableV.rowHeight = UITableView.automaticDimension // 设置高度自适应
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.bounces = false
        tableV.transform = CGAffineTransform(scaleX: 1, y: -1);
        tableV.register(LiveMessageTableViewCell.self, forCellReuseIdentifier: "LiveMessageTableViewCell")
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
        }()
    
    //蒙版
    fileprivate lazy var overlayLayer: CAGradientLayer = {
        let bgLayer1 = CAGradientLayer()
        bgLayer1.bounds = CGRect(x: 0, y: 0, width: MESSAGE_LIST_W, height: MESSAGE_TAB_H)
        bgLayer1.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor, UIColor(red: 195/255.0, green: 197/255.0, blue: 203/255.0, alpha: 1.0).cgColor]
        bgLayer1.locations = [0,0.25]
        bgLayer1.startPoint = CGPoint(x: 0, y: 0)
        bgLayer1.endPoint = CGPoint(x: 0, y: 1)
        bgLayer1.anchorPoint = CGPoint.zero
        return bgLayer1
    }()
    //数据
    var messageListArr = [LiveMessageMode]() //消息列表
    var tipListArr = [LiveMessageMode]() //需要提示弹框的消息
    fileprivate var timer: Timer!
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = UIColor.clear
        self.addSubview(welcomNameLabel)
        welcomNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self.snp.left).offset(-WH(14)-MESSAGE_LIST_W+WH(14))
            make.height.equalTo(WH(0))
            make.width.lessThanOrEqualTo(MESSAGE_LIST_W+WH(14))
        }
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.right.equalTo(self)
            make.top.equalTo(welcomNameLabel.snp.bottom)
            make.left.equalTo(self.snp.left).offset(WH(14))
            make.height.equalTo(MESSAGE_TAB_H)
        }
        bgView.addSubview(messageInfoTableView)
        messageInfoTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(bgView)
        }
    }
    
    func configListMessageViewInfo(_ typeIndex:Int,_ messageModelArr:[LiveMessageMode]) {
        // typeIndex==2 ,进群消息 1收到别人发的消息，3自己发送的消息
        if typeIndex == 2 {
            //头部弹框提示
            self.tipListArr.append(contentsOf: messageModelArr)
            // 启动timer...<1.s后启动>
            if timer == nil {
                let date = NSDate.init(timeIntervalSinceNow: 1.0)
                timer = Timer.init(fireAt: date as Date, interval: 2, target: self, selector: #selector(beginTipMessageCycle), userInfo: nil, repeats: true)
                RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
            }
        }else {
            //群消息提示
            //设置消息昵称的颜色
            let model = messageModelArr[0]
            if model.dealnickName != "系统消息" {
                let index = messageListArr.count % 3
                if index < NICK_NAME_COLORS.count {
                    model.nickNameColor = NICK_NAME_COLORS[index]
                }
            }
            messageListArr.insert(model, at: 0)
            if messageInfoTableView.contentOffset.y > 10 {
                messageInfoTableView.reloadData()
                messageInfoTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }else {
                messageInfoTableView.beginUpdates()
                messageInfoTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
                messageInfoTableView.endUpdates()
            }
        }
    }
}
extension LiveListMessageInfoView {
    //重置延期隐藏welcomNameLabel
    fileprivate func resetWelcomNameLayout(){
        let deadline = DispatchTime.now() + 1
        DispatchQueue.global().asyncAfter(deadline: deadline) {
            DispatchQueue.main.async {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                UIView.animate(withDuration: 0.3, animations: {
                    strongSelf.welcomNameLabel.alpha = 0.4
                }) { (_) in
                    strongSelf.welcomNameLabel.isHidden = true
                    
                }
            }
        }
        if self.tipListArr.count > 0 {
            self.tipListArr.remove(at: 0)
        }
    }
    func showTipMessage() {
        if self.tipListArr.count > 0 , let messageModel = self.tipListArr.first {
            //初始化label的状态
            self.welcomNameLabel.snp.updateConstraints({(make) in
                make.left.equalTo(self.snp.left).offset(-WH(14)-MESSAGE_LIST_W+WH(14))
                make.height.equalTo(WELCOM_VIEW_H)
            })
            self.welcomNameLabel.alpha = 1.0
            welcomNameLabel.isHidden = false
            welcomNameLabel.text = "  欢迎 \(messageModel.dealnickName)进入直播间！ "
            self.layoutIfNeeded()
            //设置动画
            UIView.animate(withDuration: 0.3, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.welcomNameLabel.snp.updateConstraints({[weak self] (make) in
                    guard let strongSelf = self else {
                        return
                    }
                    make.left.equalTo(strongSelf.snp.left).offset(WH(14))
                })
                strongSelf.layoutIfNeeded()
                }, completion: {[weak self] (_) in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.resetWelcomNameLayout()
            })
        }
    }
    @objc func beginTipMessageCycle() {
        self.welcomNameLabel.isHidden = true
        self.showTipMessage()
        //根据判断views所属的控制器被销毁了，销毁定时器
        guard (self.getFirstViewController()) != nil else{
            self.stopTimer()
            return
        }
    }
    
    func stopTimer()  {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
}
//MARK: UITableViewDelegate,UITableViewDataSource代理
extension LiveListMessageInfoView:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LiveMessageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LiveMessageTableViewCell", for: indexPath) as! LiveMessageTableViewCell
        cell.configMessageTabelCellData(messageListArr[indexPath.row])
        return cell
    }
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //            CATransaction.begin()
    //            CATransaction.setDisableActions(true)
    //            self.overlayLayer.position = CGPoint(x: 0, y: scrollView.contentOffset.y)
    //            CATransaction.commit()
    //  }
}

//MARK:消息cell
class LiveMessageTableViewCell: UITableViewCell {
    //MARK:ui
    //背景图
    fileprivate lazy var bgView : UIView = {
        let view = UIView()
        view.backgroundColor = RGBAColor(0x000000, alpha: 0.3977)
        view.layer.cornerRadius = WH(4)
        view.layer.masksToBounds = true
        return view
    }()
    //内容
    fileprivate lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = RGBColor(0xCFE2FF)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.transform = CGAffineTransform(scaleX: 1, y: -1);
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints({ (make) in
            make.left.bottom.equalTo(contentView)
            make.width.lessThanOrEqualTo(MESSAGE_LIST_W)
            make.top.equalTo(contentView.snp.top).offset(WH(3))
        })
        
        bgView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(bgView.snp.left).offset(WH(7))
            make.right.equalTo(bgView.snp.right).offset(-WH(7))
            make.top.equalTo(bgView.snp.top).offset(WH(7))
            make.bottom.equalTo(bgView.snp.bottom).offset(-WH(7))
        })
    }
}
extension LiveMessageTableViewCell {
    func configMessageTabelCellData(_ messageModel:LiveMessageMode) {
        let allContent = "\(messageModel.dealnickName) \(messageModel.messageStr)"
        let nickRange = (allContent as NSString).range(of: "\(messageModel.dealnickName)")
        let msgRange = (allContent as NSString).range(of: messageModel.messageStr)
        let attribute: NSMutableAttributedString = NSMutableAttributedString.init(string: allContent)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: messageModel.nickNameColor, range: nickRange)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: RGBColor(0xFFFFFF), range: msgRange)
        contentLabel.attributedText = attribute
    }
}

