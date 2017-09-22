# MSLocationTool
封装定位工具类，block传值

调用：

```
[[MSLocationTool sharedMSLocationTool] getCurrentLOcation:^(CLLocation *location, CLPlacemark *pl, NSString *error) {
if ([error length] > 0) {
NSLog(@"定位有错误-->%@",error);

}else{
//pl.locality城市名
[self.locationBtn setTitle:pl.locality forState:UIControlStateNormal];
}


}];
```

