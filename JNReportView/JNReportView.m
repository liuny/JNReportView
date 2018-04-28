//
//  JNReportView.m
//  JNReportViewTest
//
//  Created by liuny on 2017/3/3.
//  Copyright © 2017年 szjn. All rights reserved.
//

#import "JNReportView.h"
#import "CommonMethod.h"

@interface JNReportView()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_tableData;
    NSMutableArray *_rowHeight;
    NSMutableArray *_isTotals;
    NSArray *_cellWidth;
    NSArray *_columnData;
    
    JNColumnHeadView *_placeHoldColumn;
    
    NSMutableArray *_columnCellHeight;
    JNRowHeadView *rowHead;
}
@property(nonatomic,assign) CGFloat fontSize;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *rowHeadView;
@property (weak, nonatomic) IBOutlet UITableView *columnHeadTableView;
@property (weak, nonatomic) IBOutlet UIView *columnHeadView;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *testView;
@end


#define PageSize    20.0

@implementation JNReportView
-(instancetype)initFromNib{
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"JNReportView" owner:nil options:nil];
    self = nibArray.firstObject;
    if(self){
        [self initControl];
    }
    return self;
}

-(void)initControl{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[JNReportCell class] forCellReuseIdentifier:[JNReportCell cellIdentifier]];
    
    self.columnHeadTableView.dataSource = self;
    self.columnHeadTableView.delegate = self;
    [self.columnHeadTableView registerClass:[JNColumnHeadCell class] forCellReuseIdentifier:[JNColumnHeadCell cellIdentifier]];
    self.columnHeadTableView.scrollEnabled = NO;
    
    self.loadingView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"InfoNotification" object:nil];
}

- (void)InfoNotificationAction:(NSNotification *)notification{
    
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    //此处获取的宽度不包含分割线高度
    [rowHead updateDataWith:[self dataWidthsSize:self.fontSize]];
    _cellWidth = [rowHead widths];
    [self.tableView reloadData];
}

- (void)hiddenLoding{
    self.loadingView.hidden = YES;
}

-(void)updateData:(NSArray *)tableData rowHeads:(NSArray *)rowHeads columnHeads:(NSArray *)columnHeads andTitle:(NSString *)title size:(CGFloat)fontSize{
    self.fontSize = fontSize;
    self.loadingView.hidden = NO;
    [self updateData:tableData rowHeads:rowHeads columnHeads:columnHeads size:fontSize];
    self.titleLabel.text = title;
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    self.titleLabel.backgroundColor = kGetColor(248, 248, 248);
}


-(void)updateData:(NSArray *)tableData rowHeads:(NSArray *)rowHeads columnHeads:(NSArray *)columnHeads size:(CGFloat)fontSize{
    _tableData = tableData;
    [self setForRowHead:rowHeads size:fontSize];
    [self setForColumnHead:columnHeads size:fontSize];

    _rowHeight = [[NSMutableArray alloc] init];
    _isTotals = [[NSMutableArray alloc] init];
    _columnCellHeight = [[NSMutableArray alloc] init];
    [self getColumnHeadHeightsize:fontSize];
}

-(void)getColumnHeadHeightsize:(CGFloat)fontSize{
    if (_columnData.count>0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            int pageSize = ceil(PageSize/(_tableData.count/_columnData.count));
            int pageNum = ceil(_columnData.count/(double)pageSize);
//            MyLog(@"===pageSize[%d]===num[%d]=",pageSize,pageNum);
            for(int page=0;page<pageNum;page++){
                int start = page*pageSize;
                int end = (int)MIN(pageSize*(page+1), _columnData.count);
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for(int i=start;i<end;i++){
                    [array addObject:_columnData[i]];
                }
                if(array.count > 0){
                    [self test:array size:fontSize];
                }
            }
        });
    }else{
        self.loadingView.hidden = YES;
    }
}


//只更新数据，不更新表头
-(void)updateData:(NSArray *)tableData{
    _tableData = tableData;
    [self.tableView reloadData];
}

- (NSArray *)dataWidthsSize:(CGFloat)fontSize{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<_tableData.count; i++) {
        NSArray *arr = _tableData[i];
        for (int j=0; j<arr.count; j++) {
            if (i==0) {
                CGFloat num = [[CommonMethod sharedCommonMethod] getWidthWithStr:arr[j] maxWidth:1000 fontSize:fontSize];
                [array addObject:[NSNumber numberWithFloat:num]];
            }else{
                CGFloat num = 0;
                CGFloat num1 = [[CommonMethod sharedCommonMethod] getWidthWithStr:arr[j] maxWidth:1000 fontSize:fontSize];
                CGFloat num2 = [array[j] floatValue];
                if (num1 < num2) {
                    num = num2;
                }else{
                    num = num1;
                }
                [array replaceObjectAtIndex:j withObject:[NSNumber numberWithFloat:num]];
            }
        }
    }
    return array;
}

#pragma mark - Private
-(void)setForRowHead:(NSArray *)heads size:(CGFloat)fontSize{
    //移除原有的view
    [self.rowHeadView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    JNReportHeadModel *model = [[JNReportHeadModel alloc] init];
    model.headTitle = @"此周期内暂无报表数据";
    model.nextLevelHeads = heads;
    rowHead = [[JNRowHeadView alloc] initWithModel:model size:fontSize];
    [self.rowHeadView addSubview:rowHead];
    [rowHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.rowHeadView);
    }];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    //此处获取的宽度不包含分割线高度
    [rowHead updateDataWith:[self dataWidthsSize:fontSize]];
    _cellWidth = [rowHead widths];
}

