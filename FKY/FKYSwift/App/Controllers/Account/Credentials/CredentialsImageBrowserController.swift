//
//  CredentialsImageBrowserController.swift
//  FKY
//
//  Created by yangyouyong on 2016/11/3.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  未使用?!

import UIKit
import SnapKit
import RxSwift

class CredentialsImageBrowserController: UIViewController {

    fileprivate lazy var imageV: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    fileprivate lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    fileprivate lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    var image: UIImage?
    
    override func loadView() {
        super.loadView()
        self.setupView()
    }
    
    func setupView() {
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints({ (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(WH(SCREEN_WIDTH))
        })
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
            make.width.equalTo(SCREEN_WIDTH)
        })
        
        scrollView.addSubview(imageV)
        imageV.snp.makeConstraints({ (make) in
            make.top.left.right.bottom.equalTo(self.scrollView)
        })
        
        contentView.snp.makeConstraints({ (make) in
            make.height.equalTo(self.imageV)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = self.image {
            self.imageV.image = image
        }
        self.scrollView.backgroundColor = bg1
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
