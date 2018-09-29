//
//  ANLoadButton.h
//  ALLoadingView
//
//  Created by AnRu on 2018/8/24.
//  Copyright © 2018年 asm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ANLoadResultType) {
    ANLoadNormal,
    ANLoadSuccess,
    ANLoadError
};

@interface ANLoadButton : UIControl
@property(nullable, nonatomic) NSString *text;
@property(nullable, nonatomic) UIColor *textColor;
@property(nonatomic) UIEdgeInsets edgeInsets;

@property(nullable, nonatomic, readonly, strong) UILabel *titleLabel;

- (void)show:(ANLoadResultType)type;

@end
