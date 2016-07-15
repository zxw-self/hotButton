//
//  HotView.m
//  TouGuApp
//
//  Created by tianshikechuang on 16/7/14.
//  Copyright © 2016年 tianshikechuang. All rights reserved.
//

#import "HotView.h"


@interface OutRangeView : UIView

@end

@implementation OutRangeView


@end

@interface OutRangeButton : UIButton

@end

@implementation OutRangeButton


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    //if内的条件应该为，当触摸点point超出蓝色部分，但在黄色部分时
    if (CGRectContainsPoint(self.bounds, point)){
        return YES;
    }else{
        for (UIView  * view in self.subviews) {
            if ([view isKindOfClass:[OutRangeView class]] && CGRectContainsPoint(view.bounds, [self convertPoint:point toView:view])){
                   return YES;
            }
        }
        
    }
    return NO;
}


////重写该方法后可以让超出父视图范围的子视图响应事件
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *view = [super hitTest:point withEvent:event];
//    if (view == nil) {
//        for (UIView *subView in self.contentView.subviews) {
//            CGPoint tp = [subView convertPoint:point fromView:self.contentView];
//            if (CGRectContainsPoint(subView.bounds, tp)) {
//                view = subView;
//            }
//        }
//    }
//
//    return view;
//}

@end



///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////
/////////////// 以上为内部内 以方便做按钮超出范围的时候 可以有点击事件
///////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////



@interface HotView ()

{
    CGPoint netTranslation;
}
@property(nonatomic, strong) OutRangeButton * hotButton;

@property(nonatomic, strong) UIButton * hotPlace;
@property(nonatomic, strong) UIView * contentView;


@property(nonatomic, assign) CGRect orginFrame;
@property(nonatomic, assign) CGRect screenFrame;

@property(nonatomic, assign) CGRect contentMinFrame;
@property(nonatomic, assign) CGRect contentMaxFrame;


@property(nonatomic, strong) UIPanGestureRecognizer * panGesture;
@property(nonatomic, strong) NSMutableArray * otherButs;


@end




@implementation HotView


+ (instancetype)hotViewWithFrame:(CGRect)frame{
    return [[self alloc] initWithFrame:frame];
}




- (void)moveHotViewTo:(CGPoint)point{
    CGRect frame = self.frame;
    frame.origin = point;
    self.frame = frame;
    self.orginFrame = frame;
}

- (void)addViewToHotView:(UIView *)button{
    
    [self.otherButs addObject:button];
}

- (void)hotViewImage:(UIImage *)image{

    self.hotPlace = [[UIButton alloc] initWithFrame:self.hotButton.bounds];
    self.hotPlace.userInteractionEnabled = NO;
    [self.hotButton addSubview:self.hotPlace];
    [self.hotPlace setBackgroundImage:image forState:UIControlStateNormal];
}



- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.orginFrame = frame;
        self.screenFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        CGFloat wdith = frame.size.width;
        self.contentMaxFrame = CGRectMake(0, -wdith, frame.size.width, wdith);
        self.contentMinFrame = CGRectMake(0, 0, frame.size.width, 0);
        
        self.gapMax = 20;
        self.gapMin = 8;
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
        
        [self addSubview:self.hotButton];
        
        [self addGestureRecognizer:self.panGesture];
        
        self.otherButs = [NSMutableArray array];
    }
    return self;
}

- (OutRangeButton *)hotButton{
    
    if (!_hotButton) {
        _hotButton = [[OutRangeButton alloc] initWithFrame:self.bounds];
        _hotButton.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.50 alpha:0.5];
        _hotButton.layer.cornerRadius = self.bounds.size.width/2;
        _hotButton.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8].CGColor;
        _hotButton.layer.borderWidth = 5;
        [_hotButton addTarget:self action:@selector(hotButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.contentView = [[OutRangeView alloc] initWithFrame:self.contentMinFrame];
//        self.contentView.backgroundColor = [UIColor grayColor];
        self.contentView.clipsToBounds = YES;
        [_hotButton addSubview:self.contentView];
 
    }
    return _hotButton;
}

// 开发者自由定义的按钮之类的frame
- (void)layoutContentViews{
    
    
    __block CGFloat height;
    __block CGFloat width;
    [self.otherButs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIView * view = obj;
        CGRect viewFrame = view.frame;
        
        if (idx == 0) {
            height = 0.001;
            width = viewFrame.size.width;
        }
        
        viewFrame.origin = CGPointMake(0, height);
        viewFrame.size = CGSizeMake(width, viewFrame.size.height);
        view.frame = viewFrame;
        height = height + viewFrame.size.height + self.gapMin;
        
        if ([obj isKindOfClass:[UIControl class]]) {
            [(UIControl *)view addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
        }
        
        [self.contentView addSubview:view];
        
    }];
    
    CGRect frame = self.contentMaxFrame;
    CGFloat orginW = self.orginFrame.size.width;
    frame.size = CGSizeMake(width, height + self.gapMin);
    frame.origin = CGPointMake((orginW - width)/2.0, - frame.size.height);
    self.contentMaxFrame = frame;
    self.contentView.frame = frame;
    
    
}


