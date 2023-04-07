//
//  NSString+HUUTF8Encoding.m
//  HayU
//
//  Created by 呛人的黑 on 2022/12/3.
//

#import "NSString+HUUTF8Encoding.h"

@implementation NSString (HUUTF8Encoding)

+ (NSString *)hu_stringUTF8Encoding:(NSString *)urlString{
    return [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

+ (NSString *)hu_urlString:(NSString *)urlString appendingParameters:(id)parameters{
    if (parameters==nil) {
        return urlString;
    }else{
        NSString *parametersString;
        if ([parameters isKindOfClass:[NSDictionary class]]){
            NSDictionary *dic = parameters;
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSString *key in dic) {
                id obj = [dic objectForKey:key];
                NSString *str = [NSString stringWithFormat:@"%@=%@",key,obj];
                [array addObject:str];
            }
            parametersString = [array componentsJoinedByString:@"&"];
        }else{
            parametersString =[NSString stringWithFormat:@"%@",parameters] ;
        }
        return [urlString stringByAppendingString:[NSString stringWithFormat:@"?%@",parametersString]];
    }
}
@end

@implementation HURequestTool

+ (id)formaParameters:(id)parameters filtrationCacheKey:(NSArray *)filtrationCacheKey{
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
        [mutableParameters removeObjectsForKeys:filtrationCacheKey];
        return [mutableParameters copy];
    }else {
        return parameters;
    }
}

@end
