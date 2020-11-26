//
//  CredentialsAllInOneCCell.swift
//  FKY
//
//  Created by Rabe on 23/03/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  企业是否批发零售一体ccell

class CredentialsAllInOneCCell: UICollectionViewCell {
    typealias AllInOneCallback = (Bool)->(Void)
    // MARK: - properties
    
    var callback: AllInOneCallback?
    
    // 必填标记
    fileprivate lazy var starLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF394E)
        label.font = UIFont.systemFont(ofSize: WH(15))
        label.textAlignment = .center
        label.text = "*"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    // 标题
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x343434)
        label.font = UIFont.systemFont(ofSize: WH(16))
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
        return label
    }()
    
    // 内容
    fileprivate lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xCCCCCC)
        label.font = UIFont.systemFont(ofSize: WH(16))
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
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
extension CredentialsAllInOneCCell {
    
}

// MARK: - public
extension CredentialsAllInOneCCell {
    func configCell(withTitle title: String, content: String, isSwitchOn: Bool) {
        titleLabel.text = title
        contentLabel.text = content
        switchItem.isOn = isSwitchOn
    }
}

// MARK: - data
extension CredentialsAllInOneCCell {
    
}

// MARK: - ui
extension CredentialsAllInOneCCell {
    func setupView() {
        backgroundColor = bg1
        
        self.contentView.addSubview(starLabel)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(switchItem)
        
        starLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(15))
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(WH(8))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(starLabel.snp.right)
            make.bottom.equalTo(contentView.snp.centerY).offset(WH(-5))
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(contentView.snp.centerY).offset(WH(5))
        }
        
        switchItem.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(WH(-16))
            make.centerY.equalTo(contentView)
        }
        
        let viewBottomLine = UIView()
        viewBottomLine.backgroundColor = RGBColor(0xEEEEEE)
        contentView.addSubview(viewBottomLine)
        viewBottomLine.snp.makeConstraints({ (make) in
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom).offset(0)
            make.height.equalTo(0.5)
            make.leading.equalTo(contentView.snp.leading).offset(16)
        })
    }
}

// MARK: - private methods
extension CredentialsAllInOneCCell {
    @objc func switchValueChanged() {
        callback!(switchItem.isOn)
    }
}
