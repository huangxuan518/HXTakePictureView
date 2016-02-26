//
//  HXViewController.m
//  HXFelicity
//
//  Created by 黄轩 on 16/2/2.
//  Copyright © 2016年 黄轩 blog.libuqing.com. All rights reserved.
//

#import "HXViewController.h"
#import "HXCustomCameraView.h"

@interface HXViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong,nonatomic) UIImagePickerController *imagePicker;
@property (weak,nonatomic) HXCustomCameraView *customCameraView;

@end

@implementation HXViewController

#pragma mark -
#pragma mark  View Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)buttonAction:(UIButton *)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if (!_imagePicker) {
            _imagePicker = [[UIImagePickerController alloc] init];
            //代理
            _imagePicker.delegate = self;
            //类型
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            _imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            //隐藏系统相机操作
            _imagePicker.showsCameraControls = NO;
            //设定相机全屏
            CGSize screenBounds = [UIScreen mainScreen].bounds.size;
            CGFloat cameraAspectRatio = 4.0f/3.0f;
            CGFloat camViewHeight = screenBounds.width * cameraAspectRatio;
            CGFloat scale = screenBounds.height / camViewHeight;
            _imagePicker.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenBounds.height - camViewHeight) / 2.0);
            _imagePicker.cameraViewTransform = CGAffineTransformScale(_imagePicker.cameraViewTransform, scale, scale);
            _imagePicker.cameraOverlayView = [self customViewForImagePicker:_imagePicker];
        }
        [self presentViewController:_imagePicker animated:YES completion:nil];
    } else {
        NSLog(@"照相机不可用");
    }
}

/**
 *  自定义相机界面及按钮事件
 *
 *  @param imagePicker 相机
 *
 *  @return 相机
 */
- (UIView *)customViewForImagePicker:(UIImagePickerController *)imagePicker {
    
    _customCameraView = [[[UINib nibWithNibName:@"CustomCameraView" bundle:nil]instantiateWithOwner:nil options:nil]objectAtIndex:0];
    _customCameraView.tagBlock = ^(NSInteger tag)
    {
        if (tag == 10) {
            [self setCameraFlashMode:imagePicker];
        } else if (tag == 11) {
            [self setCameraDevice:imagePicker];
        } else if (tag == 12) {
            [self cameraTakePicture:imagePicker];
        } else if (tag == 13) {
            [self cancelCameraTakePicture];
        } else if (tag == 14) {
            [self completeCameraTakePicture];
        }
    };
    return _customCameraView;
}

/**
 *  设置闪光灯模式
 *  UIImagePickerControllerCameraFlashModeAuto 自动
 *  UIImagePickerControllerCameraFlashModeOn 打开
 *  UIImagePickerControllerCameraFlashModeOff 关闭
 *
 *  @param imagePicker 类型为相机的UIImagePickerController
 */
- (void)setCameraFlashMode:(UIImagePickerController *)imagePicker {
    if (imagePicker.cameraFlashMode == UIImagePickerControllerCameraFlashModeAuto) {
        imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
    } else if (imagePicker.cameraFlashMode == UIImagePickerControllerCameraFlashModeOn) {
        imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    } else if (imagePicker.cameraFlashMode == UIImagePickerControllerCameraFlashModeOff) {
        imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    }
}

/**
 *  设置摄像头模式
 *  UIImagePickerControllerCameraDeviceRear 后置摄像头
 *  UIImagePickerControllerCameraDeviceFront 前置摄像头
 *
 *  @param imagePicker 类型为相机的UIImagePickerController
 */
- (void)setCameraDevice:(UIImagePickerController *)imagePicker {
    //前后置摄像头
    if (imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    } else {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}

/**
 *  拍照
 *
 *  @param imagePicker 类型为相机的UIImagePickerController
 */
- (void)cameraTakePicture:(UIImagePickerController *)imagePicker {
    [imagePicker takePicture];
}

/**
 *  取消拍照
 */
- (void)cancelCameraTakePicture {
    [_customCameraView initDataAndFrame];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  完成拍照
 */
- (void)completeCameraTakePicture {
    NSLog(@"完成拍照");
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"%@",_customCameraView.dataSource);
}

/**
 *  代理
 *
 *  @return <#return value description#>
 */
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    [_customCameraView.dataSource addObject:originalImage];
    [_customCameraView refreshData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
