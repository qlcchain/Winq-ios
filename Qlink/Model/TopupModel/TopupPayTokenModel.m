//
//  TopupPayTokenModel.m
//  Qlink
//
//  Created by Jelly Foo on 2019/10/24.
//  Copyright © 2019 pan. All rights reserved.
//

#import "TopupPayTokenModel.h"
#import "QConstants.h"

@implementation TopupPayTokenModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id", @"Hash":@"hash"};
}

- (UIImage *)getPayTokenImage {
    UIImage *img = nil;
    if ([_chain isEqualToString:ETH_Chain]) {
        img = [UIImage imageNamed:[NSString stringWithFormat:@"eth_%@",[_symbol lowercaseString]]];
    } else if ([_chain isEqualToString:QLC_Chain]) {
        img = [UIImage imageNamed:[NSString stringWithFormat:@"qlc_%@",[_symbol lowercaseString]]];
    } else if ([_chain isEqualToString:NEO_Chain]) {
        img = [UIImage imageNamed:[NSString stringWithFormat:@"neo_%@",[_symbol lowercaseString]]];
    } else if ([_chain isEqualToString:EOS_Chain]) {
        img = [UIImage imageNamed:[NSString stringWithFormat:@"eos_%@",[_symbol lowercaseString]]];
    }

    return img;
}

@end
