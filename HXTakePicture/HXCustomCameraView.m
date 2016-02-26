//
//  HXCustomCameraView.m
//  TakePicture
//
//  Created by 黄轩 on 16/2/26.
//  Copyright © 2016年 黄轩 blog.libuqing.com. All rights reserved.
//

#import "HXCustomCameraView.h"

@implementation HXCustomCameraView {
    int _setNum;//切换计数
    BOOL _isShowAnimate;//是否执行拍照图片显示显示过场动画 默认执行
    BOOL _isOpen;//是否让图片数组显示 默认隐藏
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _dataSource = [[NSMutableArray alloc] init];
    [self initDataAndFrame];
}

/**
 *  初始化数据源和位置
 */
- (void)initDataAndFrame {
    _isShowAnimate = YES;
    
    _openButton.frame = CGRectMake(-_openButton.frame.size.width, _openButton.frame.origin.y, _openButton.frame.size.width, _openButton.frame.size.height);
    _scrollView.frame = CGRectMake(320, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height);
    
    [_dataSource removeAllObjects];
}

/**
 *  刷新数据
 */
- (void)refreshData {
    for (UIView *view in self.subviews)
    {
        if (view == _scrollView)
        {
            for(UIView *view in _scrollView.subviews)
            {
                [view removeFromSuperview];
            }
        }
    }
    
    if (_dataSource.count > 0)
    {
        if (_isShowAnimate) {
            [self showAnimate];
            _isShowAnimate = NO;
        }
        if (42+86*_dataSource.count < 320) {
            [_scrollView setContentSize:CGSizeMake(362, 58)];
        } else {
            [_scrollView setContentSize:CGSizeMake(42+86*_dataSource.count, 58)];
        }
        
        _scrollView.delegate = self;
        for(int i = 0 ; i < _dataSource.count; i++)
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(42+86*i, 0, 76, 58)];
            view.backgroundColor = [UIColor clearColor];
            
            UIImageView *imageview = [[UIImageView alloc] init];
            imageview.frame = CGRectMake(2, 9, 72, 48);
            imageview.backgroundColor = [UIColor clearColor];
            imageview.image = _dataSource[_dataSource.count-1-i];
            imageview.layer.masksToBounds = YES;
            imageview.layer.cornerRadius = 2;
            imageview.layer.borderColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;//#cdd3d5
            imageview.layer.borderWidth = 1.0f;
            imageview.contentMode = UIViewContentModeScaleAspectFill;
            imageview.clipsToBounds = YES;
            imageview.userInteractionEnabled = YES;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(60, 0, 18, 18);
            [button setImage:[UIImage imageNamed:@"delete_ picture"] forState:UIControlStateNormal];
            [button addTarget:self
                       action:@selector(deleteImageButtonAction:)
             forControlEvents:UIControlEventTouchUpInside];
            button.tag = _dataSource.count-1-i;
            
            [view addSubview:imageview];
            [view addSubview:button];
            [_scrollView addSubview:view];
        }
    }
    else
    {
        [self initDataAndFrame];
    }
    
    [self refreshTakePictureCount:_dataSource.count];
}

/**
 *  刷新拍照数统计
 *
 *  @param count 照片总数
 */
- (void)refreshTakePictureCount:(NSInteger)count {
    if (count > 0) {
        _pictureCountView.hidden = NO;
        _takePictureCountLabel.text = [NSString stringWithFormat:@"%d",(int)_dataSource.count];
    } else {
        _pictureCountView.hidden = YES;
        _takePictureCountLabel.text = @"";
    }
}

/**
 *  打开图片ScrollView
 *
 *  @param sender <#sender description#>
 */
- (IBAction)openScrollViewButtonAction:(UIButton *)sender {
    [_scrollView scrollRectToVisible:CGRectMake(42, 0, 76, 58) animated:NO];
    
    if (_isOpen) {
        [self showAnimate];
    } else {
        [self hideAnimate];
    }
    
    _isOpen = !_isOpen;
}

/**
 *  执行拍照图片显示照片数组过场动画
 */
- (void)showAnimate {
    _openButton.frame = CGRectMake(-_openButton.frame.size.width, _openButton.frame.origin.y, _openButton.frame.size.width, _openButton.frame.size.height);
    [_openButton setImage:[UIImage imageNamed:@"retract"] forState:UIControlStateNormal];
    _scrollView.frame = CGRectMake(320, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [UIView animateWithDuration:1.0 animations:^{
        _openButton.frame = CGRectMake(0, _openButton.frame.origin.y, _openButton.frame.size.width, _openButton.frame.size.height);
        _scrollView.frame = CGRectMake(0, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height);
    }];
}

/**
 *  执行拍照图片隐藏照片数组过场动画
 */
- (void)hideAnimate {
    _openButton.frame = CGRectMake(320, _openButton.frame.origin.y, _openButton.frame.size.width, _openButton.frame.size.height);
    [_openButton setImage:[UIImage imageNamed:@"Open"] forState:UIControlStateNormal];
    [UIView animateWithDuration:1.0 animations:^{
        _scrollView.frame = CGRectMake(320, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height);
        _openButton.frame = CGRectMake(295, _openButton.frame.origin.y, _openButton.frame.size.width, _openButton.frame.size.height);
    }];
}

/**
 *  删除图片
 *
 *  @param sender <#sender description#>
 */
- (void)deleteImageButtonAction:(UIButton *)sender {
    [_dataSource removeObjectAtIndex:sender.tag];
    [self refreshData];
}

/**
 *  按钮事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)buttonAction:(UIButton *)sender {
    if (sender.tag == 10) {
        [self setCameraFlashModeButtonBackgroundImage:sender];
    }
    
    if (_tagBlock) {
        _tagBlock(sender.tag);
    }
}

/**
 *  改变闪关灯模式图片
 *
 *  @param sender <#sender description#>
 */
- (void)setCameraFlashModeButtonBackgroundImage:(UIButton *)sender {
    _setNum++;
    if (_setNum == 3) {
        _setNum = 0;
    }
    if (_setNum == 0) {
        [_cameraFlashModeButton setImage:[UIImage imageNamed:@"ico_flash_auto_pressed"] forState:UIControlStateHighlighted];
        [_cameraFlashModeButton setImage:[UIImage imageNamed:@"ico_flash_auto_normal"] forState:UIControlStateNormal];
    } else if (_setNum == 1) {
        [_cameraFlashModeButton setImage:[UIImage imageNamed:@"ico_flash_on_pressed"] forState:UIControlStateHighlighted];
        [_cameraFlashModeButton setImage:[UIImage imageNamed:@"ico_flash_on_normal"] forState:UIControlStateNormal];
    } else if (_setNum == 2) {
        [_cameraFlashModeButton setImage:[UIImage imageNamed:@"ico_flash_off_pressed"] forState:UIControlStateHighlighted];
        [_cameraFlashModeButton setImage:[UIImage imageNamed:@"ico_flash_off_normal"] forState:UIControlStateNormal];
    }
}

@end
