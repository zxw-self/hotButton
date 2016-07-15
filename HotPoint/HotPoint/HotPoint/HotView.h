//
//  HotView.h
//  TouGuApp
//
//  Created by tianshikechuang on 16/7/14.
//  Copyright © 2016年 tianshikechuang. All rights reserved.
//

#import <UIKit/UIKit.h>



@class HotView;
typedef void(^HotViewDidClick)(HotView * hotView,UIButton * button);




@interface HotView : UIView

@property(nonatomic, strong) HotViewDidClick clickBlock;        // 点击的时候调用的block

@property(nonatomic, assign) BOOL isPanMoview;                  // 是否支持拖动（默认为NO）

@property(nonatomic, assign) CGFloat gapMax;                    // hot按钮与添加的按钮之间的间隙 (默认为 20)
@property(nonatomic, assign) CGFloat gapMin;                    // 添加的按钮之间的间隙 (默认为 8)


/**
 *  创建HotView
 *
 *  @param frame HotView的大小 位置
 *
 *  @return hotView
 */
+ (instancetype)hotViewWithFrame:(CGRect)frame;



/**
 *  移动hotView到某个位置
 *
 *  @param point 左上角的位置点
 */
- (void)moveHotViewTo:(CGPoint)point;



/**
 *  给展开的HotView添加视图
 *
 *  @param View 要添加的视图/Button
 */
- (void)addViewToHotView:(UIView *)button;



/**
 *  热键图片
 *
 *  @param image 热键的背景图片
 */
- (void)hotViewImage:(UIImage *)image;


@end
