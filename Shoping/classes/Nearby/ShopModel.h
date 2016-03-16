//
//  ShopModel.h
//  GlobalShoping
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopModel : NSObject
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *mallId;
@property (nonatomic, strong) NSString *mallName;
@property (nonatomic, strong) NSString *mallPicUrl;
@property (nonatomic, strong) NSString *mallThumbUrl;

- (instancetype)initWithDistionary:(NSDictionary *)dic;

@end
