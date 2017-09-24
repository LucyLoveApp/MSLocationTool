//
//  ViewController.m
//  MSLocationTool
//
//  Created by mengsi on 2017/9/22.
//  Copyright © 2017年 mengsi. All rights reserved.
//

#import "ViewController.h"
#import "MSLocationTool.h"


//存储到本地的 地址（）城市名
#define     CITY_KEY        @"LocationCityKey"
//颜色
#define MSRGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0  blue:(b)/255.0  alpha:1.0]


@interface ViewController ()

/** 定位 */
@property(nonatomic,strong)UIButton *locationBtn;

@end

@implementation ViewController


#pragma mark - 生命周期
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //定位
    NSString *location = [[NSUserDefaults standardUserDefaults] objectForKey:CITY_KEY];
    
    if ([location length] > 0) {
        //更新数据
        [self updateLocation];
        
    }else{
        //第一次启用定位
        [self setupLocation];
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupUI];
    
}


#pragma mark - UI
-(void)setupUI
{
    [self.locationBtn setFrame:CGRectMake(20, 80, self.view.frame.size.width - 20*2, 50)];
    [self.view addSubview:self.locationBtn];
}

#pragma mark - location
-(void)setupLocation
{
    //先判断
    NSString *location = [[NSUserDefaults standardUserDefaults] objectForKey:CITY_KEY];
    
    //用户已选择城市
    if ([location length] > 0) {
        [self.locationBtn setTitle:location forState:UIControlStateNormal];
        
    }else{
        //用户未选择城市，使用当前定位
        [[MSLocationTool sharedMSLocationTool] getCurrentLOcation:^(CLLocation *location, CLPlacemark *pl, NSString *error) {
            if ([error length] > 0) {
                NSLog(@"定位有错误-->%@",error);
                
            }else{
                [self.locationBtn setTitle:pl.locality forState:UIControlStateNormal];
                
                [[NSUserDefaults standardUserDefaults] setValue:pl.locality forKey:CITY_KEY];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            
            
        }];
        
    }
    
    
}

-(void)updateLocation
{
    NSString *btnText = self.locationBtn.titleLabel.text;
    NSString *location = [[NSUserDefaults standardUserDefaults] objectForKey:CITY_KEY];
    
    //用户选择了新城市城市
    if ([location length] > 0 && ![btnText isEqualToString:location]) {
        [self.locationBtn setTitle:location forState:UIControlStateNormal];
        
    }
}

#pragma mark - 懒加载
-(UIButton *)locationBtn
{
    if (_locationBtn == nil) {
        _locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_locationBtn setBackgroundImage:[UIImage imageNamed:@"locationBackground"] forState:UIControlStateNormal];
        //默认北京
        [_locationBtn setTitle:@"北京" forState:UIControlStateNormal];
        _locationBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_locationBtn setTitleColor:MSRGBColor(103, 103, 103) forState:UIControlStateNormal];
        [_locationBtn setImage:[UIImage imageNamed:@"Location"] forState:UIControlStateNormal];
        [_locationBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        [_locationBtn setImageEdgeInsets:UIEdgeInsetsMake(8, 0, 8, 10)];
        _locationBtn.adjustsImageWhenHighlighted = NO;
    }
    
    return _locationBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
