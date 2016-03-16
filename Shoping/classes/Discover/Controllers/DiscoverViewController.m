//
//  DiscoverViewController.m
//  GlobalShoping
//
//  Created by scjy on 16/3/15.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#define kHot @"http://api.gjla.com/app_admin_v400/api/subject/list?pageSize=8&cityId=391db7b8fdd211e3b2bf00163e000dce&pageNum=1"
//"http://api.gjla.com/app_admin_v400/api/collocation/list?styleId=&pageSize=8&cityId=bd21203d001c11e4b2bf00163e000dce&userId=fe8d0970f7d4469bb6a8d5fbb1a2bb6f&pageNum=1"

#import "DiscoverViewController.h"
#import "VOSegmentedControl.h"
#import "MatchViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "HotTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DiscoverViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) VOSegmentedControl *segmentedController;
@property(nonatomic,strong) UIView *firstView;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *allArray;


@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar.topItem setTitleView:self.segmentedController ];
//    [self selectChange];
//    [self.view addSubview:self.firstView];
     self.view.backgroundColor = [UIColor redColor];
    [self requestLoad];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"HotTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

-(void)requestLoad{
    AFHTTPSessionManager *sessageManager = [AFHTTPSessionManager manager];
    sessageManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [sessageManager GET:kHot parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dic = responseObject;
        NSMutableArray *array = dic[@"datas"];
        for (NSDictionary *dict in array) {
            [self.allArray addObject:dict[@"subjectMainPicUrl"]];
            NSLog(@"%@",self.allArray);
        }
        [self.tableView reloadData];
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

-(UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 298;
        
    }
    return _tableView;
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
        self.firstView.backgroundColor = [UIColor blueColor];
       [self.view addSubview:self.firstView];
    }
}


#pragma mark----------UITableViewDelegate/DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString *str = @"http://api.gjla.com/app_admin_v400/";

        [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",str,self.allArray[indexPath.row]]] placeholderImage:nil];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allArray.count;
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
