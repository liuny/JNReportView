//
//  JNRowHeadView.m
//  JNReportViewTest
//
//  Created by liuny on 2017/3/3.
//  Copyright © 2017年 szjn. All rights reserved.
//

#import "JNRowHeadView.h"
#import <objc/runtime.h>
#import "UIButtonBlcok.h"

@interface JNRowHeadView()
{
    JNReportHeadModel *_cellData;
    UIView *_globalLeftItem;
    
    NSMutableArray *_lastLevelView;
}
@end

#define RowMaxWidth     200
#define RowMinWidth     80

#define RowMaxHeight     90
#define RowMinHeight     44

@implementation JNRowHeadView

-(instancetype)initWithModel:(JNReportHeadModel *)model size:(CGFloat)fontSize{
    self = [super init];
    if(self){
        _cellData = model;
        self.backgroundColor = R_ColorSeparator;
        [self layoutCell:_cellData size:fontSize];
        if(_globalLeftItem){
            [_globalLeftItem mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(-R_WidthSeparator);
            }];
        }
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];
    }
    return self;
}

-(NSArray *)widths{
    //获取宽度
    NSMutableArray *widthsArray = [[NSMutableArray alloc] init];
    for(UIView *view in _lastLevelView){
        [widthsArray addObject:[NSNumber numberWithDouble:view.bounds.size.width]];
    }
    return widthsArray;
}

- (void)updateDataWith:(NSArray *)dataWidths{
    if (dataWidths && dataWidths.count==_lastLevelView.count) {
        for(int i = 0; i< _lastLevelView.count; i++){
            UIView *view = _lastLevelView[i];
            CGFloat width =  view.bounds.size.width;
            if (width < [dataWidths[i] floatValue]) {
                width = [dataWidths[i] floatValue]+16;
            }else{
                width = width;
            }
            [view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.lessThanOrEqualTo(@(width));
                make.width.greaterThanOrEqualTo(@(width));
            }];
        }
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];
    }else{
        for(int i = 0; i< _lastLevelView.count; i++){
            UIView *view = _lastLevelView[i];
            CGFloat width =  view.bounds.size.width;
            [view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.lessThanOrEqualTo(@(width));
                make.width.greaterThanOrEqualTo(@(width));
            }];
        }
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];
    }
}

-(UIView *)layoutCell:(JNReportHeadModel *)data size:(CGFloat)fontSize{
    UIView *view = [self cellView:data size:fontSize];
    [self addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    if([data.headTitle isEqualToString:_cellData.headTitle]){
        //第一级表头，设置上的间距为分割线的宽度
        view.backgroundColor = R_ColorSeparator;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.height.equalTo(@0);
        }];
    }else{
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@RowHeight);
//        }];
    }
    //判断是否还有子层级
    if(data.nextLevelHeads.count > 0){
        UIView *leftItem = nil;
        for(JNReportHeadModel *model in data.nextLevelHeads){
            UIView *cell = [self layoutCell:model size:fontSize];
            [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(view.mas_bottom).offset(R_WidthSeparator);
                if(leftItem){
                    //同级cell之间的间距
                    make.left.equalTo(leftItem.mas_right).offset(R_WidthSeparator);
                }
            }];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                if(leftItem == nil){
                    //与上级左对齐（保证上级宽度是子层级宽度之和）
                    make.left.equalTo(cell.mas_left);
                }
            }];
            leftItem=cell;
        }
        
        if(leftItem){
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                //与上级右对齐（保证上级宽度是子层级宽度之和）
                make.right.equalTo(leftItem.mas_right);
            }];
        }
    }else{
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(R_WidthSeparator);
            //设置宽度的最大值和最小值
            make.height.lessThanOrEqualTo(@RowMaxHeight);
            make.height.greaterThanOrEqualTo(@RowMinHeight);
//            make.width.lessThanOrEqualTo(@RowMinWidth);
//            make.width.greaterThanOrEqualTo(@RowMaxWidth);
            if(_globalLeftItem){
                make.left.equalTo(_globalLeftItem.mas_right).offset(R_WidthSeparator);
            }else{
                make.left.equalTo(self.mas_left);
            }
        }];
        
        _globalLeftItem = view;
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
    if(data.headTitle.length > 0){
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = R_ColorRowHeadBG;
        //label相关设置
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:fontSize];
        label.textColor = R_ColorHeadFont;
        label.text = data.headTitle;
        label.numberOfLines = 0;
        [view addSubview:label];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_top).offset(4);
            make.bottom.equalTo(view.mas_bottom).offset(-4);
            make.left.equalTo(view.mas_left).offset(3);
            make.right.equalTo(view.mas_right).offset(-3);
        }];
        if (![data.nameDetail isEqualToString:@""] && ![data.nameDetail isEqualToString:data.headTitle]) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [UIImage imageNamed:@"arrow_down_head"];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.translatesAutoresizingMaskIntoConstraints = NO;
            [view addSubview:imageView];
           
            [label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(view.mas_top).offset(4);
                make.bottom.equalTo(view.mas_bottom).offset(-4);
                make.left.equalTo(view.mas_left).offset(3);
                make.right.equalTo(view.mas_right).offset(-8);
            }];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label.mas_right);
                make.right.equalTo(view.mas_right).offset(0);
                make.top.equalTo(label.mas_top);
                make.width.equalTo(@8);
            }];
            
            UIButtonBlcok *button = [UIButtonBlcok buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"" forState:UIControlStateNormal];
            [button setTitle:@"" forState:UIControlStateSelected];
            
            button.translatesAutoresizingMaskIntoConstraints = NO;
            button.selected = YES;
            [button initWithBlock:^(id obj) {
                button.selected = !button.selected;
                if (button.selected) {
                    [view mas_updateConstraints:^(MASConstraintMaker *make) {
                        label.text = data.headTitle;
                    }];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"InfoNotification" object:nil];
                }else{
                    [view mas_updateConstraints:^(MASConstraintMaker *make) {
                        label.text = data.nameDetail;
                    }];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"InfoNotification" object:nil];
                }
            } for:UIControlEventTouchUpInside];
            [view addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view);
            }];
        }
        rtn = view;
    }
    return rtn;
}

@end
