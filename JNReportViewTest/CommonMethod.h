//
//  CommonMethod.h
//  BasePro
//
//  Created by liuny on 15/10/12.
//  Copyright (c) 2015年 szjn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import <UIKit/UIKit.h>

@interface CommonMethod : NSObject
singleton_interface(CommonMethod)
//展示一秒后消失的提示信息
//APP信息
-(NSString *)deviceUUID;
-(NSString *)deviceName;   //设备名 e.g. "My iPhone"
-(NSString *)deviceModel;  //设备型号 e.g. @"iPhone", @"iPod
-(NSString *)deviceSystem; //设备系统名称 e.g. @"ios 6.1"
-(NSString *)deviceTotalSpace; //设备的总内存
-(NSString *)deviceFreeSpace; //设备剩余内存
-(NSString *)getDocumentPath;
-(NSString *)getCustomPath:(NSString *)appendPath;
//NSString为空判断 －
-(NSString *)cheakSpaceWithString:(NSString *)string;
//NSString去除两端空格
-(NSString *)removeSpaceAndEnter:(NSString *)text;

//NSDate,NSString转换
-(NSString *)dateToString:(NSDate *)date withFormat:(NSString *)format;
-(NSDate *)stringToDate:(NSString *)dateStr withFormat:(NSString *)format;

//NSUserDefaults读写
-(void)writeInDefault:(id)value key:(NSString *)key;
-(id)readFromDefault:(NSString *)key;
-(void)removeFromDefault:(NSString *)key;

//沙盘文件读写(data必须实现NScoding)
-(void)writeData:(id)data savePath:(NSString *)path key:(NSString *)key;
-(id)readDataFromPath:(NSString *)path key:(NSString *)key;
-(void)writeDataNoKey:(id)data savePath:(NSString *)path;
-(id)readDataNoKey:(NSString *)path;
//计算文本高度
-(CGFloat)getHeightWithStr:(NSString *)str
                  maxWidth:(CGFloat)width
                  fontSize:(CGFloat)fontSize;
//计算文本宽度
-(CGFloat)getWidthWithStr:(NSString *)str maxWidth:(CGFloat)width fontSize:(CGFloat)fontSize;
//图片缩放
-(UIImage *)fitSmallImage:(UIImage *)originImage
                 wantSize:(CGSize)wantSize;

- (UIColor *)colorWithHexString:(NSString *)color;

//判断字符串
- (NSString *)returnNSString:(NSString *)string;

//检测网络状态
-(BOOL)checkNetWork;

//字典拼接成URL字符串
- (NSString *)getUrlWithString:(NSString *)str andWithDict:(NSDictionary *)dict;

//检测文件是否存在
-(BOOL) isFileExists:(NSString*) filePath;

//字符串转换成字典
-(NSDictionary*)dictionaryWithContentsOfJSONString:(NSString*)jsonString;

//字典转成字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic;

//nsdata转换成字典
-(NSDictionary*) dictionaryWithContentsOfNSData:(NSData*) reader;

//带多个小数点的版本判断
- (BOOL)versionCompare:(NSString *)remoteVersion;

//获取系统的versionCode
- (NSString *)appVersion;

//读取用户信息
-(NSMutableDictionary*) readUserInfo;


-(NSString*) formatNSDate:(NSDate*) date   andPatten:(NSString*) patten;

-(NSString*) getLastDay;

-(NSString*) getLastMonthString;

-(NSString*) documentsFolder;

-(CGFloat)defaultStatusBarHeight;

-(CGFloat)defaultNavBarHeight;

- (CGFloat)defaultFinalStatusHeight;

- (NSString *)nowDay;
- (NSString *)yesterday;
- (NSDateFormatter *)dateDefaultFormatter;
- (NSDateFormatter *)dateCustomFormatter;

- (NSDictionary *)readDataWithName:(NSString *)fileName;

@end
