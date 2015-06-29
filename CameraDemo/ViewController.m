//
//  ViewController.m
//  CameraDemo
//
//  Created by ak on 15/6/26.
//  Copyright (c) 2015年 hundsun. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import "MyCameraViewController.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UIImagePickerController*imagePickerVC;

- (IBAction)btnClicked:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"not suport simulator");
    return;
#endif
    [self setup];

}
-(void)setup{
    
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    
    NSArray* mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    for (NSString* type in mediaTypes) {
        NSLog(@"media types:%@",type);//kUTTypeMovie,kUTTypeImage
    }
    
    // 设置所支持的类型，设置只能拍照，或则只能录像，或者两者都可以
    
    [controller setMediaTypes:@[(NSString*)kUTTypeImage]];
    //kUTTypeMovie,kUTTypeImage
    
    
    // 设置是否可以管理已经存在的图片或者视频
//    [controller setAllowsEditing:YES];

    // 设置代理
    controller.delegate=self;

    self.imagePickerVC=controller;
    
    
}

-(void)cancelCamera{
    [self.imagePickerVC dismissViewControllerAnimated:YES completion:^{
        
    }];

}

-(void)savePhoto{

}

#pragma mark Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //通过UIImagePickerControllerMediaType判断返回的是照片还是视频
    NSString* type = [info objectForKey:UIImagePickerControllerMediaType];
    //如果返回的type等于kUTTypeImage，代表返回的是照片,并且需要判断当前相机使用的sourcetype是拍照还是相册
    if ([type isEqualToString:(NSString*)kUTTypeImage]&&picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
        //获取照片的原图
//        UIImage* original = [info objectForKey:UIImagePickerControllerOriginalImage];
        //获取图片裁剪的图
        UIImage* edit = [info objectForKey:UIImagePickerControllerEditedImage];
        //获取图片裁剪后，剩下的图
//        UIImage* crop = [info objectForKey:UIImagePickerControllerCropRect];
        //获取图片的url
//        NSURL* url = [info objectForKey:UIImagePickerControllerMediaURL];
        //获取图片的metadata数据信息
//        NSDictionary* metadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
        //如果是拍照的照片，则需要手动保存到本地，系统不会自动保存拍照成功后的照片
        UIImageWriteToSavedPhotosAlbum(edit, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }else{
        
    }
    [self.imagePickerVC dismissViewControllerAnimated:YES completion:^{
        
    }];
 
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.imagePickerVC dismissViewControllerAnimated:YES completion:^{
        
    }];
}



//保存照片成功后的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{
    NSString* msg=@"";
    if (!error) {
        msg=@"success";
    }
    else{
        msg=error.localizedDescription;
    }
    
    NSLog(@"saved..");
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:@"保存图片" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:msg otherButtonTitles: nil];
    [action showInView:self.view];
    
}

#pragma mark Available
/**
 *  相机是否可用
 *
 *  @return 是否可用
 */
-(BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

/**
 *  后置摄像头是否可用
 *
 *  @return 是否可用
 */
-(BOOL)isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceRear];
}

/**
 *  前置摄像头是否可用
 *
 *  @return 是否可用
 */
-(BOOL)isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceFront];
}



/**
 *  图片列表是否可用
 *
 *  @return 是否可用
 */
-(BOOL)isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}


/**
 *  相册列表是否可用
 *
 *  @return 是否可用
 */
-(BOOL)isPhotoAlbumAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

- (IBAction)btnClicked:(id)sender {
    
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"not suport simulator");
    return;
#endif
    
    UIButton*btn =(UIButton*)sender;
    NSInteger tag=btn.tag;
    NSLog(@"tag:%ld",(long)tag);
    switch (tag) {
        case 1:
        {
            //拍照
            
            //指定使用照相机模式,可以指定使用相册／照片库
            self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
         
            [self.imagePickerVC setMediaTypes:@[(NSString*)kUTTypeImage]];
            //kUTTypeMovie,kUTTypeImage
            
            //设置允许裁剪
            self.imagePickerVC.allowsEditing = YES;
         
            //设置拍照时的下方的工具栏是否显示，如果需要自定义拍摄界面，则可把该工具栏隐藏
            self.imagePickerVC.showsCameraControls  = YES;
          
            //设置使用后置摄像头，可以使用前置摄像头
            self.imagePickerVC.cameraDevice = UIImagePickerControllerCameraDeviceRear;

            //将取景框变成全屏
//            CGSize screenBounds = [UIScreen mainScreen].bounds.size;
//            CGFloat cameraAspectRatio = 4.0f/3.0f;
//            CGFloat camViewHeight = screenBounds.width * cameraAspectRatio;
//            CGFloat scale = screenBounds.height / camViewHeight;
//            self.imagePickerVC.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenBounds.height - camViewHeight) / 2.0);
//            self.imagePickerVC.cameraViewTransform = CGAffineTransformScale(self.imagePickerVC.cameraViewTransform, scale, scale);
    
            
            //设置拍摄时屏幕的view的transform属性，可以实现旋转，缩放功能
//            self.imagePickerVC.cameraViewTransform = CGAffineTransformMakeRotation(M_PI_4);
//            
//            self.imagePickerVC.cameraViewTransform = CGAffineTransformMakeScale(1.1, 1.1);
            
        }            break;
        case 2:{
            //录像
            
            //指定使用照相机模式,可以指定使用相册／照片库
            self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self.imagePickerVC setMediaTypes:@[(NSString*)kUTTypeMovie]];
            //kUTTypeMovie,kUTTypeImage
            
            // 设置录制视频的质量
            [self.imagePickerVC setVideoQuality:UIImagePickerControllerQualityTypeHigh];
            
            //设置最长摄像时间
            [self.imagePickerVC setVideoMaximumDuration:3.f];
            

            break;
        }
        case 3:{
            //取图片 -列表

            //指定使用照相机模式,可以指定使用相册／照片库
            self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
          
            //设置允许裁剪
            self.imagePickerVC.allowsEditing = YES;
            break;
        }
        case 4:{
            //取图片 -相册

            //指定使用照相机模式,可以指定使用相册／照片库
            self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
            //设置允许裁剪
            self.imagePickerVC.allowsEditing = YES;
            break;
        }
            
        case 5:{
            //取视频 -相册
            [self.imagePickerVC setMediaTypes:@[(NSString*)kUTTypeMovie]];
            
            //指定使用照相机模式,可以指定使用相册／照片库
            self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
            //设置允许裁剪
            self.imagePickerVC.allowsEditing = YES;
            break;
        }
            
        case 6:{
            //调用自定义相机
            MyCameraViewController *vc=[[MyCameraViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            return ;
            break;
        }
        default:
            break;
    }

    [self presentViewController:self.imagePickerVC animated:YES
                     completion:^{
                         
                     }];
}
@end
