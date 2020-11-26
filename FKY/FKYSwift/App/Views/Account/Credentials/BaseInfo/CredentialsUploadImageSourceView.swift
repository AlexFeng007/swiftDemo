//
//  CredentialsUploadImageSourceView.swift
//  FKY
//
//  Created by yangyouyong on 2016/10/31.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  上传图片之弹出框...<相机/相册选择>

import UIKit
import SnapKit
import RxSwift

class CredentialsUploadImageSourceView: UIView {
    
    fileprivate var bgView: UIView?
    fileprivate var CameraBtn: UIButton?
    fileprivate var AlbumBtn: UIButton?
    fileprivate var CancelBtn: UIButton?
    fileprivate var separatorView: UIView?
    fileprivate var separatorLine: UIView?
    var showClosure: emptyClosure?
    var dismissClosure: emptyClosure?
    var selectSourceClosure: SingleStringClosure? //"Album" "Camera"
    fileprivate var selectedSource: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
        self.showClosure = {[weak self] in
            guard let strongSelf = self else {
                return
            }
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.backgroundColor = RGBAColor(0x0, alpha: 0.5)
                strongSelf.bgView!.center = CGPoint(x: SCREEN_WIDTH / 2.0, y: SCREEN_HEIGHT / 2.0)
                },completion: {[weak self](complete) in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.selectedSource = "None"
            })
        }
        self.dismissClosure = {[weak self] in
            guard let strongSelf = self else {
                return
            }
            UIView.animate(withDuration: 0.35, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.backgroundColor = RGBAColor(0x0, alpha: 0.0)
                strongSelf.bgView!.center = CGPoint(x: SCREEN_WIDTH / 2.0, y: (3 * SCREEN_HEIGHT) / 2.0)
                }, completion: {[weak self] (complete) in
                    guard let strongSelf = self else {
                        return
                    }
                    if let _ = strongSelf.selectedSource,
                        let _ = strongSelf.selectSourceClosure {
                        strongSelf.selectSourceClosure!(strongSelf.selectedSource!)
                    }
                    if let superView = strongSelf.superview {
                        superView.sendSubviewToBack(strongSelf)
                    }
            })
        }
        
        self.dismissClosure!()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        // 内容容器视图
        self.bgView = {
            let v = UIView()
            self.addSubview(v)
            v.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            return v
        }()
        
        self.CancelBtn = {
            let btn = UIButton()
            self.bgView!.addSubview(btn)
            btn.snp.makeConstraints({[weak self] (make) in
                guard let strongSelf = self else {
                    return
                }
                make.left.bottom.right.equalTo(strongSelf.bgView!)
                make.height.equalTo(WH(50))
            })
            btn.backgroundColor = bg1
            btn.fontTuple = t44
            btn.setTitleColor(UIColor.lightGray, for: .highlighted)
            btn.setTitle("取消", for: UIControl.State())
            _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.selectedSource = "None"
                strongSelf.dismissClosure!()
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            return btn
        }()
        
        self.separatorView = {
            let v = UIView()
            self.bgView!.addSubview(v)
            v.snp.makeConstraints({[weak self] (make) in
                guard let strongSelf = self else {
                    return
                }
                make.left.right.equalTo(strongSelf.bgView!)
                make.height.equalTo(WH(5))
                make.bottom.equalTo(strongSelf.CancelBtn!.snp.top)
            })
            v.backgroundColor = bg2
            v.alpha = 0.8
            return v
        }()
        
        self.AlbumBtn = {
            let btn = UIButton()
            self.bgView!.addSubview(btn)
            btn.snp.makeConstraints({[weak self] (make) in
                guard let strongSelf = self else {
                    return
                }
                make.left.right.equalTo(strongSelf.bgView!)
                make.bottom.equalTo(strongSelf.separatorView!.snp.top)
                make.height.equalTo(WH(50))
            })
            btn.backgroundColor = bg1
            btn.fontTuple = t44
            btn.setTitleColor(UIColor.lightGray, for: .highlighted)
            btn.setTitle("从手机相册选择", for: UIControl.State())
            _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.selectedSource = "Album"
                strongSelf.dismissClosure!()
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            return btn
        }()
        
        self.separatorLine = {
            let v = UIView()
            self.bgView!.addSubview(v)
            v.snp.makeConstraints({[weak self] (make) in
                guard let strongSelf = self else {
                    return
                }
                make.left.right.equalTo(strongSelf.bgView!)
                make.height.equalTo(WH(1))
                make.bottom.equalTo(strongSelf.AlbumBtn!.snp.top)
            })
            v.backgroundColor = bg2
            return v
        }()
        
        self.CameraBtn = {
            let btn = UIButton()
            self.bgView!.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.left.right.equalTo(self.bgView!)
                make.bottom.equalTo(self.separatorLine!.snp.top)
                make.height.equalTo(WH(50))
            })
            btn.backgroundColor = bg1
            btn.fontTuple = t44
            btn.setTitleColor(UIColor.lightGray, for: .highlighted)
            btn.setTitle("拍照", for: UIControl.State())
            _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.selectedSource = "Camera"
                strongSelf.dismissClosure!()
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            return btn
        }()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.selectedSource = "None"
        self.dismissClosure!()
    }
}
