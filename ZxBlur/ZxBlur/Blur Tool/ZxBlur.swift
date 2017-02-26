//
//  ZxBlur.swift
//  ZxBlur
//
//  Created by zhi zhou on 2017/2/25.
//  Copyright © 2017年 zhi zhou. All rights reserved.
//

import UIKit
import Accelerate

class ZxBlur: NSObject {
    
    static let shared = ZxBlur()
    
    
    // MARK:- 方法函数
    
    /// 图片模糊效果处理
    /// - parameter image: 需要处理的图片
    /// - parameter level: 模糊程度（0~1）
    func blurry(_ image: UIImage, level: CGFloat) -> UIImage {
        // 判断模糊程度
        var inLevel: CGFloat = 0
        if level < 0.025 {
            inLevel = 0.025
        } else if level > 1.0 {
            inLevel = 1.0
        } else {
            inLevel = level
        }
        
        // boxSize 必须大于0
        var boxSize = Int(inLevel * 100)
        boxSize -= (boxSize % 2) + 1
        
        // 图像处理
        let disposeImage = image.cgImage
        
        // 图像缓存, 输入缓存\输出缓存
        var inBuffer = vImage_Buffer()
        var outBuffer = vImage_Buffer()
        var error = vImage_Error()
        
        
        let inProvider = disposeImage?.dataProvider
        let inBitmapData = inProvider?.data
        
        inBuffer.width = vImagePixelCount((disposeImage?.width)!)
        inBuffer.height = vImagePixelCount((disposeImage?.height)!)
        inBuffer.rowBytes = (disposeImage?.bytesPerRow)!
        inBuffer.data = UnsafeMutableRawPointer(mutating: CFDataGetBytePtr(inBitmapData!))
        
        // 像素缓存
        let pixelBuffer = malloc((disposeImage?.bytesPerRow)! * (disposeImage?.height)!)
        outBuffer.data = pixelBuffer
        outBuffer.width = vImagePixelCount((disposeImage?.width)!)
        outBuffer.height = vImagePixelCount((disposeImage?.height)!)
        outBuffer.rowBytes = (disposeImage?.bytesPerRow)!
        
        // 第三个中间的缓存区, 抗锯齿的效果
        let pixelBuffer2 = malloc((disposeImage?.bytesPerRow)! * (disposeImage?.height)!)
        var outBuffer2 = vImage_Buffer()
        outBuffer2.data = pixelBuffer2
        outBuffer2.width = vImagePixelCount((disposeImage?.width)!)
        outBuffer2.height = vImagePixelCount((disposeImage?.height)!)
        outBuffer2.rowBytes = (disposeImage?.bytesPerRow)!
        
        
        error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, nil, 0, 0, UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
        error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, nil, 0, 0, UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
        error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, 0, 0, UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
        
        if error != kvImageNoError {
            print(error)
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let ctx = CGContext(data: outBuffer.data, width: Int(outBuffer.width), height: Int(outBuffer.height), bitsPerComponent: 8, bytesPerRow: outBuffer.rowBytes, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        let imageRef = ctx!.makeImage()
        let finalImage = UIImage(cgImage: imageRef!)
        
        // 手动释放内存
        free(pixelBuffer!)
        free(pixelBuffer2)
        
        return finalImage
    }
    
    
    /// 高斯模糊
    /// - parameter view: 需要添加高斯模糊的 View
    /// - parameter style: 高斯模糊样式
    /// - parameter frame: 高斯模糊范围（默认全屏）
    func gaussianBlurry(_ view: UIView, style: UIBlurEffectStyle, frame: CGRect? = nil) {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        if let frame = frame {
            blurView.frame = frame
        } else {
            blurView.frame = UIScreen.main.bounds
        }

        view.addSubview(blurView)
    }
    
    
    /// 高斯模糊, 融合文字
    /// - parameter label: 文字
    /// - parameter inView: 文字所在的 View
    /// - parameter style: 高斯模糊样式
    /// - parameter frame: 高斯模糊范围（默认全屏）
    func gaussianBlurry(_ label: UILabel,  _ inView: UIView, style: UIBlurEffectStyle, frame: CGRect? = nil) {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        //创建并添加vibrancy视图
        let vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        
        if let frame = frame {
            blurView.frame = frame
        } else {
            blurView.frame = UIScreen.main.bounds
        }
        
        vibrancyView.frame = blurView.frame
        blurView.contentView.addSubview(vibrancyView)
        
        //将文本标签添加到vibrancy视图中
        vibrancyView.contentView.addSubview(label)
        
        inView.addSubview(blurView)
    }
    
}
