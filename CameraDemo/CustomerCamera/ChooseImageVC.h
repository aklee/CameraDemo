//
//  ChooseImageVC.h
//  CameraDemo
//
//  Created by ak on 15/6/26.
//  Copyright (c) 2015年 hundsun. All rights reserved.
// 选择照片vc

#import <UIKit/UIKit.h>

/**
 *  选择照片后触发的block
 *
 *  @param image 选择的照片
 */
typedef void (^ChooseImage)(UIImage* image);

@interface ChooseImageVC : UIImagePickerController

@property(nonatomic,copy)ChooseImage chooseImageBlock;

@end
