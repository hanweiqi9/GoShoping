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
#import "DetailHeaserView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ShopDetailViewController ()<PullingRefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *categoryBtnId;
@property (nonatomic, assign) BOOL refreshing;  //是否刷新
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) DetailHeaserView *detailView;
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

    //自定义tableView的头部分区
    [self configTableViewHeader];
}


//网络请求
- (void)requestData {
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    [sessionManger GET:[NSString stringWithFormat:@"%@&mallId=%@", kShopDetail, _detailId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.headerDic = responseObject;
        
        
        
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
    self.detailView = [[DetailHeaserView alloc] initWithFrame:CGRectMake(0, 10, kWidth, kHeight - 300)];
    NSString *str = @"http://api.gjla.com/app_admin_v400/";
    NSArray *picUrlArray = self.headerDic[@"mallPirUrl"];
    NSString *mallUrl = picUrlArray[0];
    //头部图片
    [self.detailView.headerView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",str, mallUrl]] placeholderImage:nil];
    //标题
    self.detailView.titleLabel.text = [NSString stringWithFormat:@"%@",self.headerDic[@"mallName"]];
    //营业时间
    NSString *closeTime = self.headerDic[@"closeTime"];
    NSString *openTime = self.headerDic[@"openTime"];
    self.detailView.timeLabel.text = [NSString stringWithFormat:@"%@ ~ %@",openTime, closeTime];
    //距离
    [self.detailView.distanceBtn setTitle:[NSString stringWithFormat:@"%@",self.headerDic[@"distance"]] forState:UIControlStateNormal];
    //地址
    [self.detailView.addressBtn setTitle:[NSString stringWithFormat:@"%@",self.headerDic[@"address"]] forState:UIControlStateNormal];
    //八个按钮点击事件
    
    

    
    
    self.detailView.backgroundColor = [UIColor yellowColor];
    self.tableView.tableHeaderView = self.detailView;
    
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
