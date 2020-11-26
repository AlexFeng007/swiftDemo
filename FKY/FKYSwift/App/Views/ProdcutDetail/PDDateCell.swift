//
//  PDDateCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/6/19.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  商详之基本信息cell...<包括生产厂家、批准文号、大包装、剂型、有效期至、生产日期>

import UIKit

let viewHeight = WH(25)

class PDDateCell: UITableViewCell {
    //MARK: - Property
    
    // closure
    @objc var showDetailBlock: (()->())? // 查看说明
    
    // 顶部分隔线
    fileprivate lazy var viewLine: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    /************************************************/
    
    // 第一行容器视图
    fileprivate lazy var viewFactory: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // 生产厂家
    fileprivate lazy var lblTitleFactory: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.text = "生产厂家"
        lbl.textAlignment = .left
        lbl.textColor = RGBColor(0x333333)
        if #available(iOS 8.2, *) {
            lbl.font = UIFont.systemFont(ofSize: WH(13), weight: UIFont.Weight.medium)
        }
        else {
            lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        }
        return lbl
    }()
    fileprivate lazy var lblFactory: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.text = ""
        lbl.textAlignment = .left
        lbl.textColor = RGBColor(0x666666)
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    /************************************************/
    
    // 第二行容器视图
    fileprivate lazy var viewNumber: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // 批准文号
    fileprivate lazy var lblTitleNumber: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.text = "批准文号"
        lbl.textAlignment = .left
        lbl.textColor = RGBColor(0x333333)
        if #available(iOS 8.2, *) {
            lbl.font = UIFont.systemFont(ofSize: WH(13), weight: UIFont.Weight.medium)
        }
        else {
            lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        }
        return lbl
    }()
    fileprivate lazy var lblNumber: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.text = ""
        lbl.textAlignment = .left
        lbl.textColor = RGBColor(0x666666)
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        return lbl
    }()
    
    /************************************************/
    
    // 第三行容器视图
    fileprivate lazy var viewPackage: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // 大包装
    fileprivate lazy var bigPackageTitle: UILabel = {
        let  lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textAlignment = .left
        lbl.text = "大包装"
        lbl.textColor = RGBColor(0x333333)
        if #available(iOS 8.2, *) {
            lbl.font = UIFont.systemFont(ofSize: WH(13), weight: UIFont.Weight.medium)
        }
        else {
            lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        }
        return lbl
    }()
    fileprivate lazy var bigPackage: UILabel = {
        let  lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        
        lbl.textAlignment = .left
        lbl.textColor = RGBColor(0x666666)
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        return lbl
    }()
    
    // 剂型
    fileprivate lazy var drugformTypeTitle: UILabel = {
        let  lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textAlignment = .left
        lbl.text = "剂型"
        lbl.textColor = RGBColor(0x333333)
        if #available(iOS 8.2, *) {
            lbl.font = UIFont.systemFont(ofSize: WH(13), weight: UIFont.Weight.medium)
        }
        else {
            lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        }
        return lbl
    }()
    fileprivate lazy var drugformType: UILabel = {
        let  lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textAlignment = .left
        lbl.textColor = RGBColor(0x666666)
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        return lbl
    }()
    
    /************************************************/
    
    // 第4行容器视图
    fileprivate lazy var viewDate: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // 有效期至
    fileprivate lazy var lblTitleDeadLine: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.text = "有效期至"
        lbl.textAlignment = .left
        lbl.textColor = RGBColor(0x333333)
        if #available(iOS 8.2, *) {
            lbl.font = UIFont.systemFont(ofSize: WH(13), weight: UIFont.Weight.medium)
        }
        else {
            lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        }
        return lbl
    }()
    fileprivate lazy var lblDeadLine: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.text = ""
        lbl.textAlignment = .left
        lbl.textColor = RGBColor(0x666666)
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        return lbl
    }()
    //    // i按钮
    //    fileprivate lazy var btnTip: UIButton = {
    //        let btn = UIButton.init(type: UIButton.ButtonType.custom)
    //        btn.backgroundColor = .clear
    //        btn.setImage(UIImage.init(named: "img_checkorder_fright"), for: .normal)
    //        btn.bk_addEventHandler({ [weak self] (btn) in
    //            guard let strongSelf = self else {
    //                return
    //            }
    //            if let closure = strongSelf.showDetailBlock {
    //                closure()
    //            }
    //            }, for: UIControl.Event.touchUpInside)
    //        return btn
    //    }()
    
    // 近效期(标签)
    fileprivate lazy var nearIcon: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(10))
        label.textAlignment = .center
        label.layer.cornerRadius = WH(2)
        label.layer.masksToBounds = true
        label.textColor = RGBColor(0xFF2D5C)
        label.backgroundColor = UIColor.white
        label.layer.borderWidth = 0.5
        label.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        label.text = "近效期"
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.showDetailBlock {
                closure()
            }
        }).disposed(by: disposeBag)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    // 生产日期
    fileprivate lazy var lblTitleDate: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.text = "生产日期"
        lbl.textAlignment = .left
        lbl.textColor = RGBColor(0x333333)
        if #available(iOS 8.2, *) {
            lbl.font = UIFont.systemFont(ofSize: WH(13), weight: UIFont.Weight.medium)
        }
        else {
            lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        }
        return lbl
    }()
    fileprivate lazy var lblDate: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.text = ""
        lbl.textAlignment = .left
        lbl.textColor = RGBColor(0x666666)
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        return lbl
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
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = RGBColor(0xFFFFFF)
        contentView.backgroundColor = RGBColor(0xFFFFFF)
        
        // 分隔线
        contentView.addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView).offset(WH(10))
            make.right.equalTo(contentView).offset(-WH(10))
            make.height.equalTo(0.5)
        }
        
        // 各容器视图
        contentView.addSubview(viewFactory)
        contentView.addSubview(viewNumber)
        contentView.addSubview(viewPackage)
        contentView.addSubview(viewDate)
        viewFactory.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(contentView).offset(WH(8))
            make.height.equalTo(viewHeight)
        }
        viewNumber.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(viewFactory.snp.bottom)
            make.height.equalTo(viewHeight)
        }
        viewPackage.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(viewNumber.snp.bottom)
            make.height.equalTo(viewHeight)
        }
        viewDate.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(viewPackage.snp.bottom)
            make.height.equalTo(viewHeight)
            make.bottom.equalTo(self.contentView).offset(WH(-8));
        }
        
        // 1>
        viewFactory.addSubview(lblTitleFactory)
        viewFactory.addSubview(lblFactory)
        lblTitleFactory.snp.makeConstraints { (make) in
            make.top.equalTo(self.viewFactory).offset(WH(6))
            make.left.equalTo(viewFactory).offset(WH(10))
        }
        lblFactory.snp.makeConstraints { (make) in
            //            make.centerY.equalTo(viewFactory)
            make.top.equalTo(self.viewFactory).offset(WH(6))
            make.height.equalTo(viewHeight - WH(12))
            make.left.equalTo(lblTitleFactory.snp.right).offset(WH(12))
            make.right.equalTo(viewFactory).offset(-WH(12))
        }
        // 当冲突时，lblTitleFactory不被拉伸，lblFactory可以被拉伸
        // 当前lbl抗拉伸（不想变大）约束的优先级高 UILayoutPriority
        lblTitleFactory.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        // 当前lbl抗拉伸（不想变大）约束的优先级低
        lblFactory.setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
        
        // 2>
        viewNumber.addSubview(lblTitleNumber)
        viewNumber.addSubview(lblNumber)
        lblTitleNumber.snp.makeConstraints { (make) in
            make.centerY.equalTo(viewNumber)
            make.left.equalTo(viewNumber).offset(WH(10))
        }
        lblNumber.snp.makeConstraints { (make) in
            make.centerY.equalTo(viewNumber)
            make.left.equalTo(lblTitleNumber.snp.right).offset(WH(12))
            make.right.equalTo(viewNumber).offset(-WH(12))
        }
        // 当冲突时，lblTitleNumber不被拉伸，lblNumber可以被拉伸
        // 当前lbl抗拉伸（不想变大）约束的优先级高 UILayoutPriority
        lblTitleNumber.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        // 当前lbl抗拉伸（不想变大）约束的优先级低
        lblNumber.setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
        
        // 3>
        viewPackage.addSubview(bigPackageTitle)
        viewPackage.addSubview(bigPackage)
        viewPackage.addSubview(drugformTypeTitle)
        viewPackage.addSubview(drugformType)
        bigPackageTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(viewPackage)
            make.left.equalTo(viewPackage).offset(WH(10))
        }
        bigPackage.snp.makeConstraints { (make) in
            make.centerY.equalTo(viewPackage)
            make.left.equalTo(bigPackageTitle.snp.right).offset(WH(12))
            make.right.lessThanOrEqualTo(viewPackage.snp.centerX).offset(WH(10))
        }
        // 当冲突时，bigPackageTitle不被拉伸，bigPackage可以被拉伸
        // 当前lbl抗拉伸（不想变大）约束的优先级高 UILayoutPriority
        bigPackageTitle.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        // 当前lbl抗拉伸（不想变大）约束的优先级低
        bigPackage.setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
        
        drugformTypeTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(viewPackage)
            //make.left.equalTo(viewPackage.snp.centerX).offset(WH(22))
            make.left.equalTo(viewPackage).offset(SCREEN_WIDTH / 2 + WH(22))
        }
        drugformType.snp.makeConstraints { (make) in
            make.centerY.equalTo(viewPackage)
            make.left.equalTo(drugformTypeTitle.snp.right).offset(WH(12))
            make.right.equalTo(viewPackage).offset(-WH(12))
        }
        // 当冲突时，drugformTypeTitle不被拉伸，drugformType可以被拉伸
        // 当前lbl抗拉伸（不想变大）约束的优先级高 UILayoutPriority
        drugformTypeTitle.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        // 当前lbl抗拉伸（不想变大）约束的优先级低
        drugformType.setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
        
        // 4>
        viewDate.addSubview(lblTitleDeadLine)
        viewDate.addSubview(lblDeadLine)
        viewDate.addSubview(nearIcon)
        viewDate.addSubview(lblTitleDate)
        viewDate.addSubview(lblDate)
        lblTitleDeadLine.snp.makeConstraints { (make) in
            make.centerY.equalTo(viewDate)
            make.left.equalTo(viewDate).offset(WH(10))
        }
        lblDeadLine.snp.makeConstraints { (make) in
            make.centerY.equalTo(viewDate)
            make.left.equalTo(lblTitleDeadLine.snp.right).offset(WH(12))
            make.right.lessThanOrEqualTo(viewDate.snp.centerX).offset(-WH(5))
        }
        nearIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(lblDeadLine)
            make.left.equalTo(lblDeadLine.snp.right).offset(WH(4))
            make.width.equalTo(WH(36))
            make.height.equalTo(WH(16))
        }
        nearIcon.isHidden = true // 默认隐藏
        // 当冲突时，lblTitleDeadLine不被拉伸，lblDeadLine可以被拉伸
        // 当前lbl抗拉伸（不想变大）约束的优先级高 UILayoutPriority
        lblTitleDeadLine.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        // 当前lbl抗拉伸（不想变大）约束的优先级低
        lblDeadLine.setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
        
        lblTitleDate.snp.makeConstraints { (make) in
            make.centerY.equalTo(viewDate)
            //make.left.equalTo(viewDate.snp.centerX).offset(WH(22))
            make.left.equalTo(viewDate).offset(SCREEN_WIDTH / 2 + WH(22))
        }
        lblDate.snp.makeConstraints { (make) in
            make.centerY.equalTo(viewDate)
            make.left.equalTo(lblTitleDate.snp.right).offset(WH(12))
            make.right.equalTo(viewDate).offset(-WH(12))
        }
        // 当冲突时，lblTitleDate不被拉伸，lblDate可以被拉伸
        // 当前lbl抗拉伸（不想变大）约束的优先级高 UILayoutPriority
        lblTitleDate.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        // 当前lbl抗拉伸（不想变大）约束的优先级低
        lblDate.setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: .horizontal)
    }
    
    
    // MARK: - Public
    
    @objc func configCell(_ model: FKYProductObject?) {
        guard let model = model else {
            // 隐藏
            contentView.isHidden = true
            return
        }
        
        // 显示
        contentView.isHidden = false
        setValueAndLayout(model)
    }
    
    
    // MARK: - Private
    
    fileprivate func setValueAndLayout(_ model: FKYProductObject) {
        // 分隔线
        if FKYProductDetailManage.showBaseInfoCell(model) {
            // 显示
            contentView.isHidden = false
        }
        else {
            // 不显示
            contentView.isHidden = true
            return
        }
        
        // 1>
        if let txt = model.factoryName, txt.isEmpty == false {
            // 有值
            lblFactory.text = txt
            //            lblFactory.text = "上海汇仁医药有限公司上海汇仁医药有限公司上海汇仁医药有限公司上海汇仁医药有限公司上海汇仁医药有限公司上海汇仁医药有限公司上海汇仁医药有限公司"
            let contentSize = txt.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(86), height: WH(35)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(13))], context: nil).size
            let height = (contentSize.height > WH(13) ? contentSize.height : WH(13)) + WH(12)
            viewFactory.isHidden = false
            viewFactory.snp.updateConstraints { (make) in
                make.height.equalTo(height)
            }
            lblFactory.snp.updateConstraints { (make) in
                make.height.equalTo(height - WH(12) + 0.5)
            }
        }
        else {
            // 无值
            lblFactory.text = nil
            viewFactory.isHidden = true
            viewFactory.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
        }
        
        // 2>
        if let txt = model.approvalNum, txt.isEmpty == false {
            // 有值
            lblNumber.text = txt
            viewNumber.isHidden = false
            viewNumber.snp.updateConstraints { (make) in
                make.height.equalTo(viewHeight)
            }
        }
        else {
            // 无值
            lblNumber.text = nil
            viewNumber.isHidden = true
            viewNumber.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
        }
        
        // 3>
        var flagLeft = false
        var flagRight = false
        if let txt = model.bigPackageText(), txt.isEmpty == false {
            // 有值
            flagLeft = true
            bigPackage.text = txt
            bigPackage.isHidden = false
            bigPackageTitle.isHidden = false
        }
        else {
            // 无值
            flagLeft = false
            bigPackage.text = nil
            bigPackage.isHidden = true
            bigPackageTitle.isHidden = true
        }
        if let txt = model.drugFormType, txt.isEmpty == false {
            // 有值
            flagRight = true
            drugformType.text = txt
            drugformType.isHidden = false
            drugformTypeTitle.isHidden = false
        }
        else {
            // 无值
            flagRight = false
            drugformType.text = nil
            drugformType.isHidden = true
            drugformTypeTitle.isHidden = true
        }
        if flagLeft == true, flagRight == true {
            // 均有值
            viewPackage.isHidden = false
            viewPackage.snp.updateConstraints { (make) in
                make.height.equalTo(viewHeight)
            }
            drugformTypeTitle.snp.updateConstraints { (make) in
                make.left.equalTo(viewPackage).offset(SCREEN_WIDTH / 2 + WH(22))
            }
        }
        else if flagLeft == true, flagRight == false {
            // 左有，右无
            viewPackage.isHidden = false
            viewPackage.snp.updateConstraints { (make) in
                make.height.equalTo(viewHeight)
            }
            drugformTypeTitle.snp.updateConstraints { (make) in
                make.left.equalTo(viewPackage).offset(SCREEN_WIDTH / 2 + WH(22))
            }
        }
        else if flagLeft == false, flagRight == true {
            // 左无，右有
            viewPackage.isHidden = false
            viewPackage.snp.updateConstraints { (make) in
                make.height.equalTo(viewHeight)
            }
            drugformTypeTitle.snp.updateConstraints { (make) in
                make.left.equalTo(viewPackage).offset(WH(10))
            }
        }
        else {
            // 左右均无
            viewPackage.isHidden = true
            viewPackage.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            drugformTypeTitle.snp.updateConstraints { (make) in
                make.left.equalTo(viewPackage).offset(SCREEN_WIDTH / 2 + WH(22))
            }
        }
        
        // 4>
        flagLeft = false
        flagRight = false
        if let txt = model.deadline, txt.isEmpty == false {
            // 有值
            flagLeft = true
            lblDeadLine.text = txt
            lblDeadLine.isHidden = false
            lblTitleDeadLine.isHidden = false
            if model.nearExpiration == 1 {
                // 自营
                nearIcon.isHidden = false
            }
            else {
                // 非自营
                nearIcon.isHidden = true
            }
        }
        else {
            // 无值
            flagLeft = false
            lblDeadLine.text = nil
            lblDeadLine.isHidden = true
            lblTitleDeadLine.isHidden = true
            nearIcon.isHidden = true
        }
        if let txt = model.producedTime, txt.isEmpty == false {
            // 有值
            flagRight = true
            lblDate.text = txt
            lblDate.isHidden = false
            lblTitleDate.isHidden = false
        }
        else {
            // 无值
            flagRight = false
            lblDate.text = nil
            lblDate.isHidden = true
            lblTitleDate.isHidden = true
        }
        if flagLeft == true, flagRight == true {
            // 均有值
            viewDate.isHidden = false
            viewDate.snp.updateConstraints { (make) in
                make.height.equalTo(viewHeight)
            }
            lblTitleDate.snp.updateConstraints { (make) in
                make.left.equalTo(viewDate).offset(SCREEN_WIDTH / 2 + WH(22))
            }
        }
        else if flagLeft == true, flagRight == false {
            // 左有，右无
            viewDate.isHidden = false
            viewDate.snp.updateConstraints { (make) in
                make.height.equalTo(viewHeight)
            }
            lblTitleDate.snp.updateConstraints { (make) in
                make.left.equalTo(viewDate).offset(SCREEN_WIDTH / 2 + WH(22))
            }
        }
        else if flagLeft == false, flagRight == true {
            // 左无，右有
            viewDate.isHidden = false
            viewDate.snp.updateConstraints { (make) in
                make.height.equalTo(viewHeight)
            }
            lblTitleDate.snp.updateConstraints { (make) in
                make.left.equalTo(viewDate).offset(WH(10))
            }
        }
        else {
            // 左右均无
            viewDate.isHidden = true
            viewDate.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            lblTitleDate.snp.updateConstraints { (make) in
                make.left.equalTo(viewDate).offset(SCREEN_WIDTH / 2 + WH(22))
            }
        }
        
        layoutIfNeeded()
    }
}
