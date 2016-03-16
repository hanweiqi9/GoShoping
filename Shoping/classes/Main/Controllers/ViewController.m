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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setBackgroundImage:[UIImage imageNamed:@"main_search_bg.9"] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor cyanColor];
    button.frame = CGRectMake(15, kHeight /3 + 5, kWidth - 30, 30);
    [self.HeadView addSubview:button];
    
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftbutton.frame = CGRectMake(0, kHeight/3+ 40, kWidth/2, kWidth/3);
    leftbutton.tag = 0;
    leftbutton.backgroundColor = [UIColor cyanColor];
    [self.HeadView addSubview:leftbutton];
    

    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightbutton.frame = CGRectMake(kWidth/2, kHeight/3+ 40, kWidth/2, kWidth/3);
    rightbutton.tag = 1;
    rightbutton.backgroundColor = [UIColor grayColor];
    [self.HeadView addSubview:rightbutton];
    
    for (int i = 0 ; i < 4; i++) {
        UIButton *fourButton = [UIButton buttonWithType:UIButtonTypeSystem];
        fourButton.frame = CGRectMake(kWidth/4*i+5,kHeight/3+kWidth/3 + 45, kWidth/4-10, kWidth/4-10);
        fourButton.backgroundColor = [UIColor cyanColor];
        [self.HeadView addSubview:fourButton];
    }
    
    
    // 在你周围
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/4-5, kHeight/3+kWidth/3 + kWidth /4 + 54, kWidth /2 + 10, 2)];
//    titleView.backgroundColor = [UIColor redColor];
    titleView.image = [UIImage imageNamed:@"icon_tblack_a"];
    [self.HeadView addSubview:titleView
     ];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/5*2,kHeight/3+kWidth/3 + kWidth /4 + 40, kWidth/5,kWidth/13)];
    titleL.text = @"在你周围";
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.backgroundColor = [UIColor whiteColor];
    titleL.font = [UIFont systemFontOfSize:15.0];
    [self.HeadView addSubview:titleL];
    
    UIButton *youButton = [UIButton buttonWithType:UIButtonTypeSystem];
    youButton.backgroundColor = [UIColor yellowColor];
    youButton.frame = CGRectMake(5, kHeight/3+kWidth/3 + kWidth /4 + 40 + kWidth/13, kWidth / 2 + 30, kWidth/2);
    [self.HeadView addSubview:youButton];
    
    UIButton *storeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    storeButton.backgroundColor = [UIColor cyanColor];
    storeButton.frame = CGRectMake(kWidth /2+40, kHeight/3+kWidth/3 + kWidth /4 + 40 + kWidth/13, kWidth / 2 - 50, kWidth /4-3);
    [self.HeadView addSubview:storeButton];
    
    
    UIButton *youhuiButton = [UIButton buttonWithType:UIButtonTypeSystem];
    youhuiButton.backgroundColor = [UIColor yellowColor];
    youhuiButton.frame = CGRectMake(kWidth /2+40, kHeight/3+kWidth/3 + kWidth /4*2 + 42 + kWidth/13, kWidth / 2 - 50, kWidth /4-3);
    [self.HeadView addSubview:youhuiButton];
    
    //每日精选
    UIImageView *goodView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/4-5, kHeight/3+kWidth/3 + kWidth /4*2 + 53 + kWidth/13 + kWidth /4, kWidth /2 + 10, 2)];
    //    titleView.backgroundColor = [UIColor redColor];
    goodView.image = [UIImage imageNamed:@"icon_tblack_a"];
    [self.HeadView addSubview:goodView
     ];
    UILabel *titleLgood = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/5*2,kHeight/3+kWidth/3 + kWidth /4*2 + 45 + kWidth/13 + kWidth /4, kWidth/5,kWidth/13)];
    titleLgood.text = @"每日精选";
    titleLgood.textAlignment = NSTextAlignmentCenter;
    titleLgood.backgroundColor = [UIColor whiteColor];
    titleLgood.font = [UIFont systemFontOfSize:15.0];
    [self.HeadView addSubview:titleLgood];
    
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
        _HeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight/3+kWidth/3 + kWidth /4*2 + 55 + kWidth/13 + kWidth /4)];
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
