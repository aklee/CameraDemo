//
//  FocusView.h
//  CameraDemo
//
//  Created by ak on 15/6/29.
//  Copyright (c) 2015年 hundsun. All rights reserved.
//  自定义对焦层

#import <UIKit/UIKit.h>

@interface FocusView : UIView

+(instancetype)FocusView;

/**
 *  隐藏视图
 */
-(void)dismiss;
/**
 *  展示视图
 */
-(void)present;
@end
