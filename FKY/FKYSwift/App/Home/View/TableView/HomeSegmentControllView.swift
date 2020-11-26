//
//  HomeSegmentControllView.swift
//  FKY
//
//  Created by 寒山 on 2019/7/3.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit


class HomeSegmentControllView: UIView {
    var indexChangeBlock :((_ index:Int)->())? //选择Index
    static var DefaltColor =  RGBAColor(0x333333,alpha: 1.0)
    static var SelectColor =  RGBAColor(0x000000,alpha: 1.0)
    
    static var DefaltFonSize =  UIFont.systemFont(ofSize: WH(16))
    static var SelectFonSize =  UIFont.boldSystemFont(ofSize: WH(20))
    var sectionTitles = [String]()
    var titleLabelList = [UILabel]()
    var titleSizelList = [CGFloat]()
    var currectIndex = 0
    var currectLabel:UILabel?
    
    
    // 底部线条
    public lazy var gradientLayer: CAGradientLayer = {
        let bgLayer1 = CAGradientLayer()
        bgLayer1.colors = [UIColor(red: 1, green: 0.3, blue: 0.45, alpha: 1).cgColor, UIColor(red: 1, green: 0.44, blue: 0.56, alpha: 1).cgColor]
        bgLayer1.locations = [0, 1]
       // bgLayer1.frame = layerView.bounds
        bgLayer1.startPoint = CGPoint(x: 0.14, y: 0.5)
        bgLayer1.endPoint = CGPoint(x: 0.5, y: 0.5)
        return bgLayer1
    }()
    
    public lazy var bottommLineView: UIView = {
        let view = UIView()
       // view.backgroundColor = UIColor.clear
        view.isHidden = true
        view.layer.shadowColor = UIColor(red: 1, green: 0.18, blue: 0.36, alpha:0.3).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 8
        return view
    }()
    
