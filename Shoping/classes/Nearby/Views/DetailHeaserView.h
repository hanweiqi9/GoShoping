//
//  DetailHeaserView.h
//  Shoping
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailHeaserView : UIView
@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *distanceBtn;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;

@property (weak, nonatomic) IBOutlet UIButton *womDressBtn;  //女士服装
@property (weak, nonatomic) IBOutlet UIButton *woShoesBtn;   //女士鞋包
@property (weak, nonatomic) IBOutlet UIButton *appearBeatifulBtn;  //美容美妆
@property (weak, nonatomic) IBOutlet UIButton *watchBtn;  //钟表配饰

@property (weak, nonatomic) IBOutlet UIButton *motherChildBtn;  //母婴亲子

@property (weak, nonatomic) IBOutlet UIButton *wemDressBtn;   //男士服装

@property (weak, nonatomic) IBOutlet UIButton *wemShoesBtn;  //男士鞋包
@property (weak, nonatomic) IBOutlet UIButton *lifeLiveBtn;  //生活家居

@property(nonatomic, strong) NSDictionary *dataDic;  //传来的数据





@end
