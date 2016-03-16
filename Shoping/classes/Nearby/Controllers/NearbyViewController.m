//
//  NearbyViewController.m
//  GlobalShoping
//
//  Created by scjy on 16/3/15.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "NearbyViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "PullingRefreshTableView.h"
#import "ShopModel.h"
#import "ShopTableViewCell.h"


@interface NearbyViewController ()<PullingRefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    //定义请求的页面
    NSInteger _pageCount;
    
}

@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, assign) BOOL refreshing;  //是否刷新
@property (nonatomic, strong) NSMutableArray *dataArray; //存放数据


@end

@implementation NearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _pageCount = 1;
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    
    //网络请求
    [self requestData];

   
    
}

//开始网络请求
- (void)requestData {
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger GET:[NSString stringWithFormat:@"%@&pageNum=%ld",kShop, _pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responDic = responseObject;
        NSArray *datasArray = responDic[@"datas"];
        for (NSDictionary *dic in datasArray) {
            ShopModel *model = [[ShopModel alloc] initWithDistionary:dic];
            [self.dataArray addObject:model];
        }
        
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    
}


#pragma mark -------------------------- 协议方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    
    cell.shopModel = self.dataArray[indexPath.row];
    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView {
    _pageCount = 1;
    self.refreshing = YES;
    [self performSelector:@selector(requestData) withObject:nil afterDelay:1.0];
}


//上拉加载
-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView {
    _pageCount += 1;
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

#pragma mark ---------------------- 懒加载
-(NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

-(PullingRefreshTableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 2, kWidth, kHeight - 4) pullingDelegate:self];
        self.tableView.rowHeight = 250;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
    
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
