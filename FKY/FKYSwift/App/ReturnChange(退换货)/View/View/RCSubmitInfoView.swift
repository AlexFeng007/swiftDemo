//
//  RCSubmitInfoView.swift
//  FKY
//
//  Created by 夏志勇 on 2018/11/27.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  退换货提交界面之内容(输入)视图

import UIKit

// MARK: - 总的内容视图
class RCSubmitInfoView: UIView {
    // MARK: - Property
    
    // closure
    var saveInput: ((String?)->())? // 保存文字
    var deletePic: ((Int)->())?     // 删除图片
    var showPic: ((Int)->())?       // 查看图片
    var takePic: (()->())?          // 拍照
    
    // 上传图片数组
    var picList = [String]()
    // 默认最大可上传数量为5
    var maxPicNumber: Int = 5
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.text = "问题描述"
        return lbl
    }()
    
    // 拍照按钮
    fileprivate lazy var btnCamera: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setImage(UIImage.init(named: "img_rc_camera"), for: .normal)
        // 拍照
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.takePic else {
                return
            }
            block()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 提示
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(10))
        lbl.textColor = RGBColor(0x999999)
        lbl.textAlignment = .left
        lbl.text = "上传纸箱的折痕或破损或淋湿照片，商品破损的照片，快递单号的照片，最多5张图片哦～"
        lbl.numberOfLines = 2
        return lbl
    }()
    
    // 内容视图
    fileprivate lazy var viewContent: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - WH(28), height: WH(196)))
        view.backgroundColor = RGBColor(0xF6F6F6)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(2)
        
        view.addSubview(self.viewInput)
        view.addSubview(self.viewPic)
        self.viewInput.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(WH(130))
        }
        self.viewPic.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(self.viewInput.snp.bottom)
            make.height.equalTo(WH(66))
        }
        
        return view
    }()
    
    // 文字输入视图
    fileprivate lazy var viewInput: RCSubmitInputView = {
        let view = RCSubmitInputView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - WH(28), height: WH(130)))
        // 保存文字
        view.saveClosure = { [weak self] (content) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.saveInput else {
                return
            }
            block(content)
        }
        return view
    }()
    
    // 上传图片视图
    fileprivate lazy var viewPic: RCSubmitPicView = {
        let view = RCSubmitPicView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - WH(28), height: WH(66)))
         view.picList = self.picList
        // 删除图片
        view.deleteClosure = { [weak self] (index) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.deletePic else {
                return
            }
            block(index)
        }
        // 查看大图
        view.showClosure = { [weak self] (index) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.showPic else {
                return
            }
            block(index)
        }
        return view
    }()
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .clear
    
        addSubview(lblTitle)
        addSubview(btnCamera)
        addSubview(lblTip)
        addSubview(viewContent)
        
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(15))
            make.top.equalTo(self).offset(WH(15))
        }
        
        btnCamera.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(10))
            make.bottom.equalTo(self).offset(-WH(10))
            make.size.equalTo(CGSize.init(width: WH(50), height: WH(40)))
        }
        
        lblTip.snp.makeConstraints { (make) in
            make.left.equalTo(btnCamera.snp.right).offset(WH(2))
            make.right.equalTo(self).offset(-WH(10))
            make.centerY.equalTo(btnCamera)
        }
        
        viewContent.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(17))
            make.right.equalTo(self).offset(-WH(11))
            make.top.equalTo(self).offset(WH(40))
            make.bottom.equalTo(self).offset(-WH(58))
        }
    }
    
    
    // MARK: - Public
    
    func configView(_ txt: String?, _ list: [String]?) {
        picList.removeAll()

        viewInput.configView(txt)
        viewPic.configView(list)
        
        // total: 40 + 58 + 130
        // total: 40 + 58 + (130 + 66)
        if let list = list, list.count > 0 {
            // 有图片
            viewPic.isHidden = false
            picList.append(contentsOf: list)
        }
        else {
            // 无图片
            viewPic.isHidden = true
        }
    }
    
    func updatePicList(_ list: [String]?) {
        picList.removeAll()
        guard let list = list, list.count > 0 else {
            // 无图片
            viewPic.isHidden = true
            viewPic.configView(picList)
            return
        }
        // 有图片
        viewPic.isHidden = false
        picList.append(contentsOf: list)
        viewPic.configView(picList)
    }
    
    // 更新标题和描述...<买家投诉>
    func setupForBuyerComplain() {
        lblTip.text = "上传纸箱的折痕或破损或淋湿照片，商品破损的照片，快递单号的照片，最多1张图片哦～"
        viewInput.lblTip.text = "请您详细描述需要反馈的问题，便于更快解决"
        // 最大输入字数
        viewInput.lblCount.text = "0/300"
        viewInput.maxInputStringNum = 300
    }
    
    // 更新标题和描述...<售后工单之随行单据>
    func setupTextContent() {
        lblTitle.text = "请填写详细描述"
        lblTip.text = "上传图片"
        viewInput.lblTip.text = "请描述申请售后服务的具体原因"
    }
    
    // 若超过5张，则不显示上传图片按钮
    func updateCameraBtnShowStatus(_ showFlag: Bool) {
        if showFlag {
            // 显示
            btnCamera.isHidden = false
            lblTip.isHidden = false
            viewContent.snp.updateConstraints { (make) in
                make.bottom.equalTo(self).offset(-WH(58))
            }
        }
        else {
            // 隐藏
            btnCamera.isHidden = true
            lblTip.isHidden = true
            viewContent.snp.updateConstraints { (make) in
                make.bottom.equalTo(self).offset(-WH(8))
            }
        }
        layoutIfNeeded()
    }
}


