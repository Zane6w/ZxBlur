//
//  ViewController.swift
//  ZxBlur
//
//  Created by zhi zhou on 2017/2/25.
//  Copyright © 2017年 zhi zhou. All rights reserved.
//

import UIKit

/** 图片资源来源
 -> Instagram: @alexstrohl
 */

class ViewController: UIViewController {
    // MARK:- 属性
    let imageView = UIImageView()
    
    // MARK:- 系统函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK:- 功能方法 Demo
extension ViewController {
    
    func setupInterface() {
        imageView.frame = self.view.bounds
        imageView.image = #imageLiteral(resourceName: "Scenery")
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: appDidEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: appWillEnterForegroundNotification, object: nil)
    }
    
    @objc func didEnterBackground() {
        ZxSecure.shared.openBlurSecure()
    }
    
    @objc func willEnterForeground() {
        ZxSecure.shared.closeBlurSecure()
    }
    
}

