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
    
    NSMutableArray *_lastLevelView;     //记录最后一列
    NSMutableArray *_firstLevelView;    //记录第一列（主要用于计算多级表头一行的高度）
    
    
    //test layout
    int _level;              //临时记录深度
    int _maxLevel;           //当前记录最大的level
    UIView *_deepLevelView;  //记录最深级的view
    
}
@end

#define ColumnWidth  40.0
@implementation JNColumnHeadView

/*--------思路讲解--------
 |     | 2-0 |     假如有表头数据这样，第一级是0 第二级是1-0、1-1
 | 1-0 | 2-1 |     第三级2-0、2-1、2-2是1-0的子级，2-3是1-1的子级
 0 |     | 2-2 |
 -------------
 | 1-1 | 2-3 |
 
 
 1、只关心父级与子级的关系
 他们之间添加约束：父级的顶部与子级第一个cell顶部对齐，父级的底部与子级最后一个cell底部对齐
 子级cell之间的上下间距是分割线的宽度，所有子级cell都是左侧对齐第一个子级cell
 第一个子级cell左侧与父级右侧的间距是分割线的宽度
 只要有子级，就设置这个view的宽度为事先约好的列宽
 这里会使用到递归调用
 
 2、不用关心同等级cell但是不同父级view的关系
 如上图，不需要设置任何2-2与2-3之间的约束关系
 
 3、保存最后一级的cell，就是没有子级的（用处：返回数据表单行的高度），通过设置最后一列的约束去控制高度
 根据递归调用的先后顺序，查询到的第一个没有子级的一定是最后一列最上面的那个，在上图中就是2-0，
 最后一个就是最后一列最下面的那个，上图中的2-3.如果没有2-3这个cell的话，最后一个就是1-1.
 要给最上面一个添加约束：距离superView的上边距为分割线宽度 给最下面一个添加约束：距离superView的下边距为分割线宽度
 最后一列所有cell上下级间距设置，与superView右边距设置
 
 4、记录最深层级的view，通过设置这个view的宽度去控制最后一级的列宽
 设置view的宽度为事先约好的列宽
 
 */
-(instancetype)initWithModel:(JNReportHeadModel *)model{
    self = [super init];
    if(self){
        _cellData = model;
        self.backgroundColor = R_ColorSeparator;
        [self layout:_cellData withView:nil];
        [self layoutLastLevelView];
    }
    return self;
}

-(void)dealloc{
    NSLog(@"===dealloc===");
}


-(instancetype)initWithModel:(JNReportHeadModel *)model size:(CGFloat)fontSize{
    return [self initWithModel:model];
}

-(void)layout:(JNReportHeadModel *)data withView:(UIView *)view{
    //生成自身的view
    if(view == nil){
        view = [self cellView:data size:12.0];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(R_WidthSeparator);
        }];
    }
    
    if(data.nextLevelHeads.count > 0){
        //有子级
        _level++;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            //设置统一宽度
            make.width.equalTo(@ColumnWidth);
        }];
        
        UIView *bottomItem;
        UIView *firstItem;
        for(JNReportHeadModel *model in data.nextLevelHeads){
            UIView *cell = [self cellView:model size:12.0];
            [self addSubview:cell];
            //此处使用有待优化
            if([data.headTitle isEqualToString:_cellData.headTitle]){
                if(_firstLevelView == nil){
                    _firstLevelView = [[NSMutableArray alloc] init];
                }
                [_firstLevelView addObject:cell];
            }
            //同级之间布局
            if(firstItem){
                //左侧对齐
                [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(firstItem);
                }];
            }
            
            if(bottomItem){
                //上下间距R_WidthSeparator
                [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(bottomItem.mas_bottom).offset(R_WidthSeparator);
                }];
            }else{
                firstItem = cell;
            }
            bottomItem = cell;
            //递归调用
            [self layout:model withView:cell];
        }
        _level--;
        //使用firstItem、bottomItem记录子级最上面与最下面的两个view
        if(firstItem){
            [firstItem mas_makeConstraints:^(MASConstraintMaker *make) {
                //与父级上对齐
                make.top.equalTo(view.mas_top);
                //与父级间距
                make.left.equalTo(view.mas_right).offset(R_WidthSeparator);
            }];
        }
        if(bottomItem){
            //与父级下对齐
            [bottomItem mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(view.mas_bottom);
            }];
        }
    }else{
        //没有子级
        //记录最深等级的view
        if(_maxLevel < _level){
            _deepLevelView = view;
            _maxLevel = _level;
        }
        //记录最后一级，用于最后布局和计算表数据的高度
        if(_lastLevelView == nil){
            _lastLevelView = [[NSMutableArray alloc] init];
        }
        [_lastLevelView addObject:view];
    }
}

-(void)layoutLastLevelView{
    if(_lastLevelView){
        //添加右约束
        UIView *item;
        for(UIView *view in _lastLevelView){
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(-R_WidthSeparator);
                //此处添加与上一个cell的间距约束，会出现重复添加（在layout:withView:方法中同级之间间距设置已经添加过），但是貌似不影响。优化：先判断是否已经添加了
                if(item){
                    make.top.equalTo(item.mas_bottom).offset(R_WidthSeparator);
                }
            }];
            item = view;
        }
        UIView *firstView = [_lastLevelView firstObject];
        if(firstView){
            //添加上约束
            [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
                //                make.top.equalTo(self.mas_top).offset(R_WidthSeparator);
                //因为下方也设置了一个分割线的间距，如果上面再设置的话，就会有两个分割线的宽度了
                make.top.equalTo(self.mas_top);
            }];
        }
        UIView *lastView = [_lastLevelView lastObject];
        if(lastView){
            //添加下约束
            [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_bottom).offset(-R_WidthSeparator);
            }];
        }
    }
    
    //设置最深级别的view宽度
    if(_deepLevelView){
        UILabel *label = (UILabel *)[_deepLevelView.subviews firstObject];
        NSLog(@"==[%@]===",label.text);
        [_deepLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@ColumnWidth);
        }];
    }
}

//单个view
-(UIView *)cellView:(JNReportHeadModel *)data size:(CGFloat)fontSize{
    UIView *rtn;
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = R_ColorColumnHeadBG;
    //label相关设置
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:R_FontSize];
    label.textColor = R_ColorHeadFont;
    label.text = data.headTitle;
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

//获取表数据高度
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

//获取表头高度
-(NSArray *)cellHeights{
    NSMutableArray *heightsArray = [[NSMutableArray alloc] init];
    for(UIView *view in _firstLevelView){
        [heightsArray addObject:[NSNumber numberWithDouble:view.bounds.size.height]];
    }
    return heightsArray;
}
@end
