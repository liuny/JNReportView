//
//  UIButtonBlcok.h
//  JNReportViewTest
//
//  Created by victoria on 2017/3/9.
//  Copyright © 2017年 szjn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickActionBlock) (id obj);

@interface UIButtonBlcok : UIButton

@property (nonatomic,strong)ClickActionBlock caBlock;

- (void)initWithBlock:(ClickActionBlock)clickBlock for:(UIControlEvents)event;

@end
