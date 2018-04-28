//
//  JNColumnHeadCell.h
//  JnPengbs
//
//  Created by liuny on 2017/3/13.
//  Copyright © 2017年 victoria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNReport.h"

@interface JNColumnHeadCell : UITableViewCell
+(NSString *)cellIdentifier;

-(void)updateData:(JNReportHeadModel *)model size:(CGFloat)fontSize;
@end
