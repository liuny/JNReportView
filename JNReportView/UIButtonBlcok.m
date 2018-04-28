//
//  UIButtonBlcok.m
//  JNReportViewTest
//
//  Created by victoria on 2017/3/9.
//  Copyright © 2017年 szjn. All rights reserved.
//

#import "UIButtonBlcok.h"

@implementation UIButtonBlcok

-(void)initWithBlock:(ClickActionBlock)clickActionBlock for:(UIControlEvents)event{
    
    [self addTarget:self action:@selector(goAction:) forControlEvents:event];
    self.caBlock = clickActionBlock;
}

- (void)goAction:(UIButton *)btn{
    
    self.caBlock(btn);
    
}

@end
