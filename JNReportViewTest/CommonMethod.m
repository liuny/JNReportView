//
//  CommonMethod.m
//  BasePro
//
//  Created by liuny on 15/10/12.
//  Copyright (c) 2015年 szjn. All rights reserved.
//

#import "CommonMethod.h"

@implementation CommonMethod

singleton_implementation(CommonMethod)



-(void)navigationBackNoText:(UIViewController *)vc{
    vc.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (NSString *)deviceName
{
    return [[UIDevice currentDevice] name];
}

- (NSString *)deviceModel
{
    return [[UIDevice currentDevice] model];
}

- (NSString *)deviceSystem
{
    NSString *system = [NSString stringWithFormat:@"%@ %@",[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]];
    return system;
}

- (NSString *)deviceTotalSpace{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager* fileManager = [[NSFileManager alloc ]init];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *totalSpace = [fileSysAttributes objectForKey:NSFileSystemSize];
    NSString  * str= [NSString stringWithFormat:@"%0.1fG",[totalSpace longLongValue]/1024.0/1024.0/1024.0];
    return str;
}

-(NSString *)deviceFreeSpace{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager* fileManager = [[NSFileManager alloc ]init];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
     NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    NSString  *str= [NSString stringWithFormat:@"%0.1fG",[freeSpace longLongValue]/1024.0/1024.0/1024.0];
    return str;

}
-(NSString *)deviceUUID
{
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}

-(NSString *)getDocumentPath{
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [array objectAtIndex:0];
}

-(NSString *)getCustomPath:(NSString *)appendPath{
    return [[self getDocumentPath] stringByAppendingPathComponent:appendPath];
}

-(NSString *)removeSpaceAndEnter:(NSString *)text{
    //只去除空格
    //[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
-(NSString *)cheakSpaceWithString:(NSString *)string{
    if ([string isEqualToString:@""] || string == nil || [string isEqual:[NSNull null]]) {
        return @"－";
    }else{
        return string;
    }
}
-(NSString *)dateToString:(NSDate *)date withFormat:(NSString *)format
{
    //@"yyyy-MM-dd HH:mm:ss"
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = format;
    return [df stringFromDate:date];
}

-(NSDate *)stringToDate:(NSString *)dateStr withFormat:(NSString *)format{
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = format;
    return [df dateFromString:dateStr];
}

-(void)writeInDefault:(id)value key:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

-(id)readFromDefault:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

-(void)removeFromDefault:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

-(void)writeData:(id)data savePath:(NSString *)path key:(NSString *)key{
    NSMutableData *mutaleData = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mutaleData];
    [archiver encodeObject:data forKey:key];
    [archiver finishEncoding];
    
    [data writeToFile:path atomically:YES];
}

-(id)readDataFromPath:(NSString *)path key:(NSString *)key{
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        id rtnData = [unarchiver decodeObjectForKey:key];
        [unarchiver finishDecoding];
        return rtnData;
    }else{
        return nil;
    }
}

-(void)writeDataNoKey:(id)data savePath:(NSString *)path{
    [NSKeyedArchiver archiveRootObject:data toFile:path];
}

