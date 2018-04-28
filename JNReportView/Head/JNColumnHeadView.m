//
//  JNColumnHeadView.m
//  JNReportViewTest
//
//  Created by liuny on 2017/3/3.
//  Copyright © 2017年 szjn. All rights reserved.
//

#import "JNColumnHeadView.h"

@interface JNColumnHeadView()
{
    JNReportHeadModel *_cellData;
    UIView *_globalTopItem;
    
    NSMutableArray *_lastLevelView;
    NSMutableArray *_firstLevelView;
}
@end

#define ColumnWidth  40.0

@implementation JNColumnHeadView

-(instancetype)initWithModel:(JNReportHeadModel *)model size:(CGFloat)fontSize{
    self = [super init];
    if(self){
        _cellData = model;
        self.backgroundColor = R_ColorSeparator;
        [self layoutCell:_cellData size:fontSize];
        if(_globalTopItem){
            [_globalTopItem mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_bottom).offset(-R_WidthSeparator);
            }];
        }
    }
    return self;
}

-(NSArray *)heights{
    //获取高度
    NSMutableArray *heightsArray = [[NSMutableArray alloc] init];
    for(UIView *view in _lastLevelView){
        [heightsArray addObject:[NSNumber numberWithDouble:view.bounds.size.height]];
    }
    return heightsArray;
}

- (void)reSetHeights{
    for(int i = 0; i< _lastLevelView.count; i++){
        UIView *view = _lastLevelView[i];
        [view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.lessThanOrEqualTo(@(40));
            make.height.greaterThanOrEqualTo(@(40));
        }];
    }
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];

}

-(NSArray *)isTotals{
    //获取高度
    NSMutableArray *isTotalsArray = [[NSMutableArray alloc] init];
    for(UIView *view in _lastLevelView){
        for (UIView *view00 in view.subviews) {
            if ([view00 isKindOfClass:[UILabel class]]) {
                NSString *isTotal;
                UILabel *label = (UILabel *)view00;
                NSString *name = label.text;
                if (([name rangeOfString:@"小计"].location !=NSNotFound) || ([name rangeOfString:@"合计"].location !=NSNotFound)) {
                    isTotal = @"1";
                }else{
                    isTotal = @"0";
                }
                [isTotalsArray addObject:isTotal];
            }
        }
    }
    return isTotalsArray;
}


-(NSArray *)cellHeights{
    NSMutableArray *heightsArray = [[NSMutableArray alloc] init];
    for(UIView *view in _firstLevelView){
        [heightsArray addObject:[NSNumber numberWithDouble:view.bounds.size.height]];
    }
    return heightsArray;
}

-(UIView *)layoutCell:(JNReportHeadModel *)data size:(CGFloat)fontSize{
    UIView *view = [self cellView:data size:fontSize];
    [self addSubview:view];
    if([data.headTitle isEqualToString:_cellData.headTitle]){
        //第一级表头，设置左的间距为分割线的宽度
//        view.backgroundColor = R_ColorSeparator;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(R_WidthSeparator);
//            make.width.equalTo(@0);
            make.width.equalTo(@ColumnWidth);
        }];
    }else{
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@ColumnWidth);
        }];
    }
    
    //判断是否还有子层级
    if(data.nextLevelHeads.count > 0){
        UIView *topItem = nil;
        for(JNReportHeadModel *model in data.nextLevelHeads){
            
            UIView *cell = [self layoutCell:model size:fontSize];
            if([data.headTitle isEqualToString:_cellData.headTitle]){
                if(_firstLevelView == nil){
                    _firstLevelView = [[NSMutableArray alloc] init];
                }
                [_firstLevelView addObject:cell];
            }
            [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view.mas_right).offset(R_WidthSeparator);
                if(topItem){
                    //同级cell之间的间距
                    make.top.equalTo(topItem.mas_bottom).offset(R_WidthSeparator);
                }
            }];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                //判断是不是子级的第一个
                if(topItem == nil){
                    //与上级上对齐（保证上级宽度是子层级宽度之和）
                    make.top.equalTo(cell.mas_top);
                }
            }];
            topItem=cell;
        }
        
        if(topItem){
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                //与上级下对齐（保证上级宽度是子层级宽度之和）
                make.bottom.equalTo(topItem.mas_bottom);
            }];
        }
    }else{
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-R_WidthSeparator);
            if(_globalTopItem){
                make.top.equalTo(_globalTopItem.mas_bottom).offset(R_WidthSeparator);
            }else{
                make.top.equalTo(self.mas_top);
            }
        }];
        
        _globalTopItem = view;
        //保存最后一个层级的view，用于获取所需的宽高
        if(_lastLevelView == nil){
            _lastLevelView = [[NSMutableArray alloc] init];
        }
        [_lastLevelView addObject:view];
        return view;
    }
    
    return view;
}


//单个view
-(UIView *)cellView:(JNReportHeadModel *)data size:(CGFloat)fontSize{
    UIView *rtn;
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = R_ColorColumnHeadBG;
    //label相关设置
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = R_ColorHeadFont;
    label.text = data.headTitle;
    if (([label.text rangeOfString:@"小计"].location !=NSNotFound) || ([label.text rangeOfString:@"合计"].location !=NSNotFound)) {
        view.backgroundColor = kGetColor(217, 217, 217);
    }else{
        view.backgroundColor = R_ColorColumnHeadBG;
    }
    label.numberOfLines = 0;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).offset(4);
        make.bottom.equalTo(view.mas_bottom).offset(-4);
        make.left.equalTo(view.mas_left).offset(2);
        make.right.equalTo(view.mas_right).offset(-2);
    }];
    rtn = view;
    return rtn;
}

@end
