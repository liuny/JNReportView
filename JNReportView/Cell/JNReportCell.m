//
//  JNReportCell.m
//  JNReportViewTest
//
//  Created by liuny on 2017/3/3.
//  Copyright © 2017年 szjn. All rights reserved.
//

#import "JNReportCell.h"

#define LabelTagOffset  100

@implementation JNReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(NSString *)cellIdentifier{
    return NSStringFromClass(self);
}

-(void)updateCellData:(NSArray *)data cellWidths:(NSArray *)widths size:(CGFloat)fontSize{
    if(data.count == self.contentView.subviews.count){
        [self updateLabelTitles:data cellWidths:(NSArray *)widths size:fontSize];
    }else{
        [self addLabelWithTitle:data cellWidths:widths size:fontSize];
    }
    
}

-(void)addLabelWithTitle:(NSArray *)data cellWidths:(NSArray *)widths size:(CGFloat)fontSize{
    //移除原有的
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //添加新的
    UIView *leftItem;
    NSInteger myCount;
    if (data.count<=widths.count) {
        myCount=data.count;
    }else{
        myCount = widths.count;
    }
    for(int i=0;i<myCount;i++){
        NSString *title = data[i];
        NSNumber *num = widths[i];
        double width = num.doubleValue;
        UILabel *label = [self cellLabel:title size:fontSize];
        label.tag = i+LabelTagOffset;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-R_WidthSeparator);
            if(leftItem){
                make.left.equalTo(leftItem.mas_right).offset(R_WidthSeparator);
            }else{
                make.left.equalTo(self.contentView.mas_left);
            }
            make.width.equalTo(@(width));
        }];
        leftItem = label;
    }
}

-(void)updateLabelTitles:(NSArray *)data cellWidths:(NSArray *)widths size:(CGFloat)fontSize{
    for(int i=0;i<data.count;i++){
        UIView *view = [self.contentView viewWithTag:i+LabelTagOffset];
        if([view isKindOfClass:[UILabel class]]){
            UILabel *label = (UILabel *)view;
            NSString *dataStr = data[i];
            label.text = dataStr;
            if ([dataStr hasPrefix:@"-"] || dataStr.doubleValue<0) {
                label.textColor = kGetColor(124, 205, 124);
            }else{
                label.textColor = R_ColorHeadFont;
            }
            label.font = [UIFont systemFontOfSize:fontSize];
            NSNumber *num = widths[i];
            double width = num.doubleValue;
            [label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(width));
            }];
        }
    }
}

-(UILabel *)cellLabel:(NSString *)title size:(CGFloat)fontSize{
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    if ([title hasPrefix:@"-"] || title.doubleValue<0) {
        label.textColor = kGetColor(124, 205, 124);
    }else{
        label.textColor = R_ColorHeadFont;
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}
@end
