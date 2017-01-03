//
//  LeakCanary.m
//  LeakCanaryiOS
//
//  Created by Hai Feng Kao on 2015/11/18.
//
//


#import "HINSPHeapStackInspector.h"
#import "LeakCanary.h"
#import "NSObject+HeapInspector.h"

@interface LeakCanary()
@end

@implementation LeakCanary

+ (void)beginSnapShot:(NSArray*)array
{
    [NSObject addClassPrefixesToRecord:array];
    [HINSPHeapStackInspector performHeapShot];
}

+ (NSSet*)endSnapShot
{
    NSSet* set = [HINSPHeapStackInspector recordedHeap];
    return set;
}    

@end
