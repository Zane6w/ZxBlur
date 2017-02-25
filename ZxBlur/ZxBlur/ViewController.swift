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
    
    
    // MARK:- 函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        
        // 对图片进行模糊处理
        imageView.image = ZxBlur.shared.blurry(#imageLiteral(resourceName: "Scenery"), level: 0.2)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupInterface() {
        imageView.frame = self.view.bounds
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
    }

}
