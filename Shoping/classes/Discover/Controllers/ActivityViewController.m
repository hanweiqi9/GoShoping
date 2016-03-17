//
//  ActivityViewController.m
//  Shoping
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#define kActivity @"http://api.gjla.com/app_admin_v400/api/subject/detail?userId=c649ac4bf87f43fea924f52a2639e533&type=1&objId=0fe01e1bb64e40bc8fc2c20a8cf667db&audit="

#import "ActivityViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface ActivityViewController ()
@property(nonatomic,strong) NSDictionary *dict;
@property(nonatomic,strong) UIWebView *webView;


@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 0, kWidth/7, 44);
        [backBtn setImage:[UIImage imageNamed:@"arrow_left_pink"] forState:UIControlStateNormal];
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -60, 0, 5)];
        [backBtn addTarget:self action:@selector(backBtnActivity) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.webView.scalesPageToFit = YES;
//    self.webView.scrollView.contentInset = UIEdgeInsetsMake(240, 0, 0, 0);
    [self.view addSubview:self.webView];
    
//    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, -240, self.webView.frame.size.width, 240)];
//    NSString *str = @"http://api.gjla.com/app_admin_v400/";
//    [image1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",str, self.dict[@"mainPicUrl"]]] placeholderImage:nil];
//    NSLog(@"%@",image1);
//    [self.webView.scrollView addSubview:image1];
    [self requestLoad];
}

#pragma mark-----------Lazy
-(NSDictionary *)dict{
    if (_dict == nil) {
        self.dict = [NSDictionary new];
    }
    return _dict;
}

-(void)requestLoad{
    AFHTTPSessionManager *message = [AFHTTPSessionManager manager];
    message.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [message GET:kActivity parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        NSDictionary *dic = responseObject;
        self.dict = dic[@"datas"];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


-(void)backBtnActivity{
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
