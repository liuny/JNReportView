//
//  ViewController.m
//  JNReportViewTest
//
//  Created by liuny on 2017/3/3.
//  Copyright © 2017年 szjn. All rights reserved.
//

#import "ViewController.h"
#import "JNReport.h"

@interface ViewController ()
{
    JNReportView *_reportView;
    NSInteger _columnNum;
    NSInteger _rowNum;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initControl];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initControl{
    _reportView = [[JNReportView alloc] initFromNib];
    [self.view addSubview:_reportView];
    [_reportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    NSArray *rowHeads = [self testRowHead:0];
    NSArray *columnHeads = [self testColumnHead:0];
    NSArray *reportData = [self testReportData];
    [_reportView updateData:reportData rowHeads:rowHeads columnHeads:columnHeads andTitle:@"测试" size:12];
}

-(NSArray *)testReportData{
    NSMutableArray *rtn = [[NSMutableArray alloc] init];
    for(int i=0;i<_columnNum;i++){
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for(int j=0;j<_rowNum;j++){
            NSString *str = [NSString stringWithFormat:@"%d-%d",i,j];
            [array addObject:str];
        }
        [rtn addObject:array];
    }
    
    return rtn;
}


-(NSArray *)testRowHead:(int)flag{
    NSMutableArray *rtn = [[NSMutableArray alloc] init];
    int testFlag = flag;
    switch (testFlag) {
        case 0:
        {
            JNReportHeadModel *model = [[JNReportHeadModel alloc] initWithTitle:@"社区用户" childrenLevel:@[@"月度新增覆盖",@"年度新增覆盖",@"总覆盖户数",@"月度新开户数",@"上月同期新开",@"新开同期对比",@"新开率",@"月度净增户数"]];
            [rtn addObject:model];
            _rowNum = 8;
            break;
        }
        case 1:
        {
            for(int i=0;i<5;i++){
                NSString *str = [NSString stringWithFormat:@"%d",i];
                JNReportHeadModel *model = [[JNReportHeadModel alloc] initWithTitle:str];
                [rtn addObject:model];
            }
            _rowNum = 5;
            break;
        }
        case 2:
        {
            //文字过多测试
            JNReportHeadModel *model = [[JNReportHeadModel alloc] initWithTitle:@"社区用户" childrenLevel:@[@"word如何制作表格,Word对表格的制作提供了很好的支持,只需要通过简单的几个步骤即可实现表格的插入操作.具体实现方法如下:",@"年度新增覆盖",@"总覆盖户数",@"新开同期对比",@"新开率",@"月度净增户数"]];
            [rtn addObject:model];
            _rowNum = 6;
            break;
        }
        case 3:
        {
            //多等级
            JNReportHeadModel *model = [[JNReportHeadModel alloc] initWithTitle:@"计量单位"];
            [rtn addObject:model];
            JNReportHeadModel *model1 = [[JNReportHeadModel alloc] initWithTitle:@"工程数量"];
            [rtn addObject:model1];
            JNReportHeadModel *model2 = [[JNReportHeadModel alloc] initWithTitle:@"其中" childrenLevel:@[@"定额人工费",@"暂估价"]];
            JNReportHeadModel *model3 = [[JNReportHeadModel alloc] initWithTitle:@"综合单价"];
            JNReportHeadModel *model4 = [[JNReportHeadModel alloc] initWithTitle:@"单价"];
            JNReportHeadModel *model5 = [[JNReportHeadModel alloc] initWithTitle:@"金额（元）" objChildrens:@[model3,model4,model2]];
            [rtn addObject:model5];
            _rowNum = 6;
            break;
        }
        case 4:
        {
            JNReportHeadModel *model = [[JNReportHeadModel alloc] initWithTitle:@"余额"];
            [rtn addObject:model];
            JNReportHeadModel *model1 = [[JNReportHeadModel alloc] initWithTitle:@"管理费用" childrenLevel:@[@"办公费",@"修理费",@"养路费",@"福利费",@"招待费"]];
            [rtn addObject:model1];
            _rowNum = 6;
            break;
        }
        default:
            break;
    }
    return rtn;
}

-(NSArray *)testColumnHead:(int)flag{
    NSMutableArray *rtn = [[NSMutableArray alloc] init];
    int testFlag = flag;
    switch (testFlag) {
        case 0:
        {
            //等级3
            JNReportHeadModel *model3_0 = [[JNReportHeadModel alloc] initWithTitle:@"尹立新"];
            JNReportHeadModel *model3_1 = [[JNReportHeadModel alloc] initWithTitle:@"吕卫团"];
            JNReportHeadModel *model3_2 = [[JNReportHeadModel alloc] initWithTitle:@"汪总"];
            JNReportHeadModel *model3_3 = [[JNReportHeadModel alloc] initWithTitle:@"张军"];
            //等级2
            JNReportHeadModel *model2_0 = [[JNReportHeadModel alloc] initWithTitle:@"黔黑战区" objChildrens:@[model3_0]];
            JNReportHeadModel *model2_1 = [[JNReportHeadModel alloc] initWithTitle:@"云晋吉战区" objChildrens:@[model3_1]];
            JNReportHeadModel *model2_2 = [[JNReportHeadModel alloc] initWithTitle:@"苏皖赣战区" objChildrens:@[model3_2]];
            JNReportHeadModel *model2_3 = [[JNReportHeadModel alloc] initWithTitle:@"津豫战区" objChildrens:@[model3_3]];
            //等级1
            JNReportHeadModel *model1_0 = [[JNReportHeadModel alloc] initWithTitle:@"1" objChildrens:@[model2_0]];
            
            JNReportHeadModel *model1_1 = [[JNReportHeadModel alloc] initWithTitle:@"2" objChildrens:@[model2_1]];
            JNReportHeadModel *model1_2 = [[JNReportHeadModel alloc] initWithTitle:@"3" objChildrens:@[model2_2]];
            JNReportHeadModel *model1_3 = [[JNReportHeadModel alloc] initWithTitle:@"4" objChildrens:@[model2_3]];
            rtn = [@[model1_0,model1_1,model1_2,model1_3] mutableCopy];
            _columnNum = 4;
            break;
        }
        case 1:
        {
            //等级层数不同测试
            JNReportHeadModel *model = [[JNReportHeadModel alloc] initWithTitle:@"黔黑战区" childrenLevel:@[@"尹立新",@"吕卫团"]];
            JNReportHeadModel *model1 = [[JNReportHeadModel alloc] initWithTitle:@"1" objChildrens:@[model]];
            JNReportHeadModel *model2 = [[JNReportHeadModel alloc] initWithTitle:@"集团合计"];
            //修改测试
            [rtn addObject:model1];
            [rtn addObject:model2];
            _columnNum = 3;
            break;
        }
        case 2:
        {
            //文字数量过多测试
            JNReportHeadModel *model = [[JNReportHeadModel alloc] initWithTitle:@"1" childrenLevel:@[@"分公司合计"]];
            JNReportHeadModel *model1 = [[JNReportHeadModel alloc] initWithTitle:@"2" childrenLevel:@[@"合计"]];
            JNReportHeadModel *model2 = [[JNReportHeadModel alloc] initWithTitle:@"3" childrenLevel:@[@"ZOL软件下载合集页提供最新最全的Excel表格下载"]];
            JNReportHeadModel *model3 = [[JNReportHeadModel alloc] initWithTitle:@"ZOL软件下载合集页提供最新最全的Excel表格下载" childrenLevel:@[@"4"]];
            [rtn addObject:model];
            [rtn addObject:model1];
            [rtn addObject:model2];
            [rtn addObject:model3];
            _columnNum = 4;
            break;
        }
        case 3:
        {
            JNReportHeadModel *model = [[JNReportHeadModel alloc] initWithTitle:@"重庆" childrenLevel:@[@"重庆"]];
            JNReportHeadModel *model1 = [[JNReportHeadModel alloc] initWithTitle:@"小计"];
            JNReportHeadModel *model2 = [[JNReportHeadModel alloc] initWithTitle:@"赵缙" objChildrens:@[model,model1]];
            JNReportHeadModel *model3 = [[JNReportHeadModel alloc] initWithTitle:@"1" objChildrens:@[model2]];
            [rtn addObject:model3];
            JNReportHeadModel *model1_0 = [[JNReportHeadModel alloc] initWithTitle:@"贵州" childrenLevel:@[@"安顺",@"铜仁",@"凯里",@"六盘水",@"遵义",@"都匀",@"贵阳"]];
            JNReportHeadModel *model1_1 = [[JNReportHeadModel alloc] initWithTitle:@"黑龙江" childrenLevel:@[@"七台河",@"鸡西",@"鹤岗",@"齐齐哈尔",@"绥化",@"牡丹江",@"哈尔滨",@"佳木斯",@"双鸭山",@"大庆"]];
            JNReportHeadModel *model1_2 = [[JNReportHeadModel alloc] initWithTitle:@"小计"];
            JNReportHeadModel *model1_3 = [[JNReportHeadModel alloc] initWithTitle:@"尹立新" objChildrens:@[model1_0,model1_1,model1_2]];
            JNReportHeadModel *model1_4 = [[JNReportHeadModel alloc] initWithTitle:@"2" objChildrens:@[model1_3]];
            [rtn addObject:model1_4];
            _columnNum = 20;
            break;
        }
        case 4:
        {
            for(int i=0;i<5;i++){
                NSString *str = [NSString stringWithFormat:@"%d",i];
                JNReportHeadModel *model = [[JNReportHeadModel alloc] initWithTitle:str];
                [rtn addObject:model];
            }
            _columnNum = 5;
            break;
        }
        default:
            break;
    }
    
    return rtn;
}
- (IBAction)buttonAction:(id)sender {
    int x = arc4random() % 5;
    NSArray *rowHeads = [self testRowHead:x];
    int y = arc4random() % 5;
    NSArray *columnHeads = [self testColumnHead:y];
    NSArray *reportData = [self testReportData];
    [_reportView updateData:reportData rowHeads:rowHeads columnHeads:columnHeads andTitle:@"测试" size:12];
}
@end
