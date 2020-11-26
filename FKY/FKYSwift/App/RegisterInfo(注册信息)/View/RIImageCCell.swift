//
//  RIImageCCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/8/8.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  [资料管理]图片上传界面之资质图片ccell

import UIKit

class RIImageCCell: UICollectionViewCell {
    // MARK: - Property
    
    // 上传图片block
    var uploadImageClosure: ( (IndexPath)->() )?
    // 查看图片block
    var showImageClosure: ( (IndexPath)->() )?
    // 删除图片block
    var deleteImageClosure: ( (IndexPath)->() )?
    
    // 当前资质图片类型
    var typeid: Int?
    
    // 默认为第0个tab
    fileprivate var section: Int = 0
    //
    fileprivate var row: Int = 0
    
    // 图片url
    fileprivate var imgUrl: String?
    // 背景视图
    fileprivate lazy var viewBg: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(8)
        return view
    }()
    
    // 圆角虚线边框视图
    fileprivate lazy var viewBorder: UIView = {
        let width = ((SCREEN_WIDTH - WH(10)) / 2) - WH(22)
        let height = WH(120) - WH(22)
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        view.backgroundColor = .clear
        return view
    }()
    
    // 上传btn
    fileprivate lazy var btnUpload: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setImage(UIImage.init(named: "image_doc_camera"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: WH(15), right: 0)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            print("上传图片")
            if let block = strongSelf.uploadImageClosure {
                block(IndexPath.init(row: strongSelf.row, section: strongSelf.section))
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 选中图片
    fileprivate lazy var imgviewPic: UIImageView = {
        let imgview = UIImageView()
        //imgview.contentMode = .scaleAspectFit
        imgview.contentMode = .scaleAspectFill
        imgview.image = UIImage.init(named: "image_default_img")
        imgview.isUserInteractionEnabled = true
        imgview.layer.masksToBounds = true
        imgview.layer.cornerRadius = WH(8)
        return imgview
    }()
    
    // 过期图片文描和图片水印
    
    fileprivate lazy var expiredPic: UIImageView = {
        let imgview = UIImageView()
        //imgview.contentMode = .scaleAspectFit
        imgview.contentMode = .scaleAspectFill
        imgview.image = UIImage.init(named: "riimage_bg_icon")
        //imgview.isUserInteractionEnabled = true
        imgview.layer.masksToBounds = true
        imgview.layer.cornerRadius = WH(8)
        return imgview
    }()
    
    fileprivate lazy var expiredLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = RGBColor(0xFFFFFF)
        label.font = UIFont.boldSystemFont(ofSize: WH(12))
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    fileprivate lazy var expiredDescLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF2859)
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    
    
    // 透明渐变背景视图
    fileprivate lazy var viewMask: UIView = {
        //let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: (SCREEN_WIDTH - WH(10)) / 2 - WH(20), height: WH(75)))
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        
        //        // 切部分圆角
        //        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [UIRectCorner.bottomRight, UIRectCorner.bottomLeft], cornerRadii: CGSize(width: WH(8), height: WH(8)))
        //        let maskLayer = CAShapeLayer()
        //        maskLayer.frame = view.bounds
        //        maskLayer.path = maskPath.cgPath
        //        view.layer.mask = maskLayer
        ////        FKYTogeterNowTabCell.cornerView(byRoundingCorners: [.bottomLeft , .bottomRight], radii: WH(8), view)
        
        //        // layer
        //        let gradientLayer: CAGradientLayer = CAGradientLayer()
        //        gradientLayer.frame = view.bounds
        //        // 渲染的起始位置
        //        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        //        // 渲染的终止位置
        //        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        //        // 渐变色数组
        //        gradientLayer.colors = [RGBColor(0x000000).withAlphaComponent(0.0).cgColor, RGBColor(0x000000).withAlphaComponent(0.25).cgColor,  RGBColor(0x000000).withAlphaComponent(0.6).cgColor]
        //        // 渐变分界点
        //        //gradientLayer.locations = [NSNumber(value: 0.2)]
        //        view.layer.insertSublayer(gradientLayer, at: 0)
        
        return view
    }()
    
    // 资质名称
    fileprivate lazy var lblName: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(11))
        lbl.textColor = RGBColor(0x666666)
        lbl.textAlignment = .center
        lbl.text = "*统一社会信用代码"
        lbl.numberOfLines = 3
        lbl.minimumScaleFactor = 0.8
        lbl.adjustsFontSizeToFitWidth = true
        lbl.isUserInteractionEnabled = false
        return lbl
    }()
    
    // 删除btn
    fileprivate lazy var btnDelete: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setImage(UIImage.init(named: "image_doc_delete"), for: .normal)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            print("删除图片")
            if let block = strongSelf.deleteImageClosure {
                block(IndexPath.init(row: strongSelf.row, section: strongSelf.section))
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //print("RIImageCCell layoutSubviews")
    }
    
    
    // MARK: - UI
    
    fileprivate func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = RGBColor(0xFFFFFF)
        
        contentView.addSubview(viewBg)
        contentView.addSubview(btnDelete)
        contentView.addSubview(expiredDescLabel)
        viewBg.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: WH(10), left: WH(10), bottom: WH(32), right: WH(10)))
        }
        btnDelete.snp.makeConstraints { (make) in
            make.top.right.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: WH(30), height: WH(30)))
        }
        
        expiredDescLabel.snp.makeConstraints { (make) in
            make.right.equalTo(viewBg.snp.right)
            make.left.equalTo(viewBg.snp.left)
            make.top.equalTo(viewBg.snp.bottom).offset(WH(4))
        }
        
        // 先加边框layer
        drawCircleDotBorderLine(viewBorder)
        
        viewBg.addSubview(viewBorder)
        viewBg.addSubview(btnUpload)
        viewBg.addSubview(imgviewPic)
        viewBg.addSubview(viewMask)
        viewBg.addSubview(lblName)
        viewBg.addSubview(expiredPic)
        expiredPic.addSubview(expiredLabel)
        
        
        viewBorder.snp.makeConstraints { (make) in
            make.edges.equalTo(viewBg)
        }
        btnUpload.snp.makeConstraints { (make) in
            make.edges.equalTo(viewBg)
        }
        imgviewPic.snp.makeConstraints { (make) in
            make.edges.equalTo(viewBg).inset(UIEdgeInsets.zero)
        }
        lblName.snp.makeConstraints { (make) in
            make.bottom.equalTo(viewBg).offset(-WH(10))
            make.left.greaterThanOrEqualTo(viewBg).offset(WH(5))
            make.right.lessThanOrEqualTo(viewBg).offset(-WH(5))
            make.centerX.equalTo(viewBg)
            make.height.lessThanOrEqualTo(WH(45))
            make.height.greaterThanOrEqualTo(WH(15))
        }
        viewMask.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(viewBg)
            //make.height.equalTo(WH(65))
            //make.height.equalTo(lblName.snp.height).offset(WH(20))
            make.top.equalTo(lblName.snp.top).offset(-WH(20))
        }
        
        expiredPic.snp.makeConstraints { (make) in
            make.center.equalTo(viewBg)
            make.width.height.equalTo(WH(50))
        }
        
        expiredLabel.snp.makeConstraints { (make) in
            make.center.equalTo(expiredPic)
        }
        // 给背景视图绘制圆角虚线边框
        //drawCircleDotBorderLine(viewBg)
        
        // 默认资质图片隐藏，图片蒙板视图隐藏，上传按钮显示
        imgviewPic.isHidden = true
        viewMask.isHidden = true
        btnUpload.isHidden = false
        expiredPic.isHidden = true
    }
    
    
    // MARK: - Action
    
    //
    fileprivate func setupAction() {
        // 点击图片可查看大图
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            print("查看图片")
            guard let block = strongSelf.showImageClosure else {
                return
            }
            // 回调
            block(IndexPath.init(row: strongSelf.row, section: strongSelf.section))
        }).disposed(by: disposeBag)
        imgviewPic.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: - Public
    
    // 配置cell
    func configCell(_ model: RIQualificationItemModel, _ section: Int, _ row: Int) {
        // 保存
        self.section = section
        self.row = row
        self.typeid = model.qualificationTypeId
        
        guard model.showFlag else {
            // 不显示
            contentView.isHidden = true
            return
        }
        
        // 显示
        contentView.isHidden = false
        
        // 默认未上传图片
        var hasImage = false
        imgUrl = nil
        if let imgurl = model.imgUrlQualifiction, imgurl.isEmpty == false {
            // 有图片
            hasImage = true
            // 显示图片
            imgviewPic.sd_setImage(with: URL(string: imgurl), placeholderImage: UIImage(named: "image_placeholder"))
            imgUrl = imgurl
        }
        setShowStatus(hasImage)
        setTitleStatus(model.qualificationName, (model.required ?? true), hasImage)
        
        if let expiredRemark = model.expiredRemark,expiredRemark.isEmpty == false,hasImage == true,model.updateFlag == false{
            expiredPic.isHidden = false
            expiredDescLabel.isHidden = false
            expiredLabel.text = model.expiredType
            expiredDescLabel.text = expiredRemark
            
        }else{
            expiredDescLabel.isHidden = true
            expiredPic.isHidden = true
        }
        // 动态设置透明渐变图层的高度
        lblName.layoutIfNeeded()
        viewMask.layoutIfNeeded()
        self.layoutIfNeeded()
        let gradientLayer: CAGradientLayer = getGradientLayer(viewMask.bounds.size.width, viewMask.bounds.size.height)
        viewMask.layer.sublayers = [gradientLayer]
    }
    
    //
    func getQualificationImage() -> (UIView, UIImage?, String?) {
        return (imgviewPic, imgviewPic.image, imgUrl)
    }
    
    
    // MARK: - Private
    
    // 生成透明渐变视图
    fileprivate func getGradientLayer(_ width: CGFloat, _ height: CGFloat) -> CAGradientLayer {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect.init(x: 0, y: 0, width: width, height: height)
        // 渲染的起始位置
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        // 渲染的终止位置
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        // 渐变色数组
        gradientLayer.colors = [RGBColor(0x000000).withAlphaComponent(0.0).cgColor, RGBColor(0x000000).withAlphaComponent(0.25).cgColor,  RGBColor(0x000000).withAlphaComponent(0.7).cgColor]
        //gradientLayer.colors = [RGBColor(0x000000).withAlphaComponent(0.0).cgColor,  RGBColor(0x000000).withAlphaComponent(0.6).cgColor]
        // 渐变分界点
        //gradientLayer.locations = [NSNumber(value: 0.2)]
        return gradientLayer
    }
    
    // 给view增加圆角虚线边框
    fileprivate func drawCircleDotBorderLine(_ view: UIView) {
        // 关键代码
        view.layoutIfNeeded()
        
        // 绘制
        let border = CAShapeLayer()
        border.frame = view.bounds
        border.lineWidth = 1
        border.lineCap = CAShapeLayerLineCap(rawValue: "square")
        border.lineDashPattern = [6, 4]
        border.strokeColor = RGBColor(0x979797).withAlphaComponent(0.4).cgColor
        border.fillColor = UIColor.clear.cgColor
        border.path = UIBezierPath.init(roundedRect: view.bounds, cornerRadius: WH(8)).cgPath
        view.layer.addSublayer(border)
    }
    
    // 设置各子视图的显示/隐藏状态
    fileprivate func setShowStatus(_ hasImage: Bool) {
        if hasImage {
            // 有上传图片
            btnDelete.isHidden = false
            imgviewPic.isHidden = false
            viewMask.isHidden = false
            btnUpload.isHidden = true
        }
        else {
            // 无上传图片
            btnDelete.isHidden = true
            imgviewPic.isHidden = true
            viewMask.isHidden = true
            btnUpload.isHidden = false
        }
    }
    
    // 设置标题内容
    fileprivate func setTitleStatus(_ title: String?, _ mustUpload: Bool, _ hasImage: Bool) {
        guard let content = title, content.isEmpty == false else {
            lblName.text = nil
            lblName.attributedText = nil
            return
        }
        
        // 文字颜色
        var titleColor = RGBColor(0x666666)
        if hasImage {
            // 有图片
            titleColor = RGBColor(0xFFFFFF)
        }
        
        // label行间距
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = -2
        
        if mustUpload {
            // 必填
            let title = "*" + content
            lblName.text = title
            // 富文本
            let attributedStr = NSMutableAttributedString(string: title)
            attributedStr.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: WH(11)), range: NSMakeRange(0, title.count))
            attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: titleColor, range: NSMakeRange(0, title.count))
            attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: RGBColor(0xFC2C5A), range: NSMakeRange(0, 1))
            attributedStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, title.count))
            lblName.attributedText = attributedStr
        }
        else {
            // 非必填
            lblName.text = content
            // 富文本
            let attributedStr = NSMutableAttributedString(string: content)
            attributedStr.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: WH(11)), range: NSMakeRange(0, content.count))
            attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: titleColor, range: NSMakeRange(0, content.count))
            attributedStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, content.count))
            lblName.attributedText = attributedStr
        }
    }
}
