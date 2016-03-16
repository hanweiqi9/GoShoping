//
//  HDefine.h
//  GlobalShoping
//   存放接口
//  Created by scjy on 16/3/15.
//  Copyright © 2016年 王雪娟. All rights reserved.
//

#ifndef HDefine_h
#define HDefine_h

/*   首页数据接口  */
//1.轮播图
#define kTurnPicture @"http://api.gjla.com/app_admin_v400/api/onlineActivity/list?cityId=bd21203d001c11e4b2bf00163e000dce"


//2.每日精选
#define kEverdGood @"http://api.gjla.com/app_admin_v400/api/home/dailyHandpick?pageSize=10&cityId=391db7b8fdd211e3b2bf00163e000dce&pageNum=1"
//3.在你周围
#define kYourAround @"http://api.gjla.com/app_admin_v400/api/home/LBSMall?longitude=112.426965&districtId=&latitude=34.618707&cityId=391db7b8fdd211e3b2bf00163e000dce&userId=fe8d0970f7d4469bb6a8d5fbb1a2bb6f"

/*  附近数据接口  */

//1.附近选择
#define kSelect @"http://api.gjla.com/app_admin_v400/api/city/cityDistrictList?cityId=391db7b8fdd211e3b2bf00163e000dce"

//1.1商场


#define kShop @"http://api.gjla.com/app_admin_v400/api/mall/list?pageSize=10&longitude=112.426904&latitude=34.618939&districtId=&cityId=bd21203d001c11e4b2bf00163e000dce"
#define kShopDetail @"http://api.gjla.com/app_admin_v400/api/mall/mallDetail?userId=fe8d0970f7d4469bb6a8d5fbb1a2bb6f&longitude=112.426904&latitude=34.618939&audit="
#define kBrand @"";









#endif /* HDefine_h */
