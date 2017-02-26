//
//  ZxSecure.swift
//  ZxBlur
//
//  Created by zhi zhou on 2017/2/26.
//  Copyright © 2017年 zhi zhou. All rights reserved.
//

import UIKit

class ZxSecure: NSObject {
    // MARK:- 属性
    static let shared = ZxSecure()
    
    fileprivate var secureView: ZxSecureView?
    
    
    // MARK:- 方法函数
    
    /// 开启后台模糊安全保护
    /// - parameter blurLevel: 模糊程度（0~1）, 默认 0.1
    /// - parameter frame: 默认取值 window 的 frame
    func openBlurSecure(blurLevel: CGFloat = 0.1, frame: CGRect? = nil) {
        var blurFrame: CGRect = .zero
        
        if let frame = frame {
            blurFrame = frame
        } else {
            for window in UIApplication.shared.windows {
                if window.isKind(of: UIWindow.self) {
                    blurFrame = window.frame
                }
            }
        }
        
        let secureView = ZxSecureView(frame: blurFrame)
        secureView.blurLevel = blurLevel
        self.secureView = secureView
        
        for window in UIApplication.shared.windows {
            if window.windowLevel == UIWindowLevelNormal {
                window.addSubview(secureView)
            }
        }
    }
    
    /// 关闭后台模糊安全保护
    func closeBlurSecure() {
        for window in UIApplication.shared.windows {
            if window.windowLevel == UIWindowLevelNormal {
                self.secureView?.removeFromSuperview()
            }
        }
    }
    
}

