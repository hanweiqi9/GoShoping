//
//  DiscoverViewController.m
//  GlobalShoping
//
//  Created by scjy on 16/3/15.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

//发现 热门
#define kHot @"http://api.gjla.com/app_admin_v400/api/subject/list?pageSize=8&cityId=391db7b8fdd211e3b2bf00163e000dce"

#define kMatch @"http://api.gjla.com/app_admin_v400/api/collocation/list?styleId=&pageSize=8&cityId=bd21203d001c11e4b2bf00163e000dce&userId=fe8d0970f7d4469bb6a8d5fbb1a2bb6f"

#import "DiscoverViewController.h"
#import "VOSegmentedControl.h"
#import "MatchViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "HotTableViewCell.h"
#import "MatchTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PullingRefreshTableView.h"
#import "ActivityViewController.h"

@interface DiscoverViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    NSInteger _pageNum;
}
@property(nonatomic,strong) VOSegmentedControl *segmentedController;
@property(nonatomic,strong) UIView *firstView;
@property(nonatomic,strong) PullingRefreshTableView *tableView;
@property(nonatomic,strong) PullingRefreshTableView *twoView;
@property(nonatomic,strong) NSMutableArray *allArray;
@property(nonatomic,strong) NSMutableArray *matchArray;
@property(nonatomic,strong) NSMutableArray *titleArray;
@property(nonatomic,assign) BOOL refreshing;


@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar.topItem setTitleView:self.segmentedController ];
//    [self selectChange];
//    [self.view addSubview:self.firstView];
     self.view.backgroundColor = [UIColor redColor];
    _pageNum = 1;
    [self requestLoad];
    [self matchRequest];
    [self.view addSubview:self.tableView];
    [self.firstView addSubview:self.twoView];
    [self.tableView launchRefreshing];
    [self.twoView launchRefreshing];
    [self.tableView registerNib:[UINib nibWithNibName:@"HotTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.twoView registerNib:[UINib nibWithNibName:@"MatchTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];

}

-(void)requestLoad{
    AFHTTPSessionManager *sessageManager = [AFHTTPSessionManager manager];
    sessageManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [sessageManager GET:[NSString stringWithFormat:@"%@&pageNum=%ld",kHot,_pageNum] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        NSDictionary *dic = responseObject;
        NSMutableArray *array = dic[@"datas"];
        if (self.refreshing) {
            if (self.allArray.count > 0) {
                [self.allArray removeAllObjects];
            }
        }
        for (NSDictionary *dict in array) {
            [self.allArray addObject:dict[@"subjectMainPicUrl"]];
//            NSLog(@"%@",self.allArray);
        }
        [self.tableView reloadData];
        [self.tableView tableViewDidFinishedLoading];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

-(void)matchRequest{
    AFHTTPSessionManager *message = [AFHTTPSessionManager manager];
    message.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [message GET:[NSString stringWithFormat:@"%@&pageNum=%ld",kMatch,_pageNum] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        NSDictionary *dic = responseObject;
        NSMutableArray *array = dic[@"datas"];
        if (self.refreshing) {
            if (self.matchArray.count > 0) {
                [self.matchArray removeAllObjects];
            }
        }
        for (NSDictionary *dict in array) {
            [self.matchArray addObject:dict[@"mainPicUrl"]];
            [self.titleArray addObject:dict[@"title"]];
        }
        [self.twoView reloadData];
        [self.twoView tableViewDidFinishedLoading];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark-------------Lazy

-(NSMutableArray *)allArray{
    if (_allArray == nil) {
        self.allArray = [NSMutableArray new];
    }
    return _allArray;
}

-(NSMutableArray *)matchArray{
    if (_matchArray == nil) {
        self.matchArray = [NSMutableArray new];
    }
    return _matchArray;
}

-(NSMutableArray *)titleArray{
    if (_titleArray == nil) {
        self.titleArray = [NSMutableArray new];
    }
    return _titleArray;
}
-(PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
        self.tableView.pullingDelegate = self;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 298;
        
    }
    return _tableView;
}

-(PullingRefreshTableView *)twoView{
    if (_twoView == nil) {
        self.twoView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) pullingDelegate:self];
        self.twoView.dataSource = self;
        self.twoView.delegate = self;
        self.twoView.rowHeight = 310;
    }
    return _twoView;
}

-(VOSegmentedControl *)segmentedController{
    if (_segmentedController == nil) {
        self.segmentedController = [[VOSegmentedControl alloc]initWithSegments:@[@{VOSegmentText:@"热门"},@{VOSegmentText:@"搭配"}]];
        self.segmentedController.contentStyle = VOContentStyleTextAlone;
        self.segmentedController.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.segmentedController.frame = CGRectMake(kWidth/4, 0, kWidth/2, 44);
        self.segmentedController.indicatorThickness = 2;
        self.segmentedController.selectedSegmentIndex = 0;
        [self.segmentedController addTarget:self action:@selector(selectChange) forControlEvents:UIControlEventValueChanged];
      
    }
    return _segmentedController;
}


-(void)selectChange{
    if (self.segmentedController.selectedSegmentIndex == 0) {
        [self.firstView removeFromSuperview];
    }else if (self.segmentedController.selectedSegmentIndex == 1){
        self.firstView = [[UIView alloc] initWithFrame:self.view.frame];
        [self.firstView addSubview:self.twoView];
       [self.view addSubview:self.firstView];
       
    }
}


#pragma mark----------UITableViewDelegate/DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = @"http://api.gjla.com/app_admin_v400/";
    if (self.segmentedController.selectedSegmentIndex==0) {
        HotTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",str,self.allArray[indexPath.row]]] placeholderImage:nil];
        
        return cell;
    }
    if (self.segmentedController.selectedSegmentIndex==1) {
        MatchTableViewCell *cell = [self.twoView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.title.text = self.titleArray[indexPath.row];
        [cell.imageTop sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",str,self.matchArray[indexPath.row]]] placeholderImage:nil];
        return cell;
        
    }
    static NSString *cell1 = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell1];
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.segmentedController.selectedSegmentIndex == 0) {
         NSLog(@"%ld",self.allArray.count);
        return self.allArray.count;
       
    }else if (self.segmentedController.selectedSegmentIndex == 1){
        NSLog(@"%ld",self.matchArray.count);
        return self.matchArray.count;
    }
    return self.allArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityViewController *avtivity = [[ActivityViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:avtivity];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}

#pragma mark -------------pullingDelegate

//下拉
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    _pageNum = 1;
    if (self.segmentedController.selectedSegmentIndex == 0) {
        [self performSelector:@selector(requestLoad) withObject:nil afterDelay:1.0];
    }else if (self.segmentedController.selectedSegmentIndex == 1){
        [self performSelector:@selector(matchRequest) withObject:nil afterDelay:1.0];
    }
    
}
//上拉
-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    self.refreshing = NO;
    _pageNum += 1;
    if (self.segmentedController.selectedSegmentIndex == 0) {
        [self performSelector:@selector(requestLoad) withObject:nil afterDelay:1.0];
    }else if (self.segmentedController.selectedSegmentIndex == 1){
        [self performSelector:@selector(matchRequest) withObject:nil afterDelay:1.0];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
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
