//
//  MyCameraViewController.m
//  CameraDemo
//
//  Created by ak on 15/6/26.
//  Copyright (c) 2015年 hundsun. All rights reserved.
//

#import "MyCameraViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "CustomerCameraView.h"
#import "ChooseImageVC.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "FocusView.h"

@interface MyCameraViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,weak)UIImagePickerController*imagePickerVC;
@property(nonatomic,weak) CustomerCameraView*cameraView;

@property(nonatomic,assign)CGPoint focusPoint;
//对焦层
@property(nonatomic,strong)FocusView *focusView;
@end

@implementation MyCameraViewController
-(FocusView *)focusView{
    if (!_focusView) {
        _focusView=[FocusView FocusView];
        [self.view addSubview:_focusView];
    }
    return  _focusView;
}
-(void)viewWillAppear:(BOOL)animated{
   
    AVCaptureDevice*camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    int flags =NSKeyValueObservingOptionNew;
    [camDevice addObserver:self forKeyPath:@"adjustingFocus" options:flags context:nil];

    [super viewWillAppear:animated];
    
}
// unregister observer
-(void)viewWillDisappear:(BOOL)animated{
    AVCaptureDevice*camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [camDevice removeObserver:self forKeyPath:@"adjustingFocus"];
    
    [super viewWillDisappear:animated];
}

-(void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    if([keyPath isEqualToString:@"adjustingFocus"]){
        BOOL adjustingFocus =[[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1]];
        NSLog(@"Is adjusting focus? %@", adjustingFocus ?@"YES":@"NO");
        NSLog(@"Change dictionary: %@", change);
        if (adjustingFocus) {
            self.focusView.center=self.focusPoint;
            [self.focusView present];
        }
        else{
            self.focusView.center=self.focusPoint;
            [self.focusView dismiss];
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch*touch=    [touches anyObject];
    CGPoint p=    [touch locationInView:self.view];
    self.focusPoint=p;
    NSLog(@"%@",NSStringFromCGPoint(p));
}
- (void)viewDidLoad {

    [super viewDidLoad];
    
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"not suport simulator");
    return;
#endif
    
    self.view.backgroundColor=[UIColor blackColor];
    
    self.navigationController.navigationBarHidden=YES;
    
    //初始化
    [self setup];

    
    
    //建议 使用animation 动态展示相机层
    [self.view addSubview:self.imagePickerVC.view];
    
    
    //实例化
//    AVCaptureDevice  *captureDevice = [[AVCaptureDevice alloc] init];
    

//    //先进行判断是否支持控制对焦
//    if (captureDevice.isFocusPointOfInterestSupported &&[captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
//        
//        NSError *error = nil;
//        //对cameraDevice进行操作前，需要先锁定，防止其他线程访问，
////        [self.recorder.cameraDevice lockForConfiguration:&error];
////        [self.recorder.cameraDevice setFocusMode:AVCaptureFocusModeAutoFocus];
////        [self.recorder.cameraDevice setFocusPointOfInterest:CGPointMake(pointX,pointY)];
////        //操作完成后，记得进行unlock。
////        [self.recorder.cameraDevice unlockForConfiguration];
//    }
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
//    [self.view addGestureRecognizer:tap];
    
}
//-(void)handleTap:(UITapGestureRecognizer*)tap{
//   CGPoint  p= [tap locationInView:self.view];
//    NSLog(@"%@",NSStringFromCGPoint(p));
//}
/**
 *  初始化
 */
-(void)setup{
    
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    
    
    [self addChildViewController:controller];
    
    controller.view.frame=self.view.bounds;
    
    
    
    //指定使用照相机模式,可以指定使用相册／照片库
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    
    // 设置所支持的类型，设置只能拍照，或则只能录像，或者两者都可以
    [controller setMediaTypes:@[(NSString*)kUTTypeImage]];
    //kUTTypeMovie,kUTTypeImage
    
 
    
    //将取景框变成全屏
    CGSize screenBounds = [UIScreen mainScreen].bounds.size;
    CGFloat cameraAspectRatio = 4.0f/3.0f;
    CGFloat camViewHeight = screenBounds.width * cameraAspectRatio;
    CGFloat scale = screenBounds.height / camViewHeight;
    controller.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenBounds.height - camViewHeight) / 2.0);
    controller.cameraViewTransform = CGAffineTransformScale(controller.cameraViewTransform, scale, scale);
    
    // 设置代理
    controller.delegate=self;
    
    self.imagePickerVC=controller;
    
    
    
     //自定义相机图层
    
    //设置拍照时的下方的工具栏是否显示，如果需要自定义拍摄界面，则可把该工具栏隐藏
    self.imagePickerVC.showsCameraControls  = NO;
    
    CustomerCameraView*view=[CustomerCameraView CustomerCameraView];
   
    self.imagePickerVC.cameraOverlayView=view;
    
    self.cameraView=view;
    
    
    
    
    view.backBlock=^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
    
    view.TakePhotoBlock=^{
        [self.imagePickerVC takePicture];
    };
    
    view.chooseImageBlock=^{
        
        ChooseImageVC *vc=[[ChooseImageVC alloc]init];
        
        vc.chooseImageBlock=^(UIImage* image){
            NSLog(@"获取选择图片");
        };
        
        [self presentViewController:vc animated:YES
                         completion:^{
                             
                         }];
    };
    
    view.flushBlock=^(BOOL isOFF){
        
        if (isOFF) {
            //关闭闪光灯
            self.imagePickerVC.cameraFlashMode=UIImagePickerControllerCameraFlashModeOff;
            
        }
        else{
            //开启闪光灯
            self.imagePickerVC.cameraFlashMode=UIImagePickerControllerCameraFlashModeOn;
        }
        
    };
    
    view.turnblock=^(BOOL isRear){
        if (isRear) {
            //开启后置摄像头
            self.imagePickerVC.cameraDevice=UIImagePickerControllerCameraDeviceRear;
        }
        else{
            //开启前置摄像头
            self.imagePickerVC.cameraDevice=UIImagePickerControllerCameraDeviceFront;
        }
        
    };
    


    
    
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
        UIImage* original = [info objectForKey:UIImagePickerControllerOriginalImage];
        //获取图片裁剪的图
//        UIImage* edit = [info objectForKey:UIImagePickerControllerEditedImage];
        //获取图片裁剪后，剩下的图
        //        UIImage* crop = [info objectForKey:UIImagePickerControllerCropRect];
        //获取图片的url
        //        NSURL* url = [info objectForKey:UIImagePickerControllerMediaURL];
        //获取图片的metadata数据信息
        //        NSDictionary* metadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
        //如果是拍照的照片，则需要手动保存到本地，系统不会自动保存拍照成功后的照片
        UIImageWriteToSavedPhotosAlbum(original, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }else{
        
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{

    [self.navigationController popToRootViewControllerAnimated:YES];

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




@end
