//
//  JNReportHeadModel.h
//  JNReportViewTest
//
//  Created by liuny on 2017/3/3.
//  Copyright © 2017年 szjn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNReportHeadModel : NSObject
@property (nonatomic, strong) NSString *headTitle;
@property (nonatomic, strong) NSString *nameDetail;
@property (nonatomic, strong) NSArray *nextLevelHeads; //下一层级表头数据，存放的是ReportHeadModel类型

//没有子级
-(instancetype)initWithTitle:(NSString *)title;
//titleArray为字符串数组
-(instancetype)initWithTitle:(NSString *)title childrenLevel:(NSArray *)titleArray;
//objChildrens为JNReportHeadModel对象数组
-(instancetype)initWithTitle:(NSString *)title objChildrens:(NSArray *)objChildrens;
@end
