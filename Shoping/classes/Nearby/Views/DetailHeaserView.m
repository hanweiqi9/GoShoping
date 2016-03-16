//
//  DetailHeaserView.m
//  Shoping
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 韩苇棋. All rights reserved.
//

#import "DetailHeaserView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation DetailHeaserView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)awakeFromNib{
    self.detailScrollView.contentSize = CGSizeMake(kWidth, 1000);
    
}

-(void)setDataDic:(NSDictionary *)dataDic {



}



@end
