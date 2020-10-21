//
//  ViewController.swift
//  美颜相机
//
//  Created by liyang on 16/12/19.
//  Copyright © 2016年 liyang. All rights reserved.
//

import UIKit
import GPUImage

class ViewController: UIViewController {
    
    @IBOutlet weak var bjImg: UIImageView!
    
    fileprivate lazy var camera: GPUImageStillCamera = GPUImageStillCamera(sessionPreset: AVCaptureSessionPresetHigh, cameraPosition: .back)
    
    // 初始化滤镜
    let bilateralFilter = GPUImageBilateralFilter() // 磨皮
    let exposureFilter = GPUImageExposureFilter() // 曝光
    let brightnessFilter = GPUImageBrightnessFilter() // 美白
    let satureationFilter = GPUImageSaturationFilter() // 饱和
    let fileterGroup = GPUImageFilterGroup()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1、创建GPUImageStillCamera
        camera.outputImageOrientation = .portrait
        
        // 2、添加滤镜（美白、曝光、磨皮、曝光）
        let filerGroup = getGroupFileters()
        camera.addTarget(filerGroup)
        
        // 3、创建GPUImage，用于实时显示画面
        let showView = GPUImageView(frame: view.bounds)
        view.insertSubview(showView, at: 0)
        filerGroup.addTarget(showView)
        
        // 4、开始补抓
        camera.startCapture()
        
    }
    
    // MARK:- 旋转镜头
    @IBAction func rotateCamera(_ sender: Any) {
        camera.rotateCamera()
    }
    
    // 拍摄照片
    @IBAction func takeCamera(_ sender: Any) {
        camera.capturePhotoAsImageProcessedUp(toFilter: fileterGroup, withCompletionHandler: { (image, error) in
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
            
            self.bjImg.image = image
            
            // 停止采集
//            self.camera.stopCapture()
        })
    }
    
    
    
    fileprivate func getGroupFileters() -> GPUImageFilterGroup {
        
        // 2、创建滤镜（设置滤镜的引用关系）
        bilateralFilter.addTarget(brightnessFilter)
        brightnessFilter.addTarget(exposureFilter)
        exposureFilter.addTarget(satureationFilter)
        
        // 3、设置滤镜组链的起点&&终点
        fileterGroup.initialFilters = [bilateralFilter]
        fileterGroup.terminalFilter = satureationFilter
        
        return fileterGroup
    }
    
    
    
}

