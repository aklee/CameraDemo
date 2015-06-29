//
//  CustomerCameraView.m
//  CameraDemo
//
//  Created by ak on 15/6/26.
//  Copyright (c) 2015年 hundsun. All rights reserved.
//

#import "CustomerCameraView.h"
@import AssetsLibrary;

@interface CustomerCameraView()
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIButton *pictureBtn;

@property (weak, nonatomic) IBOutlet UIButton *turnBtn;

@property (weak, nonatomic) IBOutlet UIButton *flushBtn;

@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;


//拍照
- (IBAction)picture:(id)sender;
//返回
- (IBAction)cancel:(id)sender;
//切换摄像头
- (IBAction)turn:(id)sender;
//切换闪光灯
- (IBAction)flush:(id)sender;
//选择照片
- (IBAction)chooseImage:(id)sender;


@end
@implementation CustomerCameraView

+(instancetype)CustomerCameraView{
    
    CustomerCameraView*view=(CustomerCameraView*)[[[UINib nibWithNibName:@"CustomerCameraView" bundle:nil]instantiateWithOwner:nil options:nil  ]firstObject ];
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
    //设置图片
    [self latestImage];
    
    //默认设置 后置摄像头  关闭闪光灯
    self.turnBtn.selected=NO;
    self.flushBtn.selected=NO;
    
    
}

- (IBAction)picture:(id)sender {
    
    
    if (self.TakePhotoBlock) {
        self.TakePhotoBlock();
    }
}

- (IBAction)cancel:(id)sender {
    if (self.backBlock) {
        self.backBlock();
    }
}

- (IBAction)turn:(id)sender {
   
    if (self.turnblock) {
        self.turnblock(self.turnBtn.selected);
    }
    self.turnBtn.selected=!self.turnBtn.selected;
    
  
}

- (IBAction)flush:(id)sender {

    if (self.flushBlock) {
        self.flushBlock(self.flushBtn.selected);
    }
    
    self.flushBtn.selected=!self.flushBtn.selected;
    
  
}
- (IBAction)chooseImage:(id)sender {
    if (self.chooseImageBlock) {
        self.chooseImageBlock();
    }
}

/**
 *  设置相册中最后一张图片
 *
 */
-(void)latestImage{
    
    
    // get the latest image from the album
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status != ALAuthorizationStatusDenied) {
        // access to album is authorised
        
        //获取相册最后一张图片
        [self latestPhotoWithCompletion:^(UIImage *photo) {
            
            [self.chooseBtn setImage:photo forState:UIControlStateNormal];
            
        }];
        

    }
    else{
        [[[UIAlertView alloc] initWithTitle:@"Sorry!"
                                    message:@"ALAssetsLibrary doesn't have permission"
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];

    }
   
}



/**
 *  从相册中获取最晚被添加的图片
 *
 *  @param completion 带返回图片的block
 */
- (void)latestPhotoWithCompletion:(void (^)(UIImage *photo))completion
{
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    
    ALAssetsLibrary *lib=[[ALAssetsLibrary alloc]init];
    [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        // Within the group enumeration block, filter to enumerate just photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        // For this example, we're only interested in the last item [group numberOfAssets]-1 = last.
        if ([group numberOfAssets] > 0) {
            [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:[group numberOfAssets]-1] options:0
                                 usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
                                     // The end of the enumeration is signaled by asset == nil.
                                     if (alAsset) {
                                         ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                                         // Do something interesting with the AV asset.
                                         UIImage *img = [UIImage imageWithCGImage:[representation fullScreenImage]];
                                         
                                         // completion
                                         completion(img);
                                         
                                         // we only need the first (most recent) photo -- stop the enumeration
                                         *innerStop = YES;
                                     }
                                 }];
        }
    } failureBlock: ^(NSError *error) {
        // Typically you should handle an error more gracefully than this.
    }];
}

@end
