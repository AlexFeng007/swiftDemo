//
//  QualiticationSwitchCCell.swift
//  FKY
//
//  Created by Rabe on 23/03/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  修改企业是否批发零售一体ccell

class QualiticationSwitchCCell: UICollectionViewCell {
    typealias AllInOneCallback = (Bool)->(Void)
    // MARK: - properties
    var callback: AllInOneCallback?
    
    // 标题
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x343434)
        label.font = UIFont.systemFont(ofSize: WH(15))
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
        return label
    }()
    
    // 切换swich
    fileprivate lazy var switchItem: UISwitch = {
        let s = UISwitch()
        s.isOn = false
        s.onTintColor = RGBColor(0xff394e)
        s.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        return s
    }()
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - delegates
extension QualiticationSwitchCCell {
    
}

// MARK: - public
extension QualiticationSwitchCCell {
    func configCell(withTitle title: String, isSwitchOn: Bool) {
        titleLabel.text = title
        switchItem.isOn = isSwitchOn
    }
}

// MARK: - data
extension QualiticationSwitchCCell {
    
}

// MARK: - ui
extension QualiticationSwitchCCell {
    func setupView() {
        backgroundColor = bg1
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(switchItem)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(18))
            make.centerY.equalTo(contentView.snp.centerY).offset(WH(-5))
        }
        
        switchItem.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(WH(-16))
            make.centerY.equalTo(contentView).offset(WH(-5))
        }
        
        let margin = UIView()
        margin.backgroundColor = RGBColor(0xf5f5f5)
        contentView.addSubview(margin)
        margin.snp.makeConstraints { (make) in
            make.height.equalTo(WH(10))
            make.left.right.bottom.equalTo(contentView)
        }
    }
}

// MARK: - private methods
extension QualiticationSwitchCCell {
    @objc func switchValueChanged() {
        callback!(switchItem.isOn)
    }
}

