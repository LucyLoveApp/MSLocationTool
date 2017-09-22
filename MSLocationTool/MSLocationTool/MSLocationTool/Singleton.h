//
//  Singleton.h
//  Nongji4S
//
//  Created by mengsi on 2017/8/31.
//  Copyright © 2017年 mengsi. All rights reserved.
//

#ifndef Singleton_h
#define Singleton_h




/**
 *  在.h文件中定义的宏，arc
 *
 *  MSSingletonH(name) 这个是宏
 *  + (instancetype)shared##name;这个是被代替的方法， ##代表着shared+name 高度定制化
 * 在外边我们使用 “MSSingletonH(gege)” 那么在.h文件中，定义了一个方法"+ (instancetype)sharedgege",所以，第一个字母要大写
 *
 *  @return 一个搞定好的方法名
 */
#define MSSingletonH(name) + (instancetype)shared##name;


/**
 *  在.m文件中处理好的宏 arc
 *
 *  MSSingletonM(name) 这个是宏,因为是多行的东西，所以每行后面都有一个"\",最后一行除外，
 * 之所以还要传递一个“name”,是因为有个方法要命名"+ (instancetype)shared##name"
 *  @return 单利
 */
#define MSSingletonM(name) \
static id instance_ = nil;\
+ (instancetype)shared##name{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
instance_ = [[self alloc] init];\
});\
return instance_;\
}\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
instance_ = [super allocWithZone:zone];\
});\
return instance_;\
}\
- (id)copyWithZone:(NSZone *)zone{\
return instance_;\
}





#endif /* Singleton_h */