// MARK: - 文字输入视图
class RCSubmitInputView: UIView, UITextViewDelegate {
    // MARK: - Property
    
    // closure
    var saveClosure: ((String?)->())? // 输入完成
    
    // 最大输入字数...<默认200>
    var maxInputStringNum: Int = 200
    
    // 提示
    var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0x999999)
        lbl.textAlignment = .left
        lbl.text = "请描述申请售后服务的具体原因"
        return lbl
    }()
    
    // 字数统计
    var lblCount: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0x999999)
        lbl.textAlignment = .right
        lbl.text = "0/200"
        return lbl
    }()
    
    // 输入
    fileprivate lazy var txtview: UITextView = {
        let view = UITextView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - WH(28), height: WH(100)))
        view.delegate = self
        view.backgroundColor = .clear
        view.textAlignment = .left
        view.keyboardType = .default
        view.returnKeyType = .done
        view.font = UIFont.systemFont(ofSize: WH(12))
        view.textColor = RGBColor(0x333333)
        //view.textContainerInset = UIEdgeInsetsMake(5, 0 , 0, 0)
        //view.layoutManager.allowsNonContiguousLayout = false
        return view
    }()
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    fileprivate func setupView() {
        backgroundColor = .clear
        addSubview(lblTip)
        addSubview(lblCount)
        addSubview(txtview)
        
        lblTip.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(8))
            make.top.equalTo(self).offset(WH(7))
        }
        
        lblCount.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-WH(10))
            make.bottom.equalTo(self).offset(-WH(8))
        }
        
        txtview.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(WH(5))
            make.right.equalTo(self).offset(-WH(2))
            //make.bottom.equalTo(self).offset(-WH(30))
            make.bottom.equalTo(self)
        }
    }
    
    
    // MARK: - Data
    
    fileprivate func setupData() {
        maxInputStringNum = 200
        lblCount.text = "0/\(maxInputStringNum)"
    }
    
    
    // MARK: - Public
    
    func configView(_ txt: String?) {
        if let content = txt, content.isEmpty == false {
            txtview.text = txt
            lblTip.isHidden = true
        }
        else {
            txtview.text = nil
            lblTip.isHidden = false
        }
    }
    
    
    // MARK: - UITextViewDelegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        lblTip.isHidden = true
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let txt = textView.text, txt.count > 0 {
            lblTip.isHidden = true
        }
        else {
            lblTip.isHidden = false
        }
        
        guard let block = saveClosure else {
            return
        }
        guard let text = textView.text, text.isEmpty == false else {
            block(nil)
            return
        }
        
        // 去掉前后空格和空行
        let txt = text.trimmingCharacters(in: .whitespacesAndNewlines)
        textView.text = txt
        // 保存
        block(textView.text)
    }
    
    // 禁止换行
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // emoji
        guard let inputMode = textView.textInputMode, let language = inputMode.primaryLanguage, language.isEmpty == false else {
            return false
        }
        if language == "emoji" {
            // 禁止输入emoji
            return false
        }
        
        // 判断键盘是不是九宫格键盘...<解决禁止输入emoji时导致九宫格键盘无法输入的问题>
