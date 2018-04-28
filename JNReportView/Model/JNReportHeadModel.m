//
//  JNReportHeadModel.m
//  JNReportViewTest
//
//  Created by liuny on 2017/3/3.
//  Copyright © 2017年 szjn. All rights reserved.
//

#import "JNReportHeadModel.h"

@implementation JNReportHeadModel
-(instancetype)initWithTitle:(NSString *)title{
    self = [super init];
    if(self){
        self.headTitle = title;
        self.nextLevelHeads = nil;
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title childrenLevel:(NSArray *)titleArray{
    self = [super init];
    if(self){
        self.headTitle = title;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for(NSString *childrenTitle in titleArray){
            JNReportHeadModel *model = [[JNReportHeadModel alloc] initWithTitle:childrenTitle];
            [array addObject:model];
        }
        self.nextLevelHeads = array;
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title objChildrens:(NSArray *)objChildrens{
    self = [super init];
    if(self){
        self.headTitle = title;
        self.nextLevelHeads = objChildrens;
    }
    return self;
}
@end
