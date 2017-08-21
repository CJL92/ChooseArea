//
//  ProvinceModel.h
//  ChooseArea
//
//  Created by 曹进龙 on 2017/8/21.
//  Copyright © 2017年 曹进龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProvinceModel : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSArray  *cities;
@property(nonatomic,strong)NSMutableArray *citiesArr;
@end
