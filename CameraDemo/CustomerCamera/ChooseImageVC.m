//
//  ChooseImageVC.m
//  CameraDemo
//
//  Created by ak on 15/6/26.
//  Copyright (c) 2015年 hundsun. All rights reserved.
//

#import "ChooseImageVC.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ChooseImageVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation ChooseImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //指定使用照相机模式,可以指定使用相册／照片库
    self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //设置允许裁剪
    //self.allowsEditing = YES;
    
    self.delegate=self;

}

#pragma mark Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //通过UIImagePickerControllerMediaType判断返回的是照片还是视频
    NSString* type = [info objectForKey:UIImagePickerControllerMediaType];

    //如果返回的type等于kUTTypeImage，代表返回的是照片,并且需要判断当前相机使用的sourcetype是拍照还是相册
    if ([type isEqualToString:(NSString*)kUTTypeImage]&&picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
        //拍照
    }else{
        
        //选择照片
        UIImage* original = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        if (self.chooseImageBlock) {
            self.chooseImageBlock(original);
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
