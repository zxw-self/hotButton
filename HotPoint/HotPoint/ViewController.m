//
//  ViewController.m
//  HotPoint
//
//  Created by tianshikechuang on 16/7/14.
//  Copyright © 2016年 tianshikechuang. All rights reserved.
//



#import "ViewController.h"
#import "HotView.h"


@interface ViewController ()

@property(nonatomic, strong) HotView * hot;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"直播";
    //    [self.view addSubview:self.tableView];
    
    
    HotView  * hotV =  [HotView hotViewWithFrame:CGRectMake(250, 400, 40, 40)];
    [hotV setClickBlock:^(HotView * hotView,UIButton * button){
        
        [UIView animateWithDuration:0.5 animations:^{
            if (button.selected) {
                hotView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3];
            }
        }];
        
        
        [UIView animateWithDuration:0.5 animations:^{
            
            if (button.selected) {
                button.transform = CGAffineTransformMakeRotation(M_PI_4);
            }else{
                button.transform = CGAffineTransformIdentity;
            }
        }];
        
        
    }];
    [hotV hotViewImage:[UIImage imageNamed:@"add"]];
    
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(100,100, 60, 50)];
//    button.backgroundColor = [UIColor whiteColor];
    [button setImage:[UIImage imageNamed:@"sign.jpg"] forState:UIControlStateNormal];
    [button setTitle:@"签名" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [hotV addViewToHotView:button];
//    
//    [self.view addSubview:button];
    
    UIButton * button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 50)];
//    button1.backgroundColor = [UIColor greenColor];
    [button1 setBackgroundImage:[UIImage imageNamed:@"ss"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [hotV addViewToHotView:button1];
    
//    [self.view addSubview:hotV];
    [self.navigationController.view addSubview:hotV];
//    [self.tabBarController.view addSubview:hotV];
    
    self.hot = hotV;
    self.hot.hidden = NO;
    self.hot.isPanMoview = YES;
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
    self.hot.hidden = !self.hot.hidden;
   
    
}

- (void)buttonAction:(UIButton *)button{
    NSLog(@"%s----",__func__);
    [[self class] aaa];
    [[self class] componentsDateFrom:[NSDate dateWithTimeIntervalSince1970:10000] toDate:nil];
}

+ (void)aaa{
    
    NSDate *now = [NSDate date];
    NSLog(@"now date is: %@", now);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    int year = (int)[dateComponent year];
    int month =(int) [dateComponent month];
    int day = (int)[dateComponent day];
    int hour = (int)[dateComponent hour];
    int minute = (int)[dateComponent minute];
    int second = (int)[dateComponent second];
    
    NSLog(@"year is: %d", year);
    NSLog(@"month is: %d", month);
    NSLog(@"day is: %d", day);
    NSLog(@"hour is: %d", hour);
    NSLog(@"minute is: %d", minute);
    NSLog(@"second is: %d", second);
}

/**
 *  计算两个时间的cha
 *
 *  @param birthDay 开始计算的日子（生日）
 *  @param nowDate  计算截止的日子（今天/可以传nil）
 */
+ (NSDateComponents *)componentsDateFrom:(NSDate *)birthDay toDate:(NSDate *)nowDate{
    
    if (!nowDate) {
        nowDate = [NSDate date];
    }
    
    //用来得到详细的时差
    unsigned int unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSCalendar *calendar = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    NSDateComponents *date = [calendar components:unitFlags fromDate:birthDay toDate:nowDate options:0];
    
   
    if([date year] >0)
    {
        NSLog(@"%@",[NSString stringWithFormat:(@"%ld-%ld-%ld"),(long)[date year],(long)[date month],(long)[date day]]) ;
    }
    else if([date month] >0)
    {
        NSLog(@"%@",[NSString stringWithFormat:(@"0-%ld-%ld"),(long)[date month],(long)[date day]]);
    }
    else if([date day]>0){
        NSLog(@"%@",[NSString stringWithFormat:(@"0-0-%ld"),(long)[date day]]);
    }
    else {
        NSLog(@"%@",@"0-0-0");
    }

    return date;
    
}



@end
