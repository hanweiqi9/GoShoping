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
#import "FFNavbarMenu.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,FFNavbarMenuDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIView *HeadView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageC;
@property (nonatomic, strong) UIView *blackView;

@property(nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSMutableArray *turnArray;
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) NSMutableArray *toolArray;
@property (nonatomic, strong) NSDictionary *youDic;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSString *cityId;

@property (nonatomic, strong) FFNavbarMenu *menu;
@property (nonatomic, assign) NSInteger numberMenu;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor =[UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
    [self.view addSubview:self.tableview];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上海" style:UIBarButtonItemStylePlain target:self action:@selector(SelectCityName:)];
    
    
    //设置区头
//    [self headSettingView];
    
    //数据请求
    //广告
    [self getMainData];
    //cell
    [self getCellData];
    [self toolViewData];
    [self youData];
    [self startTimer];
}


#pragma mark ---------- 数据请求
- (void)getMainData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manger GET:kTurnData parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSArray *data = dic[@"datas"];
        for (NSDictionary *dics in data) {
            [self.turnArray addObject:dics];
        }

        [self.tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)getCellData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manger GET:kEverdGood parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"%@",downloadProgress);
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

- (void)toolViewData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manger GET:@"http://api.gjla.com/app_admin_v400/api/coupon/recommend?appVersion=4.2.0&cityId=391db7b8fdd211e3b2bf00163e000dce" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSArray *dataArray = dic[@"datas"];
        for (NSDictionary *dics in dataArray) {
            [self.toolArray addObject:dics];
        }
        [self.tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)youData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manger GET:@"http://api.gjla.com/app_admin_v400/api/home/LBSMall?longitude=112.426965&districtId=&latitude=34.618707&cityId=391db7b8fdd211e3b2bf00163e000dce&userId=fe8d0970f7d4469bb6a8d5fbb1a2bb6f" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //        NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        self.youDic = dic[@"datas"];
        [self headSettingView];
        [self.tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

}

- (void)getCityData{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manger GET:@"http://api.gjla.com/app_admin_v400/api/city/cityList" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //        NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        self.cityArray = dic[@"datas"];
        [self headSettingView];
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
    button.tag = 0;
    button.backgroundColor = [UIColor cyanColor];
    button.frame = CGRectMake(15, kHeight /3 + 5, kWidth - 30, 30);
    [self.HeadView addSubview:button];
    
    for (int i = 1 ; i < 6; i++) {
        UIButton *toolButton = [UIButton buttonWithType:UIButtonTypeSystem];
        NSString *sting = [NSString stringWithFormat:@"http://api.gjla.com/app_admin_v400/%@",self.toolArray[i-1][@"recommendPic"]];
        if (i < 3) {
            toolButton.frame = CGRectMake(kWidth/ 2 * (i -1), kHeight/3+ 40, kWidth/2, kWidth/3);
            toolButton.tag = i;
            UIImageView *imageview= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, toolButton.frame.size.width, toolButton.frame.size.height)];
            [imageview sd_setImageWithURL:[NSURL URLWithString:sting] placeholderImage:nil];
            [toolButton addSubview:imageview];
            [self.HeadView addSubview:toolButton];
        }if (i > 2 && i < 6) {
            toolButton.frame = CGRectMake(kWidth/4*(i- 3)+5,kHeight/3+kWidth/3 + 45, kWidth/4-10, kWidth/4-10);
            toolButton.tag = i;
            UIImageView *imageview= [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, toolButton.frame.size.width - 5, toolButton.frame.size.height - 5)];
            [imageview sd_setImageWithURL:[NSURL URLWithString:sting] placeholderImage:nil];
            [toolButton addSubview:imageview];
            [self.HeadView addSubview:toolButton];
            
        }
    }
    UIButton *guButton = [UIButton buttonWithType:UIButtonTypeSystem];
    guButton.frame = CGRectMake(kWidth/4*3+5,kHeight/3+kWidth/3 + 51, kWidth/4-10, kWidth/4-15);
    guButton.tag = 6;
    [guButton setBackgroundImage:[UIImage imageNamed:@"home_more.jpg"] forState:UIControlStateNormal];
    [self.HeadView addSubview:guButton];


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
    youButton.tag = 7;
    [youButton addTarget:self action:@selector(MainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *string =[NSString stringWithFormat:@"http://api.gjla.com/app_admin_v400/%@",self.youDic[@"mainPicUrl"]];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, youButton.frame.size.width, youButton.frame.size.height)];
    [imageview sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:nil];
    [youButton addSubview:imageview];
    [self.HeadView addSubview:youButton];
    for (int i = 0; i < 2; i++) {
        UIButton *Button = [UIButton buttonWithType:UIButtonTypeSystem];
        Button.backgroundColor = [UIColor orangeColor];
        Button.frame = CGRectMake(kWidth /2+40, kHeight/3+kWidth/3 + kWidth /4*(i+1) + 40 + kWidth/13, kWidth / 2 - 50, kWidth /4-3);
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(Button.frame.size.width/4, Button.frame.size.height- 25,Button.frame.size.width/2, 20)];
           title.textColor = [UIColor whiteColor];
            title.textAlignment = NSTextAlignmentCenter;
        UIImageView *store = [[UIImageView alloc] initWithFrame:CGRectMake( Button.frame.size.width/3, 10, Button.frame.size.width/3, Button.frame.size.height / 2 )];
        if (i == 0) {
            title.text = @"附近商城";
            store.backgroundColor = [UIColor orangeColor];
             store.image =[UIImage imageNamed:@"nearby_mall_icon"];
        }
        if (i == 1) {
            title.text = @"附近优惠";
            store.image =[UIImage imageNamed:@"nearby_coupon_icon"];
            Button.backgroundColor = [UIColor colorWithRed:168.0/255.0  green:138/255.0 blue:250.0/255.0 alpha:1.0];
        }
        [Button addSubview:title];
  
        [Button addSubview:store];
        Button.tag = i + 8;
        [self.HeadView addSubview:Button];
    }
    
    
    
    //每日精选
    UIImageView *goodView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/4-5, kHeight/3+kWidth/3 + kWidth /4*2 + 59 + kWidth/13 + kWidth /4, kWidth /2 + 10, 2)];
    //    titleView.backgroundColor = [UIColor redColor];
    goodView.image = [UIImage imageNamed:@"icon_tblack_a"];
    [self.HeadView addSubview:goodView
     ];
    UILabel *titleLgood = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/5*2,kHeight/3+kWidth/3 + kWidth /4*2 + 47 + kWidth/13 + kWidth /4, kWidth/5,kWidth/13)];
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

