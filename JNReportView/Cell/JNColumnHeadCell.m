//
//  JNColumnHeadCell.m
//  JnPengbs
//
//  Created by liuny on 2017/3/13.
//  Copyright © 2017年 victoria. All rights reserved.
//

#import "JNColumnHeadCell.h"

@interface JNColumnHeadCell()
{
    JNColumnHeadView *_columnHead;
}
@end

@implementation JNColumnHeadCell

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

-(void)updateData:(JNReportHeadModel *)model size:(CGFloat)fontSize{
    if(_columnHead){
        [_columnHead removeFromSuperview];
        _columnHead = nil;
    }
    _columnHead = [[JNColumnHeadView alloc] initWithModel:model size:fontSize];
    [self.contentView addSubview:_columnHead];
    [_columnHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

@end
