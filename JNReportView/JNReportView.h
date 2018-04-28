//
//  JNReportView.h
//  JNReportViewTest
//
//  Created by liuny on 2017/3/3.
//  Copyright © 2017年 szjn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNReport.h"

@interface JNReportView : UIView
-(instancetype)initFromNib;

-(void)updateData:(NSArray *)tableData rowHeads:(NSArray *)rowHeads columnHeads:(NSArray *)columnHeads size:(CGFloat)fontSize;

-(void)updateData:(NSArray *)tableData rowHeads:(NSArray *)rowHeads columnHeads:(NSArray *)columnHeads andTitle:(NSString *)title size:(CGFloat)fontSize;
//只更新数据，不更新表头
-(void)updateData:(NSArray *)tableData;

- (void)hiddenLoding;
@end
