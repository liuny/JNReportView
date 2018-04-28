//
//  JNReportCell.h
//  JNReportViewTest
//
//  Created by liuny on 2017/3/3.
//  Copyright © 2017年 szjn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNReport.h"

@interface JNReportCell : UITableViewCell
+(NSString *)cellIdentifier;

-(void)updateCellData:(NSArray *)data cellWidths:(NSArray *)widths size:(CGFloat)fontSize;
@end
