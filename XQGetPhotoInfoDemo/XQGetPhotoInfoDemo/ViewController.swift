//
//  ViewController.swift
//  XQGetPhotoInfoDemo
//
//  Created by WXQ on 2019/12/16.
//  Copyright © 2019 WXQ. All rights reserved.
//

import UIKit
import TZImagePickerController

class ViewController: UIViewController, TZImagePickerControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "测试"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "选择图片", style: .plain, target: self, action: #selector(chooseImage))
    }
    
    
    @objc func chooseImage() {
        let vc = TZImagePickerController.init(maxImagesCount: 1, delegate: self)
        
        if let vc = vc {
            vc.allowTakeVideo = false
            vc.allowPickingVideo = false
            vc.naviTitleColor = UIColor.black
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    // MARK: - TZImagePickerControllerDelegate
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        
        print(#function, assets ?? "没有数据")
        
        if let fAsset = assets.first as? PHAsset {
            
            if let location = fAsset.location {
                print(location)
                PHAssetResourceManager;
            }else {
                print("没有定位")
            }
            
        }
        
    }
    
    
}

