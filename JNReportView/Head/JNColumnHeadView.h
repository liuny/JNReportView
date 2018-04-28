//
//  JNColumnHeadView.h
//  JNReportViewTest
//
//  Created by liuny on 2017/3/3.
//  Copyright © 2017年 szjn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNReport.h"

@interface JNColumnHeadView : UIView

-(instancetype)initWithModel:(JNReportHeadModel *)model size:(CGFloat)fontSize;

//获取表数据高度
-(NSArray *)heights;
//获取表头高度
-(NSArray *)cellHeights;
-(NSArray *)isTotals;

@end
