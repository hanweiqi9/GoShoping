
//
//  ShopTableViewCell.m
//  GlobalShoping
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import "ShopTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ShopTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imagePicture;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *addressBtn;


@end


@implementation ShopTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


-(void)setShopModel:(ShopModel *)shopModel {
    [self.imagePicture sd_setImageWithURL:[NSURL URLWithString:shopModel.mallPicUrl] placeholderImage:nil];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",shopModel.mallName];
    [self.addressBtn setTitle:[NSString stringWithFormat:@"%@",shopModel.distance] forState:UIControlStateNormal];

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
