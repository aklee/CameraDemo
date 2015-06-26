//
//  CustomerCameraView.h
//  CameraDemo
//
//  Created by ak on 15/6/26.
//  Copyright (c) 2015年 hundsun. All rights reserved.
//  自定义相机-顶部覆盖层

#import <UIKit/UIKit.h>

/**
 *  拍照
 *
 *  @return <#return value description#>
 */
typedef  void(^TakePhoto)();

/**
 *  返回
 *
 *  @return <#return value description#>
 */
typedef  void(^back)();

/**
 * 切换摄像头
 *
 *  @param isRear 是否后置摄像头
 *
 *  @return YES 后置摄像头 NO 前置摄像头
 */
typedef  void(^turn)(BOOL isRear);

/**
 *  切换闪光灯
 *
 *  @param isOFF 是否关闭
 *
 *  @return YES 关闭 NO 自动
 */
typedef  void(^flush)(BOOL isOFF);

/**
 *  选择照片
 *
 *  @return
 */
typedef  void(^chooseImage)();



@interface CustomerCameraView : UIView

+(instancetype)CustomerCameraView;

@property(nonatomic,copy)back backBlock;

@property(nonatomic,copy)turn turnblock;

@property(nonatomic,copy)flush flushBlock;

@property(nonatomic,copy)TakePhoto TakePhotoBlock;

@property(nonatomic,copy)chooseImage chooseImageBlock;

 

@end