//        if NSString.isNineKeyBoard(text) {
//            //return true
//        }
//        else {
//            // 禁止输入表情符
//            if NSString.stringContainsEmoji(text) || NSString.hasEmoji(text) {
//                return false
//            }
//        }

        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    // 字数限制&统计
    func textViewDidChange(_ textView: UITextView) {
        // 有未选中的字符
        if let selectedRange = textView.markedTextRange, let newText = textView.text(in: selectedRange), newText.isEmpty == false {
            return
        }
        
        // 过滤表情符
        if NSString.stringContainsEmoji(textView.text) || NSString.hasEmoji(textView.text) {
            textView.text = NSString.disableEmoji(textView.text)
        }
        
        if let content = textView.text, content.isEmpty == false {
            // 有输入
            //lblTip.isHidden = true
            lblCount.text = String(content.count) + "/\(maxInputStringNum)"
            // 最多200字
            if content.count > maxInputStringNum {
                textView.text = content.substring(to: content.index(content.startIndex, offsetBy: maxInputStringNum))
                lblCount.text = "\(maxInputStringNum)/\(maxInputStringNum)"
                FKYAppDelegate!.showToast("最多只可输入\(maxInputStringNum)字")
            }
        }
        else {
            // 无输入
            //lblTip.isHidden = false
            lblCount.text = "0/\(maxInputStringNum)"
        }
    }
}


// MARK: - 图片输入视图
class RCSubmitPicView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - Property
    
    // closure
    var deleteClosure: ((Int)->())? // 删除
    var showClosure: ((Int)->())?   // 查看
    
    // 上传图片数组
    var picList = [String]()
    
    // 图片视图
    fileprivate lazy var collectionView: UICollectionView! = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.backgroundColor = UIColor.clear
        view.delegate = self
        view.dataSource = self
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.register(RCSubmitPicCCell.self, forCellWithReuseIdentifier: "RCSubmitPicCCell")
        return view
    }()
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .clear
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: WH(0), left: WH(0), bottom: WH(0), right: WH(0)))
        }
        
        // 分隔线
        let viewLine = UIView()
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(WH(10))
            make.right.equalTo(self).offset(-WH(10))
            make.height.equalTo(0.5)
        }
    }
    
    
    // MARK: - Public
    
    func configView(_ list: [String]?) {
        picList.removeAll()
        guard let list = list, list.count > 0 else {
            collectionView.reloadData()
            return
        }
        picList.append(contentsOf: list)
        collectionView.reloadData()
    }
    
    
    // MARK: - UICollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 最多显示5个
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (picList.count > 5) ? 5 : picList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:WH(60), height:WH(60))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(0), left: WH(0), bottom: WH(0), right: WH(0))
    }
    
    // 左右间隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return WH(5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return WH(15)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RCSubmitPicCCell", for: indexPath) as! RCSubmitPicCCell
        cell.configCell(picList[indexPath.row])
        // 删除
        cell.deleteClosure = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.deleteClosure else {
                return
            }
            block(indexPath.row)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 点击查看
        print("didSelectItemAt")
        guard let block = showClosure else {
            return
        }
        block(indexPath.row)
    }
}

// MARK: - 图片输入视图之图片ccell
class RCSubmitPicCCell: UICollectionViewCell {
    // MARK: - Property
    
    // closure
    var deleteClosure: (()->())? // 删除
    
    // 商品图片
    fileprivate lazy var imgviewPic: UIImageView! = {
        let imgview = UIImageView.init(frame: CGRect.zero)
        imgview.contentMode = .scaleToFill
        return imgview
    }()
    
    //  删除按钮
    fileprivate lazy var btnDelete: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setImage(UIImage.init(named: "img_rc_delete"), for: .normal)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.deleteClosure else {
                return
            }
            block()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = UIColor.clear
        
        contentView.addSubview(imgviewPic)
        contentView.addSubview(btnDelete)
        
        imgviewPic.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: WH(8), left: WH(8), bottom: WH(8), right: WH(8)))
        }
        
        btnDelete.snp.makeConstraints { (make) in
            make.top.right.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: WH(26), height: WH(26)))
        }
        
        imgviewPic.isHidden = true
        btnDelete.isHidden = true
    }
    
    
    // MARK: - Public
    
    // 配置cell
    func configCell(_ imgurl: String?) {
        guard let url = imgurl, url.isEmpty == false else {
            imgviewPic.image = nil
            imgviewPic.isHidden = true
            btnDelete.isHidden = true
            return
        }
        
        imgviewPic.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "image_default_img"))
        imgviewPic.isHidden = false
        btnDelete.isHidden = false
    }
}
