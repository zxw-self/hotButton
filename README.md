![(logo)](http://a1.qpic.cn/psb?/V14KCrca0Bom6u/eZ7E9uvIqmpK6mHm9eRs2mmKSOz*HHlZ7Dh9yoFisj4!/b/dHEBAAAAAAAA&bo=gACAAAAAAAADByI!&rf=viewer_4)
## hotButton
* An easy way to use load hotButton view

## 介绍
* 这是一个挂再界面上的控件，支持自由拖动 isPanMoview 通过这个属性进行设置
* 这个按钮就是类似于苹果的AssistiveTouch热键按钮一样 可以保留在界面之上


## 使用
* 在使用的时候，要注意的是你把他加在在了哪一个视图上，这会直接影响到使用的效果
* 创建的时候，首先要注意的就是 setClickBlock 里面的事情  我们看到的效果 都是手动设置的
* 我们往里面添加 的时候 要注意调用 [- addViewToHotView:] 这个方法来添加

``
HotView  * hotV =  [HotView hotViewWithFrame:CGRectMake(250, 400, 40, 40)];
[hotV setClickBlock:^(HotView * hotView,UIButton * button){

    // 设置点开之后 界面的背景颜色，默认是透明的
    [UIView animateWithDuration:0.5 animations:^{
        if (button.selected) {
            hotView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3];
        }
    }];

}];

[hotV hotViewImage:[UIImage imageNamed:@"add"]];

hotV.isPanMoview = YES;

UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(100,100, 50, 70)];

[button.titleLabel setFont:[UIFont systemFontOfSize:16]];

button.titleLabel.textAlignment = NSTextAlignmentCenter;

[button setTitleColor:[UIColor colorWithRed:0.1 green:0.5 blue:0.8 alpha:1] forState:UIControlStateNormal];

[button setImage:[UIImage imageNamed:@"sign.jpg"] forState:UIControlStateNormal];

[button setTitle:@"签名" forState:UIControlStateNormal];

[button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 20, 0)];

[button setTitleEdgeInsets:UIEdgeInsetsMake(50, -173, 0, 0)];   // 这个是图片的尺寸有关的

[button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

[hotV addViewToHotView:button];     // 添加按钮 必须要条用这个方法

UIButton * button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];

[button1 setBackgroundImage:[UIImage imageNamed:@"ss"] forState:UIControlStateNormal];

[button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

[hotV addViewToHotView:button1];

//    [self.view addSubview:hotV];

[self.navigationController.view addSubview:hotV];

//    [self.tabBarController.view addSubview:hotV];



``

## HotView.h的介绍
* @property(nonatomic, strong) HotViewDidClick clickBlock;        // 点击的时候调用的block

* @property(nonatomic, assign) BOOL isRotate;                     // 点击的时候是否hot要旋转45°
* @property(nonatomic, assign) BOOL isPanMoview;                  // 是否支持拖动（默认为NO）
* @property(nonatomic, assign) BOOL isRotate;                     // 点击的时候是否hot要旋转45°
* @property(nonatomic, assign) CGFloat gapMax;                    // hot按钮与添加的按钮之间的间隙 (默认为 20)
* @property(nonatomic, assign) CGFloat gapMin;                    // 添加的按钮之间的间隙 (默认为 8)