-(id)readDataNoKey:(NSString *)path{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

//根据文字段获取需要的高度
-(CGFloat)getHeightWithStr:(NSString *)str maxWidth:(CGFloat)width fontSize:(CGFloat)fontSize
{
    CGSize textSize = CGSizeZero;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    textSize = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return textSize.height;
}
#pragma mark -
#pragma mark - 根据文字段获取需要的宽度
-(CGFloat)getWidthWithStr:(NSString *)str maxWidth:(CGFloat)width fontSize:(CGFloat)fontSize
{
    CGSize textSize = CGSizeZero;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    textSize = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return textSize.width;
}

//图片缩放
-(UIImage *)fitSmallImage:(UIImage *)originImage wantSize:(CGSize)wantSize fitScale:(BOOL)flag{
    CGRect drawRect = CGRectZero;
    if(flag == YES){
        //按宽高比例调整
        CGSize imageSize = originImage.size;
        CGFloat wscale = imageSize.width/wantSize.width;
        CGFloat hscale = imageSize.height/wantSize.height;
        CGFloat scale = (wscale>hscale) ? wscale:hscale;
        CGSize newSize = CGSizeMake(imageSize.width/scale, imageSize.height/scale);
        drawRect.size = newSize;
    }else{
        //不按宽高比调整
        drawRect.size = wantSize;
    }
    UIGraphicsBeginImageContext(drawRect.size);
    [originImage drawInRect:drawRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 将十六进制颜色转换为 UIColor 对象
- (UIColor *)colorWithHexString:(NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // strip "0X" or "#" if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

#pragma mark - 字典拼接成URL字符串
- (NSString *)getUrlWithString:(NSString *)str andWithDict:(NSDictionary *)dict{
    //URL
    NSMutableString *MyURL = [NSMutableString stringWithString:str];
    NSArray* keys = [dict allKeys];
    //拼接字符串
    for (int j = 0; j < keys.count; j ++)
    {
        NSString *string;
        if (j== 0)
        {
            //拼接时加？
            string = [NSString stringWithFormat:@"?%@=%@",keys[j], dict[keys[j]]];
        }else{
            //拼接时加&
            string = [NSString stringWithFormat:@"&%@=%@",keys[j], dict[keys[j]]];
        }
        //拼接字符串
        [MyURL appendString:string];
    }
    return MyURL;
}


#pragma mark -
#pragma mark -  判断字符串

- (NSString *)returnNSString:(NSString *)string{
    if (string == nil) {
        return @"";
    }else{
        return string;
    }
}


//-(NSMutableDictionary*) readUserInfo
//{
//    NSString* homePath = [self homeDictionary];
//    NSString *filePath = [homePath stringByAppendingPathComponent:USERINFO_TXT_PATH];
//    NSString* str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    //userInfomation = (NSMutableDictionary*)[[JsonHelper dictionaryWithContentsOfJSONString:str] valueForKey:SERVERDATA];
//    NSMutableDictionary *userInfomation = (NSMutableDictionary*)[self dictionaryWithContentsOfJSONString:str];
//    return userInfomation;
//}

-(NSString*) homeDictionary
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

#pragma mark - 检测文件是否存在
-(BOOL) isFileExists:(NSString*) filePath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

#pragma mark - 字典转成字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


#pragma mark - 字符串转换成字典
-(NSDictionary*)dictionaryWithContentsOfJSONString:(NSString*)jsonString
{
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error =nil;
    
    id result;
    
    @try{
        result =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    }@catch(NSException* e){
        
    }
    
    if(error !=nil)
        return nil;
    
    error = NULL;
    
    return result;
}

#pragma mark nsdata转换成字典
-(NSDictionary*) dictionaryWithContentsOfNSData:(NSData*) reader
{
    NSDictionary* content;
    NSString* jsonStr = [[NSString alloc] initWithData:[reader subdataWithRange:NSMakeRange(0, [reader length])] encoding:NSUTF8StringEncoding];
    content = [self dictionaryWithContentsOfJSONString:jsonStr];
    return content;
    
}

#pragma mark - 获取系统的versionCode
- (NSString *)appVersion
{
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    return appVersion;
}

#pragma mark - 带多个小数点的版本判断
- (BOOL)versionCompare:(NSString *)remoteVersion{
    BOOL rtn = NO;
    NSArray *array = [remoteVersion componentsSeparatedByString:@"."];
    NSString *localVersion = [self appVersion];
    NSArray *localArray = [localVersion componentsSeparatedByString:@"."];
    
    NSInteger maxCount  = array.count>localArray.count?array.count:localArray.count;
    for(int i=0;i<maxCount;i++){
        int server = 0;
        if(array.count > i){
            NSString *serverVersion = array[i];
            server = serverVersion.intValue;
        }
        int local = 0;
        if(localArray.count > i){
            NSString *localStr = localArray[i];
            local = localStr.intValue;
        }
        if(server == local){
            continue;
        }else{
            rtn = server>local?YES:NO;
            break;
        }
    }
    return rtn;
}

-(NSString*) formatNSDate:(NSDate*) date   andPatten:(NSString*) patten
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = patten;
    
    NSString *now = [dateFormatter stringFromDate:date];
    
    return now;
    
}

-(NSString*) getLastDay
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval  interval = 24*60*60*2; //2:天数
    NSDate *date1 = [nowDate initWithTimeIntervalSinceNow:-interval];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date1]];
}

-(NSString*) getLastMonthString
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    
    comps = [calendar components:unitFlags fromDate:now];
    
    
    if([comps month] > 2)
    {
        [comps setMonth:([comps month]-2)];
    }else if([comps month] == 2){
        [comps setYear:([comps year]-1)];
        [comps setMonth:12];
    }else if([comps month] == 1){
        [comps setYear:([comps year]-1)];
        [comps setMonth:11];
        
    }
    
    NSInteger year  = [comps year];
    NSInteger month = [comps month];
    
    if (month == 0) {
        month = 12;
        year  = year -1;
    }
    
    if (month < 10) {
        return [NSString stringWithFormat:@"%ld-0%ld",year,month];
    }else{
        return [NSString stringWithFormat:@"%ld-%ld",year,month];
    }
}

-(NSString*) documentsFolder
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}


- (NSString *)nowDay{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* destinationTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    [formatter setTimeZone:destinationTimeZone];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    return dateStr;
}
- (NSString *)yesterday{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* destinationTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    [formatter setTimeZone:destinationTimeZone];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [[NSDate alloc]initWithTimeInterval:-3600*24 sinceDate:[NSDate date]];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

- (NSDateFormatter *)dateDefaultFormatter{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* destinationTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    [formatter setTimeZone:destinationTimeZone];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return formatter;
}

- (NSDateFormatter *)dateCustomFormatter{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* destinationTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    [formatter setTimeZone:destinationTimeZone];
    [formatter setDateFormat:@"yyyyMMdd"];
    return formatter;
}

- (NSDictionary *)readDataWithName:(NSString *)fileName{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSString *dataFile = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *dict = [self dictionaryWithContentsOfJSONString:dataFile];
    return dict;
}

@end
