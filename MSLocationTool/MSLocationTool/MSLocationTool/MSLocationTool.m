//
//  MSLocationTool.m
//  Nongji4S
//
//  Created by mengsi on 2017/8/31.
//  Copyright © 2017年 mengsi. All rights reserved.
//

#import "MSLocationTool.h"
#import <UIKit/UIKit.h>
#import "Singleton.h"

#define isIOS(version) ([[UIDevice currentDevice].systemVersion floatValue] >= version)

//SISingletonM(MSLocationTool)

@interface MSLocationTool()<CLLocationManagerDelegate>

@property(nonatomic,copy)ResultCityBlock block;

/** manager */
@property(nonatomic,strong)CLLocationManager *locationManager;


/** 地理编码 */
@property(nonatomic,strong)CLGeocoder *geoC;



@end



@implementation MSLocationTool

MSSingletonM(MSLocationTool)



#pragma mark - 懒加载
-(CLLocationManager *)locationManager
{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
        //获取info.plist里的键值对
        NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
        
        
        if (isIOS(8.0)) {
            
            //获取后台定位描述
            NSString *alwaysStr = infoDict[@"NSLocationAlwaysUsageDescription"];
            NSString *whenUserStr = infoDict[@"NSLocationWhenInUseUsageDescription"];
            
            // 根据开发者的设置 请求定位授权
            if ([alwaysStr length] > 0) {
                [_locationManager requestAlwaysAuthorization];
                
            }else if ([whenUserStr length] > 0){
                [_locationManager requestWhenInUseAuthorization];
                
                NSArray *backModels = infoDict[@"UIBackgroundModes"];
                if (![backModels containsObject:@"location"]) {
                    //前台定位授权，如果想在后台获取位置，需勾选后台模式location update
                    
                }else{
                    if (isIOS(9.0)) {
                        _locationManager.allowsBackgroundLocationUpdates = YES;
                    }
                    
                }
                
                
            }
     
            
        }else{
            // 如果请求的是前台定位授权, 如果想要在后台获取用户位置, 提醒其他开发者, 勾选后台模式location updates
            NSArray *backModes = infoDict[@"UIBackgroundModes"];
            if (![backModes containsObject:@"location"]) {
                NSLog(@"当前授权模式, 如果想要在后台获取位置, 需要勾选后台模式location updates");
            }
            
            
        }
        
        
    }
    
    return _locationManager;
}

-(CLGeocoder *)geoC
{
    if (_geoC == nil) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}

#pragma mark - 方法
-(void)getCurrentLOcation:(ResultCityBlock)block
{
    //记录代码块
    self.block = block;
    
    //获取位置信息
    if ([CLLocationManager locationServicesEnabled]) {
        
        [self.locationManager startUpdatingLocation];
        
    }else{
        self.block(nil, nil, @"定位服务未开启");
        
    }
}

#pragma mark - 代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations lastObject];
    
    //判断位置是否可用
    if (location.horizontalAccuracy >= 0) {
        [self.geoC reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
           
            if (error == nil) {
                CLPlacemark *pl = [placemarks firstObject];
                self.block(location, pl, nil);
                
            }else{
                self.block(location, nil, @"反地理编码失败");
                
            }
            
            
        }];
    }
    
    [manager stopUpdatingLocation];
    
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"用户还未决定");
            break;
        
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"访问受限");
            self.block(nil, nil, @"访问受限");
            break;
        }
         
        //定位关闭 或 对此APP授权未never时调用
        case kCLAuthorizationStatusDenied:
        {
            if ([CLLocationManager locationServicesEnabled]) {
                NSLog(@"定位开启，但被拒");
                self.block(nil, nil, @"被拒绝");
                
            }else{
                NSLog(@"定位关闭，不可用");
                self.block(nil, nil, @"定位关闭，不可用");
            }
            
            break;
        }
            
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"获取前后台定位授权");
            break;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"获取前台定位授权");
            break;
            
            
            
        default:
            break;
    }
}

@end

