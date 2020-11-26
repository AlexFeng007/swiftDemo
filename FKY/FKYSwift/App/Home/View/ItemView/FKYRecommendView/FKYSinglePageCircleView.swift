//
//  FKYSinglePageCircleView.swift
//  FKY
//
//  Created by 夏志勇 on 2018/2/9.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  (首页)首推特价（药城精选）之单条消息上下轮播视图

import UIKit

// 轮播实现类型
enum SingleCircleType: Int {
    case transitionType = 0 // CATransition方式
    case scrollType = 1     // UICollectionView方式
}


class FKYSinglePageCircleView: UIView {
    // MARK: - Property
    
    // closure
    var tapActionCallback: ((Int, Any?)->())?   // 点击...<暂不使用>
    var updateIndexCallback: ((Int, Any?)->())? // 更新索引
    
    fileprivate lazy var viewBg: UIView! = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear//RGBColor(0xF9F9F9)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        
        return view
    }()
    
    fileprivate lazy var lblTitle: UILabel! = {
        let view = UILabel.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear
        view.textAlignment = .center
        view.textColor = RGBColor(0x333333)
        view.font = UIFont.systemFont(ofSize: WH(13))
        return view
    }()
    
    fileprivate lazy var collectionView: UICollectionView! = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        //layout.itemSize = CGSize(width: SCREEN_WIDTH, height: WH(35))
        
        let view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.delegate = self
        view.dataSource = self
        view.isPagingEnabled = true
        view.isUserInteractionEnabled = true
        view.showsVerticalScrollIndicator = false
        view.register(FKYSinglePageCircleCCell.self, forCellWithReuseIdentifier: "FKYSinglePageCircleCCell")
        return view
    }()
    
    // 轮播定时器
    fileprivate var timer: Timer!
    
    // 实现方式...<默认简便实现方式，不可手动滑动>
    var circleType: SingleCircleType = .transitionType
    
    // 自动滑动间隔时间...<默认3s>
    var autoScrollTimeInterval: TimeInterval = 3
    
    // 当前消息索引
    var currentIndex = 0

    // 消息列表
    var msgDataSource = [String]() {
        didSet {
            showMsgContent()
            autoScrollLogic()
        }
    }
    
    // ccell宽/高...<仅与scrollType相关>
    var msgWidth = SCREEN_WIDTH - j7 * 2
    var msgHeight = WH(35)
    
    // 分区section大小...<仅与scrollType相关>
    var maxSecitons = 5
    
    // 是否允许用户手动滑动...<仅与scrollType相关>
    var userCanScroll = false
    
    // 当前消息索引...<仅与scrollType相关>
    fileprivate var currentPageIndex: Int {
        get {
            var index: Int = Int( (collectionView.contentOffset.y + msgHeight * 0.5) / msgHeight )
            if msgDataSource.count > 0  {
                index = index % msgDataSource.count
            }
            return max(0, index)
        }
    }
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = UIColor.white
        clipsToBounds = true
        
        addSubview(viewBg)
        viewBg.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        // 默认显示
        addSubview(lblTitle)
        lblTitle.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        // 默认隐藏
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        collectionView.isHidden = true
    }
    
    
    // MARK: - Action
    
    // 暂无点击事件
    func setupAction() {
        // tap事件
        let tapGestureMsg = UITapGestureRecognizer()
        tapGestureMsg.rx.event.subscribe(onNext: { [weak self] _ in
            print("情报小站")
            if let closure = self?.tapActionCallback {
                if self?.circleType == .transitionType {
                    closure((self?.currentIndex)!, nil)
                }
                else {
                    closure((self?.currentPageIndex)!, nil)
                }
            }
        }).disposed(by: disposeBag)
        addGestureRecognizer(tapGestureMsg)
    }
    
    // 初始化公告栏中的样式
    func initNoticViewConfig() {
        self.viewBg.isHidden = true
        self.lblTitle.textAlignment = .left
        self.lblTitle.lineBreakMode = .byTruncatingTail
    }
    
    
    // MARK: - Private
    
    // 显示内容
    fileprivate func showMsgContent() {
        // 消息条数必须大于0
        guard msgDataSource.count > 0 else {
            lblTitle.text = nil
            collectionView.reloadData()
            return
        }
        
        // 实现方式为transitionType
        if circleType == .transitionType {
            if currentIndex >= msgDataSource.count {
                currentIndex = 0
            }
            lblTitle.text = msgDataSource[currentIndex]
            lblTitle.isHidden = false
            collectionView.isHidden = true
            return
        }
        
        // 实现方式为scrollType
        lblTitle.isHidden = true
        collectionView.isHidden = false
        collectionView.reloadData()
        collectionView.isUserInteractionEnabled = userCanScroll

        // 滑动到中间section
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.collectionView.scrollToItem(at: IndexPath.init(row: 0, section:strongSelf.maxSecitons / 2), at: .top, animated: false)
        }
    }
    
    // 轮播相关
    fileprivate func autoScrollLogic() {
        // 取消timer
        stopAutoScroll()
        
        guard msgDataSource.count > 0 else {
            return
        }
        
        // 启动timer
        beginAutoScroll()
    }
    
    // 开始轮播
    fileprivate func beginAutoScroll() {
        // 取消timer
        stopAutoScroll()
        // 启动timer
        timer = Timer.init(timeInterval: autoScrollTimeInterval, target: self, selector: #selector(autoScrollAction), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    // 停止轮播
    fileprivate func stopAutoScroll() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    // 定时器方法
    @objc fileprivate func autoScrollAction() {
        scrollKeyMethod()
        
        // scrollType
        if circleType == .scrollType {
            // 计算indexpath
            var nextPage = currentPageIndex + 1
            var nextSection = maxSecitons / 2
            if nextPage >= msgDataSource.count {
                nextPage = 0
                nextSection = nextSection + 1
                if nextSection >= maxSecitons {
                    nextSection = maxSecitons / 2
                }
            }
            // 滑动到指定索引的图片处
            collectionView.scrollToItem(at: IndexPath.init(row: nextPage, section: nextSection), at: .top, animated: true)
            return
        }
        
        // transitionType
        currentIndex = currentIndex + 1
        if currentIndex >= msgDataSource.count {
            currentIndex = 0
        }
        
        let animation = CATransition.init()
        animation.duration = 0.5
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromTop
        animation.isRemovedOnCompletion = true
        animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fillMode = CAMediaTimingFillMode.forwards
        lblTitle.layer.add(animation, forKey: "pageAnimation")
        lblTitle.text = msgDataSource[currentIndex]
        
        if let clouser = updateIndexCallback {
            clouser(currentIndex, nil)
        }
    }
    
    // 每次 (自动)滑动 or (手动)拖动 结束后均需要执行此方法
    fileprivate func scrollKeyMethod() {
        guard circleType == .scrollType, msgDataSource.count > 0 else {
            return
        }
        
        collectionView.scrollToItem(at: IndexPath.init(row: currentPageIndex, section: maxSecitons / 2), at: .top, animated: false)
        
        if let clouser = updateIndexCallback {
            clouser(currentPageIndex, nil)
        }
    }
}

// MARK: - Delegate
extension FKYSinglePageCircleView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    // MARK: - UIScrollViewDelegate
    
    // 定时器方法滑动结束后调用此方法
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollKeyMethod()
    }
    
    // 用户手动滑动结束后调用此方法
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollKeyMethod()
    }
    
    // 用户手动滑动开始
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if circleType == .scrollType, msgDataSource.count > 0 {
            stopAutoScroll()
        }
    }
    
    // 用户手动滑动结束
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if circleType == .scrollType, msgDataSource.count > 0 {
            beginAutoScroll()
        }
    }
    
    
    // MARK: - UICollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return maxSecitons
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return msgDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: msgWidth, height: msgHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYSinglePageCircleCCell", for: indexPath) as! FKYSinglePageCircleCCell
        cell.configCell(msgDataSource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let closure = bannerDetailCallback {
//            closure(indexPath.row, nil)
//        }
    }
}


/****************************************************/


// MARK: - FKYSinglePageCircleCCell
class FKYSinglePageCircleCCell: UICollectionViewCell {
    // MARK: - Property
    
    fileprivate lazy var lblTitle: UILabel! = {
        let view = UILabel.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear
        view.textAlignment = .center
        view.textColor = RGBColor(0x333333)
        view.font = UIFont.systemFont(ofSize: WH(13))
        return view
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
        
        contentView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    
    // MARK: - Public
    
    // 配置cell
    func configCell(_ msg: String?) {
        lblTitle.text = nil
        if let title = msg,  title.isEmpty == false {
            lblTitle.text = title
        }
    }
}

