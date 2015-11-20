//
//  LeakCanary.m
//  LeakCanaryiOS
//
//  Created by Hai Feng Kao on 2015/11/18.
//
//


#import "HINSPHeapStackInspector.h"
#import "LeakCanary.h"

@interface LeakCanary()
@end

@implementation LeakCanary

+ (void)beginSnapShot:(NSArray*)array
{
    [HINSPHeapStackInspector setClassPrefixArray:array];
    [HINSPHeapStackInspector performHeapShot];
}

+ (NSSet*)endSnapShot
{
    NSSet* set = [HINSPHeapStackInspector recordedHeapStack];
    return set;
}    

@end