-(void)setForColumnHead:(NSArray *)heads size:(CGFloat)fontSize{
    _columnData = heads;

    //移除原有的view
    if(_placeHoldColumn){
        [_placeHoldColumn removeFromSuperview];
        _placeHoldColumn = nil;
    }
    if (_columnData.count > 0) {
        
        JNColumnHeadView *columnHead = [[JNColumnHeadView alloc] initWithModel:_columnData[0] size:fontSize];
        [self.columnHeadView insertSubview:columnHead atIndex:0];
        [columnHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.columnHeadView.mas_top);
            make.left.equalTo(self.columnHeadView.mas_left);
            make.right.equalTo(self.columnHeadView.mas_right);
        }];
        _placeHoldColumn = columnHead;
        [self.columnHeadTableView reloadData];
    }
}

-(void)test:(NSArray *)heads size:(CGFloat)fontSize{
    // 耗时的操作
    JNReportHeadModel *model = [[JNReportHeadModel alloc] init];
    model.headTitle = @"0";
    model.nextLevelHeads = heads;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        JNColumnHeadView *columnHead = [[JNColumnHeadView alloc] initWithModel:model size:fontSize];
        // 更新界面
        [self.testView addSubview:columnHead];
        [columnHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.testView);
        }];
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];
        //此处获取的高度不包含分割线高度
        [_rowHeight addObjectsFromArray:[columnHead heights]];
        [_isTotals addObjectsFromArray:[columnHead isTotals]];
        
        [_columnCellHeight addObjectsFromArray:[columnHead cellHeights]];
        if(_rowHeight.count == _tableData.count){
            [self.tableView reloadData];
            [self.columnHeadTableView reloadData];
            self.columnHeadTableView.scrollEnabled = YES;
            self.loadingView.hidden = YES;
        }
        //移除view
        [columnHead removeFromSuperview];
    });
}


#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.tableView){
        return _tableData.count-1;
    }else{
        return _columnData.count-1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tableView){
        if (_rowHeight.count>indexPath.row) {
            NSNumber *num = _rowHeight[indexPath.row];
            return num.doubleValue+R_WidthSeparator;
        }else{
            return UITableViewAutomaticDimension;
        }
    }else{
        if(_columnCellHeight.count > indexPath.row){
            NSNumber *num = _columnCellHeight[indexPath.row];
            return num.doubleValue+R_WidthSeparator;
        }else{
            return UITableViewAutomaticDimension;
        }
    }
}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.columnHeadTableView){
        if(_columnCellHeight.count > indexPath.row){
            NSNumber *num = _columnCellHeight[indexPath.row];
            return num.doubleValue+R_WidthSeparator;
        }else{
            return UITableViewAutomaticDimension;
        }
    }else{
        if (_rowHeight.count>indexPath.row) {
            NSNumber *num = _rowHeight[indexPath.row];
            return num.doubleValue+R_WidthSeparator;
        }else{
            return UITableViewAutomaticDimension;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(tableView == self.tableView){
        if (_rowHeight.count>0){
            NSNumber *num = [_rowHeight lastObject];
            return num.doubleValue+R_WidthSeparator+5;
        }else{
            return UITableViewAutomaticDimension;
        }
        
    }else{
        if (_rowHeight.count>0){
            NSNumber *num = [_columnCellHeight lastObject];
            return num.doubleValue+R_WidthSeparator+5;
        }else{
            return UITableViewAutomaticDimension;
        }
        
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(tableView == self.tableView){
        JNReportCell *cell = [tableView dequeueReusableCellWithIdentifier:[JNReportCell cellIdentifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //设置背景颜色
        cell.backgroundColor = kGetColor(217, 217, 217);
        [cell updateCellData:[_tableData lastObject] cellWidths:_cellWidth size:self.fontSize];
        return cell;
    }else{
        JNColumnHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:[JNColumnHeadCell cellIdentifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateData:[_columnData lastObject] size:self.fontSize];
        return cell;
    }
}

-(void)configColumnCell:(JNColumnHeadCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    [cell updateData:_columnData[indexPath.row] size:self.fontSize];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tableView){
        JNReportCell *cell = [tableView dequeueReusableCellWithIdentifier:[JNReportCell cellIdentifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //设置背景颜色
        if (indexPath.row%2==0) {
            cell.backgroundColor = [UIColor whiteColor];
        }else {
            cell.backgroundColor = kGetColor(248, 248, 248);
        }
        
        if (_isTotals.count>indexPath.row) {
            NSString *isTotalStr = _isTotals[indexPath.row];
            if ([isTotalStr isEqualToString:@"1"]) {
                cell.backgroundColor = kGetColor(217, 217, 217);
            }
        }
        
        [cell updateCellData:_tableData[indexPath.row] cellWidths:_cellWidth size:self.fontSize];
        return cell;
    }else{
        JNColumnHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:[JNColumnHeadCell cellIdentifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configColumnCell:cell atIndexPath:indexPath];
        return cell;
    }
}

#pragma mark - scrollView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.columnHeadTableView == scrollView){
        self.tableView.contentOffset = self.columnHeadTableView.contentOffset;
    }else if(self.tableView == scrollView){
        self.columnHeadTableView.contentOffset = self.tableView.contentOffset;
    }
}

@end