// 定死了的按钮之类的frame
//- (void)layoutContentViews{
//    
//    int count = (int)self.otherButs.count;
//    CGRect frame = self.contentMaxFrame;
//    frame.size = CGSizeMake(frame.size.width, (frame.size.width + 10 )* count + 30);
//    frame.origin = CGPointMake(frame.origin.x, - frame.size.height);
//    self.contentMaxFrame = frame;
//    self.contentView.frame = frame;
//
//    CGSize equlSize = CGSizeMake(frame.size.width, frame.size.width);
//    [self.otherButs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        UIView * view = obj;
//        CGRect viewFrame;
//        viewFrame.origin = CGPointMake(0, idx * (equlSize.width + 10));
//        viewFrame.size = equlSize;
//        view.frame = viewFrame;
//        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
//        [self.contentView addSubview:view];
//        
//    }];
//    
//    
//}


- (UIPanGestureRecognizer *)panGesture{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    }
    return _panGesture;
}


// 拖转手势的处理事件
- (void)panGestureAction:(UIPanGestureRecognizer *)sender{
    
    if (!self.isPanMoview) {
        return ;
    }
    
    
    if(sender.state==UIGestureRecognizerStateBegan){
        netTranslation = sender.view.frame.origin;
        
    }
    
    //得到拖的过程中的xy坐标
    CGPoint translation=[sender translationInView:sender.view.superview];
    
    
    CGFloat x = translation.x + netTranslation.x;
    CGFloat y = translation.y + netTranslation.y;
    CGFloat w = self.orginFrame.size.width;
    CGFloat h = self.orginFrame.size.height;
    
    //平移图片CGAffineTransformMakeTranslation
    sender.view.frame = CGRectMake(x, y , w, h);

    
    //状态结束，保存数据
    if(sender.state==UIGestureRecognizerStateEnded){
        [self makeViewInSuper:sender.view];
        
        self.orginFrame = sender.view.frame;
        netTranslation = self.orginFrame.origin;
    }
}




// 接触到空白地方 就缩小到热键
- (void)tapAction{
    [self hotButtonAction:self.hotButton];
}

// 热键的点击事件
- (void)hotButtonAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    self.hotPlace.selected = sender.selected;
    netTranslation = self.orginFrame.origin;
    
    if(sender.selected){
        
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = self.screenFrame;
            self.hotButton.frame = self.orginFrame;
            self.contentView.frame = self.contentMaxFrame;
        }];
        
        [self layoutContentViews];
        
        [self removeGestureRecognizer:self.panGesture];
        [self.hotButton addGestureRecognizer:self.panGesture];
    }else{
        
        
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.frame = self.contentMinFrame;
            self.frame = self.orginFrame;
            self.hotButton.frame = self.bounds;
            [self setBackgroundColor:[UIColor clearColor]];
            
        } completion:^(BOOL finished) {
           
            [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }];
        
        [self addGestureRecognizer:self.panGesture];
        [self.hotButton removeGestureRecognizer:self.panGesture];
        
    }
    
    if (self.clickBlock) {
        self.clickBlock(self,self.hotPlace);
    }
}


////判断某个点在不在 某个视图上
//+ (BOOL)point:(CGPoint)point isInView:(UIView *)view{
//    
//    
//    CGFloat x = point.x;
//    CGFloat y = point.y;
//    CGFloat w = view.frame.size.width;
//    CGFloat h = view.frame.size.height;
//
//    BOOL isOn = NO;
//    if (x > 0 && y > 0 && x < w && y < h) {
//        isOn = YES;
//    }
//    return isOn;
//}



- (void)makeViewInSuper:(UIView *)view{
    
    CGFloat x = view.frame.origin.x;
    CGFloat y = view.frame.origin.y;
    CGFloat w = view.frame.size.width;
    CGFloat h = view.frame.size.height;
    
    if (x < 0 && y < 0) {
        [UIView animateWithDuration:0.5 animations:^{
            view.frame = CGRectMake(5, 5 , w, h);
        }];
    }else if (x + w > view.superview.bounds.size.width && y + h > view.superview.bounds.size.height){
        
        [UIView animateWithDuration:0.5 animations:^{
            view.frame = CGRectMake(view.superview.bounds.size.width - w - 5, view.superview.bounds.size.height - h -5 , w, h);
        }];
        
    }else if (x < 0 && y + h > view.superview.bounds.size.height) {
        [UIView animateWithDuration:0.5 animations:^{
            view.frame = CGRectMake(5, view.superview.bounds.size.height - h -5 , w, h);
        }];
    }else if (x + w > view.superview.bounds.size.width && y < 0){
        
        [UIView animateWithDuration:0.5 animations:^{
            view.frame = CGRectMake(view.superview.bounds.size.width - w - 5, 5, w, h);
        }];
        
    }else if (x < 0) {
        [UIView animateWithDuration:0.5 animations:^{
            view.frame = CGRectMake(5, y , w, h);
        }];
        
    }else if (x + w > view.superview.bounds.size.width){
        
        [UIView animateWithDuration:0.5 animations:^{
            view.frame = CGRectMake(view.superview.bounds.size.width - w - 5, y, w, h);
        }];
        
    }else if (y < 0 ) {
        [UIView animateWithDuration:0.5 animations:^{
            view.frame = CGRectMake(x, 5 , w, h);
        }];
    }else if (y + h > view.superview.bounds.size.height){
        [UIView animateWithDuration:0.5 animations:^{
            view.frame = CGRectMake(x, view.superview.bounds.size.height - h -5 , w, h);
        }];
    }
    

}



@end