    //第一个titleLabel
    public lazy var firstLabel: UILabel = {
        let label = UILabel()
        label.font = HomeSegmentControllView.DefaltFonSize
        //label.textAlignment = .center
        label.textColor = HomeSegmentControllView.DefaltColor
        label.isHidden = true
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.indexChangeBlock else {
                return
            }
            strongSelf.setSelectedSegmentIndex(0)
            block(strongSelf.currectIndex)
        }).disposed(by: disposeBag)
        label.addGestureRecognizer(tapGesture)
        
        return label
    }()
    
    public lazy var secondLabel: UILabel = {
        let label = UILabel()
        label.font = HomeSegmentControllView.DefaltFonSize
       // label.textAlignment = .center
        label.textColor = HomeSegmentControllView.DefaltColor
        label.isHidden = true
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.indexChangeBlock else {
                return
            }
            strongSelf.setSelectedSegmentIndex(1)
            block(strongSelf.currectIndex)
        }).disposed(by: disposeBag)
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    public lazy var thirdLabel: UILabel = {
        let label = UILabel()
        label.font = HomeSegmentControllView.DefaltFonSize
       // label.textAlignment = .center
        label.textColor = HomeSegmentControllView.DefaltColor
        label.isHidden = true
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.indexChangeBlock else {
                return
            }
            strongSelf.setSelectedSegmentIndex(2)
            block(strongSelf.currectIndex)
        }).disposed(by: disposeBag)
        label.addGestureRecognizer(tapGesture)
        
        return label
    }()
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = bg1
        self.addSubview(bottommLineView)
        self.addSubview(firstLabel)
        self.addSubview(secondLabel)
        self.addSubview(thirdLabel)
        firstLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        secondLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        thirdLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        bottommLineView.snp.makeConstraints { (make) in
            make.centerX.equalTo(firstLabel.snp.centerX)
            make.height.equalTo(WH(6))
            make.left.equalTo(firstLabel.snp.left).offset(WH(-3))
            make.right.equalTo(firstLabel.snp.right).offset(WH(3))
            make.top.equalTo(firstLabel.snp.bottom).offset(WH(-3))
        }
        // gradientLayer.frame = CGRect(x: 0, y: 0, width: 84, height: 6)
         bottommLineView.layer.addSublayer(gradientLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func setsectionTitles(_ titles:[String]){
        self.sectionTitles = titles
        self.titleLabelList.removeAll()
        if self.sectionTitles.count == 1{
            firstLabel.isHidden = false
            secondLabel.isHidden = true
            thirdLabel.isHidden = true
            bottommLineView.isHidden = false
            firstLabel.text = self.sectionTitles[0]
            //self.currectIndex = 0
            
            firstLabel.snp.remakeConstraints { (make) in
                make.center.equalTo(self)
            }
            self.titleLabelList.append(firstLabel)
            bottommLineView.snp.remakeConstraints { (make) in
                make.centerX.equalTo(firstLabel.snp.centerX)
                make.height.equalTo(WH(6))
                make.left.equalTo(firstLabel.snp.left).offset(WH(-3))
                make.right.equalTo(firstLabel.snp.right).offset(WH(3))
                make.top.equalTo(firstLabel.snp.bottom).offset(WH(-6))
            }
            self.scrollToCurectIndex(self.currectIndex)
        }else if self.sectionTitles.count == 2{
            firstLabel.isHidden = false
            secondLabel.isHidden = false
            thirdLabel.isHidden = true
            bottommLineView.isHidden = false
            firstLabel.text = self.sectionTitles[0]
            secondLabel.text = self.sectionTitles[1]
            //self.currectIndex = 0
            
            firstLabel.snp.remakeConstraints { (make) in
                make.centerY.equalTo(self)
                make.right.equalTo(self.snp.centerX).offset(WH(-25))
            }
            
            secondLabel.snp.remakeConstraints { (make) in
                make.centerY.equalTo(self)
                make.left.equalTo(self.snp.centerX).offset(WH(25))
            }
            self.titleLabelList.append(firstLabel)
            self.titleLabelList.append(secondLabel)
            bottommLineView.snp.remakeConstraints { (make) in
                make.centerX.equalTo(firstLabel.snp.centerX)
                make.height.equalTo(WH(6))
                make.left.equalTo(firstLabel.snp.left).offset(WH(-3))
                make.right.equalTo(firstLabel.snp.right).offset(WH(3))
                make.top.equalTo(firstLabel.snp.bottom).offset(WH(-6))
            }
            self.scrollToCurectIndex(self.currectIndex)
        }else if self.sectionTitles.count == 3{
            firstLabel.isHidden = false
            secondLabel.isHidden = false
            thirdLabel.isHidden = false
            bottommLineView.isHidden = false
            firstLabel.text = self.sectionTitles[0]
            secondLabel.text = self.sectionTitles[1]
            thirdLabel.text = self.sectionTitles[2]
            //self.currectIndex = 0
            
            secondLabel.snp.remakeConstraints { (make) in
                make.center.equalTo(self)
            }
            
            firstLabel.snp.remakeConstraints { (make) in
                make.centerY.equalTo(self)
                make.right.equalTo(secondLabel.snp.left).offset(WH(-25))
            }
           
            thirdLabel.snp.remakeConstraints { (make) in
                make.centerY.equalTo(self)
                make.left.equalTo(secondLabel.snp.right).offset(WH(25))
            }
            self.titleLabelList.append(firstLabel)
            self.titleLabelList.append(secondLabel)
            self.titleLabelList.append(thirdLabel)
            
            bottommLineView.snp.remakeConstraints { (make) in
                make.centerX.equalTo(firstLabel.snp.centerX)
                make.height.equalTo(WH(6))
                make.left.equalTo(firstLabel.snp.left).offset(WH(-3))
                make.right.equalTo(firstLabel.snp.right).offset(WH(3))
                make.top.equalTo(firstLabel.snp.bottom).offset(WH(-6))
            }
            self.scrollToCurectIndex(self.currectIndex)
        }else{
            firstLabel.isHidden = true
            secondLabel.isHidden = true
            thirdLabel.isHidden = true
            bottommLineView.isHidden = true
        }
    }
    
    func scrollToCurectIndex(_ currectindex:Int){
        self.titleSizelList.removeAll()
        for index in 0..<self.titleLabelList.count{
            let titleStr = self.sectionTitles[index]
            if index == self.currectIndex{
                let width = COProductItemCell.calculateStringWidth(titleStr, HomeSegmentControllView.SelectFonSize, WH(100))
                self.titleSizelList.append(width)
                gradientLayer.frame = CGRect(x: 0, y: 0, width:width + WH(6), height: 6)
            }else{
                 let width = COProductItemCell.calculateStringWidth(titleStr, HomeSegmentControllView.DefaltFonSize, WH(100))
                 self.titleSizelList.append(width)
            }
        }
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            for index in 0..<strongSelf.titleLabelList.count{
                let titleLabel = strongSelf.titleLabelList[index]
                if index == currectindex{
                    titleLabel.font = HomeSegmentControllView.SelectFonSize
                    titleLabel.textColor = HomeSegmentControllView.SelectColor
                    strongSelf.bottommLineView.snp.remakeConstraints { (make) in
                        make.centerX.equalTo(titleLabel.snp.centerX)
                        make.height.equalTo(WH(6))
                        make.left.equalTo(titleLabel.snp.left).offset(WH(-3))
                        make.right.equalTo(titleLabel.snp.right).offset(WH(3))
                        make.top.equalTo(titleLabel.snp.bottom).offset(WH(-6))
                    }
                }else{
                    titleLabel.font = HomeSegmentControllView.DefaltFonSize
                    titleLabel.textColor = HomeSegmentControllView.DefaltColor
                }
            }
        })
    }
    func  setSelectedSegmentIndex(_ index:Int){
        if index < self.sectionTitles.count{
            self.currectIndex = index
            self.scrollToCurectIndex(self.currectIndex)
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
