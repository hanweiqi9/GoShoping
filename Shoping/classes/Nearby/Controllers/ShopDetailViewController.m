//
//  ShopDetailViewController.m
//  Shoping
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "ShopDetailViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "PullingRefreshTableView.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface ShopDetailViewController ()<PullingRefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *categoryBtnId;

@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, assign) BOOL refreshing;  //是否刷新
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSDictionary *headerDic;


@end

@implementation ShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商场详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    //网络请求
    [self requestData];

   
}


//网络请求
- (void)requestData {
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    [sessionManger GET:[NSString stringWithFormat:@"%@&mallId=%@", kShopDetail, _detailId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *datasDic = responseObject;
        self.headerDic = datasDic[@"datas"];
        [self configTableViewHeader];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}


#pragma mark ---------------------------  协议方法
//返回分区有多少条目
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

//cell显示内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"idId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    return cell;
}

//点击方法


//头部视图
- (void)configTableViewHeader {
    //图片需要拼接的URl
    NSString *str = @"http://api.gjla.com/app_admin_v400/";
    NSArray *picUrlArray = self.headerDic[@"mallPirUrl"];
    NSString *mallUrl = picUrlArray[0];
    //头部图片
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 2, kWidth -10, kWidth * 0.335)];
    [headerView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",str, mallUrl]] placeholderImage:nil];
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, kWidth * 0.335 + 5, kWidth - 10, 30)];
    titleLabel.text = [NSString stringWithFormat:@"%@",self.headerDic[@"mallName"]];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    //营业时间
    NSString *closeTime = self.headerDic[@"closeTime"];
    NSString *openTime = self.headerDic[@"openTime"];
    UILabel *currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, kWidth * 0.335 + 40, kWidth / 4, 30)];
    currentLabel.text = @"营业时间:";
    currentLabel.textAlignment = NSTextAlignmentCenter;
    currentLabel.textColor = kColor;
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 4 + 85, kWidth * 0.335 + 40, kWidth / 4 + 20, 30)];
    timeLabel.text = [NSString stringWithFormat:@"%@ ~ %@",openTime, closeTime];
    timeLabel.textColor = kColor;
    //距离
    UIButton *distanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    distanceBtn.frame = CGRectMake(100, kWidth * 0.335 + 75, kWidth - 200, 30);
    [distanceBtn setTitle:[NSString stringWithFormat:@"%@ km",self.headerDic[@"distance"]] forState:UIControlStateNormal];
    //设置图片和内容的间距
    [distanceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [distanceBtn setImage:[UIImage imageNamed:@"address_icon"] forState:UIControlStateNormal];
    [distanceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //地址
    UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addressBtn.frame = CGRectMake(20, kWidth * 0.335 + 110, kWidth - 40, 30);
    [addressBtn setTitle:[NSString stringWithFormat:@"%@",self.headerDic[@"address"]] forState:UIControlStateNormal];
    //设置图片和内容的间距
    [addressBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [addressBtn setImage:[UIImage imageNamed:@"address_ico"] forState:UIControlStateNormal];
    [addressBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //入住商户
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, kWidth * 0.335 + 160, kWidth / 3, 2)];
    label1.alpha = 0.5;
    label1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_tblack_a"]];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 3 + 32 , kWidth * 0.335 + 145, kWidth / 3 - 10, 30)];
    label2.text = @"入住商户";
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 1.5 , kWidth * 0.335 + 160, kWidth / 3 - 5, 2)];
    label3.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_tblack_a"]];
    label3.alpha = 0.5;
    for (int i = 0; i < 8; i++) {
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i < 4) {
            button1.frame = CGRectMake(kWidth / 4 * i + 5, kWidth * 0.335 + 180, kWidth / 4 - 10, kWidth / 4 - 10);
            button1.tag = i;
            NSString *imageStr = [NSString stringWithFormat:@"classify%02d",i + 1];
            [button1 setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
            [self.detailView addSubview:button1];
        } else {
            button1.frame = CGRectMake(kWidth / 4 * (i - 4) + 5, kWidth * 0.335 + 180 + kWidth / 4 - 5, kWidth / 4 - 10, kWidth / 4 - 10);
            button1.tag = i;
            NSString *imageStr = [NSString stringWithFormat:@"classify%02d",i + 1];
            [button1 setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
            
            [self.detailView addSubview:button1];
        }
        [button1 addTarget:self action:@selector(classfiyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    
    
    [self.detailView addSubview:label1];
    [self.detailView addSubview:label2];
    [self.detailView addSubview:label3];
    [self.detailView addSubview:addressBtn];
    [self.detailView addSubview:distanceBtn];
    [self.detailView addSubview:timeLabel];
    [self.detailView addSubview:currentLabel];
    [self.detailView addSubview:titleLabel];
    [self.detailView addSubview:headerView];
    self.tableView.tableHeaderView = self.detailView;
    
}


//八个按钮的点击方法
- (void)classfiyBtnAction:(UIButton *)btn {
    //取出按钮的id
    NSMutableArray *categoryArray = self.headerDic[@"category"];
    if (btn.tag) {
        self.categoryBtnId = categoryArray[btn.tag][@"categoryId"];
    }
}


//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView {

    self.refreshing = YES;
    [self performSelector:@selector(requestData) withObject:nil afterDelay:1.0];
}


//上拉加载
-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView {
    self.refreshing = NO;
    [self performSelector:@selector(requestData) withObject:nil afterDelay:1.0];
}

//手指开始拖动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.tableView tableViewDidScroll:scrollView];
}

//手指结束拖动
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}


#pragma mark ---------------------------- 懒加载

-(NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (PullingRefreshTableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 4) pullingDelegate:self];
        self.tableView.rowHeight = 250;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}


-(NSDictionary *)headerDic {
    if (_headerDic == nil) {
        self.headerDic = [NSDictionary dictionary];
    }
    return _headerDic;
}

- (UIView *)detailView{
    if (_detailView == nil) {
        self.detailView = [[UIView alloc] init];
        self.detailView.frame=CGRectMake(0, 10, kWidth, kWidth * 0.335 + 180 + kWidth / 4 + kWidth / 4 - 15);
    }
    return _detailView;
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
