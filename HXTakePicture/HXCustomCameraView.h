//
//  HXCustomCameraView.h
//  TakePicture
//
//  Created by 黄轩 on 16/2/26.
//  Copyright © 2016年 黄轩 blog.libuqing.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HXCustomCameraViewButtonActionTagBlock)(NSInteger tag);

@interface HXCustomCameraView : UIView <UIScrollViewDelegate>

/**
 *  图片展示scrollView
 */
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

/**
 *  打开scrollView开关按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *openButton;

/**
 *  闪光灯Button
 */
@property (weak, nonatomic) IBOutlet UIButton *cameraFlashModeButton;

/**
 *  拍照照片数量View
 */
@property (weak, nonatomic) IBOutlet UIView *pictureCountView;

/**
 *  拍照照片数量Label
 */
@property (weak, nonatomic) IBOutlet UILabel *takePictureCountLabel;

/**
 *  回调block 回调按钮的tag
 */
@property (nonatomic, copy) HXCustomCameraViewButtonActionTagBlock tagBlock;

/**
 *  @param dataSource 拍照的图片数组
 */
@property (strong,nonatomic) NSMutableArray *dataSource;

/**
 *  初始化数据源和位置
 */
- (void)initDataAndFrame;

/**
 *  刷新数据
 */
- (void)refreshData;

@end
