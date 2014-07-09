//
//  NewsInfoService.m
//  lessonDemoForth
//
//  Created by sky on 14-7-9.
//  Copyright (c) 2014年 com.grassinfo. All rights reserved.
//

#import "NewsInfoService.h"

@implementation NewsInfoService

+(void)requestNewsInfosByType:(NSInteger)type atPage:(NSInteger)page complete:(CompleteHandle)handle{
    //网络有连接,从服务器取数据,并同步到本地数据库
    if([Sysconfig isNetworkReachable]){
        BaseService *base=[[BaseService alloc] init];
        base.url=[NSString stringWithFormat:@"http://api.blbaidu.cn/API/News.ashx?cid=%d&pageNo=%d",type,page];
        [base requestWithCompletionHandler:^(NSString *responseStr, NSURLResponse *response, NSError *error) {
            NSMutableArray *infos=nil;
            //解析json字符串
            if(responseStr){
                NSDictionary *responseDic=[responseStr objectFromJSONString];
                if(responseDic){
                    NSArray *results=[responseDic objectForKey:@"result"];
                    infos=[NSMutableArray new];
                    if(results){
                        for(NSDictionary *newsDic in results){
                            //组装对象
                            NewsInfo *newsInfo=[[NewsInfo alloc] initWithDictionary:newsDic];
                            newsInfo.type=205;
                            [infos addObject:newsInfo];
                        }
                        //刷新数据库
                        BaseDao *baseDao=[BaseDao sharedDao];
                        [baseDao batchInsertOrUpdate:infos];
                    }
                }
            }
            //block回调结果
            if(handle){
                handle(infos);
            }
        }];
    }else{
        //从本地数据库读取数据
        NewsInfoDao *infoDao=[NewsInfoDao new];
        NSArray *infos=[infoDao selectNewsInfosbyType:type AtPage:page];
        //block回调结果
        if(handle){
            handle(infos);
        }
    }
}

@end
