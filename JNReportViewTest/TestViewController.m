//
//  TestViewController.m
//  JNReportViewTest
//
//  Created by liuny on 2018/4/28.
//  Copyright © 2018年 szjn. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()
@property (strong, nonatomic) IBOutlet UIView *centerView;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            break;
        }
        case 4:
        {
            for(int i=0;i<5;i++){
                NSString *str = [NSString stringWithFormat:@"%d",i];
                JNReportHeadModel *model = [[JNReportHeadModel alloc] initWithTitle:str];
                [rtn addObject:model];
            }
            break;
        }
        default:
            break;
    }
    
    return rtn;
}

-(void)test{
    
    [self.centerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int x = arc4random() % 5;
    NSArray *rowHeads = [self testColumnHead:x];
    JNReportHeadModel *one = [[JNReportHeadModel alloc] initWithTitle:@"000" objChildrens:rowHeads];

    JNColumnHeadView *view = [[JNColumnHeadView alloc] initWithModel:one size:12.0];
    [self.centerView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.centerView);
    }];
}

- (IBAction)buttonAction:(id)sender {
    [self test];
}

@end
