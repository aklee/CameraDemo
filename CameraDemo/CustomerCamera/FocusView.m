//
//  FocusView.m
//  CameraDemo
//
//  Created by ak on 15/6/29.
//  Copyright (c) 2015年 hundsun. All rights reserved.
//

#import "FocusView.h"
#import "UIView+AK.h"
@implementation FocusView

+(instancetype)FocusView{
    
    FocusView*view=(FocusView*)[[[UINib nibWithNibName:@"FocusView" bundle:nil]instantiateWithOwner:nil options:nil  ]firstObject ];
    return view;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self==[super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

/**
 *  初始化
 */
-(void)setup{
    self.layer.borderColor=[UIColor redColor].CGColor;
    self.layer.borderWidth=1;
}
-(void)dismiss{
    [UIView animateWithDuration:1.f
                     animations:^{

                     }
                     completion:^(BOOL finished) {
                          self.alpha=0;
                     }];

    
}
-(void)present{
  
    self.alpha=1;

    CAKeyframeAnimation *kfa = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    CGFloat s =1.0;
    CGFloat space=0.2;

    kfa.values = @[@(s-space),@(s),@(s+space),@(s)];
    
    //时长
    kfa.duration = .2f;
    
    //重复
    kfa.repeatCount =2;
    
    //移除
    kfa.removedOnCompletion = YES;
    
    [self.layer addAnimation:kfa forKey:@"Stretch"];
    
    
    
}

@end
