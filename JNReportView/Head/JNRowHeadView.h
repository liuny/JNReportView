//
//  JNRowHeadView.h
//  JNReportViewTest
//
//  Created by liuny on 2017/3/3.
//  Copyright © 2017年 szjn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNReport.h"

@interface JNRowHeadView : UIView

@property (nonatomic, copy) void (^rowHeaderTapAction)(id sender);

-(instancetype)initWithModel:(JNReportHeadModel *)model size:(CGFloat)fontSize;

-(NSArray *)widths;
- (void)updateDataWith:(NSArray *)dataWidths;

@end
