//
//  MSLocationTool.h
//  Nongji4S
//
//  Created by mengsi on 2017/8/31.
//  Copyright © 2017年 mengsi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import <CoreLocation/CoreLocation.h>


typedef void(^ResultCityBlock)(CLLocation *location,CLPlacemark *pl,NSString *error);


@interface MSLocationTool : NSObject


MSSingletonH(MSLocationTool)

-(void)getCurrentLOcation:(ResultCityBlock)block;


@end