- (void)startTimer{
    
    //如果定时器存在的话， 不在执行
    if (_timer != nil) {
        return;
    }
    self.timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(rollScreen) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}
//每两秒执行一次图片自动轮播
- (void)rollScreen{
    if (self.turnArray.count > 0) {
        //当前页 +1
        //self.idArray.count的元素可能为0，当0时对取余的时候，没有意义
        NSInteger rollPage = (self.pageC.currentPage + 1) % self.turnArray.count;
        self.pageC.currentPage = rollPage;
        
        CGFloat offset = rollPage * kWidth;
        [self.scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    }
    
}

//当手动滑动scrollview的时候，定时器仍然在计算时间，可能我们刚滑动到下一页，定时器时间刚好有触发，导致当前页面停留不足两秒；
//解决方案：在scrollview开始移动的时候结束定时器；
//移动完毕开启定时器；

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self rollScreen];
    //停止定时器后，将定时器置为nil，再次启动时，定时器才能保证正常执行。
    //    self.timer = nil;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
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
        _HeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight/3+kWidth/3 + kWidth /4*2 + 75 + kWidth/13 + kWidth /4)];
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

- (NSMutableArray *)toolArray{
    if (_toolArray == nil) {
        self.toolArray = [NSMutableArray new];
    }
    return _toolArray;
}

- (NSDictionary *)youDic{
    if (_youDic == nil) {
        self.youDic = [NSDictionary new];
    }
    return _youDic;
}

- (NSMutableArray *)cityArray{
    if (_cityArray == nil) {
        self.cityArray = [NSMutableArray new];
    }
    return _cityArray;
}

//菜单设置
- (FFNavbarMenu *)menu{
    if (_menu == nil) {
        [self getCityData];
        NSMutableArray *itemArray = [NSMutableArray new];
        self.numberMenu = self.cityArray.count;
        for (int i = 0; i < self.cityArray.count; i++) {
            FFNavbarMenuItem *item = [[FFNavbarMenuItem alloc] initWithTitle:self.cityArray[i][@"CityName"] icon:nil];
            [itemArray addObject:item];
        }
        self.menu = [[FFNavbarMenu alloc] initWithItems:itemArray width:kWidth maximumNumberInRow:self.numberMenu];
        self.menu.delegate = self;
        self.menu.backgroundColor = [UIColor whiteColor];
        
    }
    return _menu;
}

- (void)SelectCityName:(id)sender{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    if (self.menu.isOpen) {
        [self.menu dismissWithAnimation:YES];
    } else {
        [self.menu showInNavigationController:self.navigationController];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
