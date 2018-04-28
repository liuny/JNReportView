//
//  JNReport.h
//  JNReportViewTest
//
//  Created by liuny on 2017/3/3.
//  Copyright © 2017年 szjn. All rights reserved.
//

#ifndef JNReport_h
#define JNReport_h

#define kGetColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define R_ColorColumnHeadBG       kGetColor(238,240,241)  //表头背景颜色
#define R_ColorRowHeadBG       kGetColor(245,245,245)  //表头背景颜色
#define R_ColorSeparator    kGetColor(228,228,228)  //分割线颜色
#define R_ColorHeadFont     kGetColor(0,0,0)        //表头字体颜色
#define R_WidthSeparator    1.0                     //分割线宽度

/*
 *需要使用到第三方库Masonry
 */

#import "Masonry.h"
#import "JNReportHeadModel.h"
#import "JNReportCell.h"
#import "JNColumnHeadCell.h"
#import "JNRowHeadView.h"
#import "JNColumnHeadView.h"
#import "JNReportView.h"

#endif /* JNReport_h */
