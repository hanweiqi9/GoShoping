//
//  ShopDetailViewController.m
//  Shoping
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "ShopDetailViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>

@interface ShopDetailViewController ()

@end

@implementation ShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商场详情";
    self.view.backgroundColor = [UIColor whiteColor];
    //网络请求
    [self requestData];
}


//网络请求
- (void)requestData {
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    [sessionManger GET:[NSString stringWithFormat:@"%@&mallId=%@", kShopDetail, _detailId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}


#pragma mark ---------------------------  协议方法
//返回分区有多少条目

//cell显示内容

//点击方法


//头部视图



#pragma mark ---------------------------- 懒加载



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
