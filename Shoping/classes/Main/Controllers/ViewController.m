//
//  ViewController.m
//  Shoping
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIView *HeadView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageC;


@property (nonatomic, strong) NSMutableArray *turnArray;
@property (nonatomic, strong) NSMutableArray *cellArray;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor =[UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:0.5];
    
    [self.view addSubview:self.tableview];
    
    //设置区头
//    [self headSettingView];
    
    //数据请求
    [self getMainData];
    [self getCellData];
}


#pragma mark ---------- 数据请求
- (void)getMainData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manger GET:kTurnPicture parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSArray *data = dic[@"datas"];
        for (NSDictionary *dics in data) {
            [self.turnArray addObject:dics];
        }
        [self headSettingView];
        [self.tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)getCellData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manger GET:kEverdGood parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSArray *data = dic[@"datas"];
        for (NSDictionary *dics in data) {
            [self.cellArray addObject:dics[@"mainPicUrl"]];
        }
        [self.tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark ---------- 设置区头
- (void)headSettingView{
    
    self.pageC.numberOfPages = self.turnArray.count;
    for (int i = 0; i < self.turnArray.count; i++) {
        self.scrollView.contentSize = CGSizeMake(kWidth * self.turnArray.count, kHeight / 3);
        UIImageView *images = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth*i, 0, kWidth, kHeight/3)];
        images.backgroundColor = [UIColor redColor];
        [images sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.gjla.com/app_admin_v400/%@",self.turnArray[i][@"mainPicUrl"]]] placeholderImage:nil];
        [self.scrollView addSubview:images];
    }
    [self.HeadView addSubview:self.scrollView];
    [self.HeadView addSubview:self.pageC];
}
//圆点随着滑动变化
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1{
    CGFloat pagenum = self.scrollView.frame.size.width;
    CGPoint offset =  self.scrollView.contentOffset;
    NSInteger num = offset.x / pagenum;
    self.pageC.currentPage = num;
}

#pragma mark ---------- 代理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *string = @"IOS";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:string];
    }
    if (indexPath.row < self.cellArray.count) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, kWidth, kHeight/3-10)];
        [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.gjla.com/app_admin_v400/%@",self.cellArray[indexPath.row]]] placeholderImage:nil];
        [cell addSubview:imageview];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHeight/3;
}

#pragma mark --------- 懒加载
- (UITableView *)tableview{
    if (_tableview == nil) {
        self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kWidth, kHeight - 104) style:UITableViewStylePlain];

        self.tableview.dataSource = self;
        self.tableview.delegate = self;
//        self.tableview.backgroundColor = [UIColor cyanColor];
        self.tableview.tableHeaderView = self.HeadView;
    }
    return _tableview;
}

- (UIView *)HeadView{
    if (_HeadView == nil) {
        _HeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight / 2)];
    }
    return _HeadView;
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight/3)];
//        self.scrollView.backgroundColor = [UIColor orangeColor];
        self.scrollView.delegate = self;
        //显示滚动条
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        //垂直滑动
        self.scrollView.alwaysBounceHorizontal = NO;
        //整屏滑动
        self.scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}
- (UIPageControl *)pageC{
    if (_pageC == nil) {
        self.pageC = [[UIPageControl alloc] initWithFrame:CGRectMake(kWidth / 3, kHeight / 3 - 30, kWidth / 3, 30)];
    }
    return _pageC;
}

- (NSMutableArray *)turnArray{
    if (_turnArray == nil) {
        self.turnArray = [NSMutableArray new];
    }
    return _turnArray;
}

- (NSMutableArray *)cellArray{
    if (_cellArray == nil) {
        self.cellArray = [NSMutableArray new];
    }
    return _cellArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
