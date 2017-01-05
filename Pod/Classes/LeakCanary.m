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
#import <malloc/malloc.h>

@interface LeakCanary()
@end

static NSSet* liveObjects = nil;
@implementation LeakCanary

+ (void)beginSnapShot:(NSArray*)array
{
    // use synchronized because the order of beginSnapShot and endSnapshot should be preserved
    // to avoid EXE_BAD_ACCESS of zone->introspect->enumerator
    @synchronized(self) {
        liveObjects = nil;
        [NSObject addClassPrefixesToRecord:array];
        [HINSPHeapStackInspector performHeapShot];
        [NSObject beginSnapshot];
    }
}

+ (NSSet*)endSnapShot
{
    @synchronized(self) {
        if (!liveObjects) {
            [NSObject endSnapshot];
            liveObjects = [HINSPHeapStackInspector recordedHeap];
            return liveObjects;
        } 

        // recordedHeap is buggy, avoid using it whenever possilbe
        NSMutableSet *deadObjects = [[NSMutableSet alloc] init];

        // liveObjects already exists
        // check if their pointer has been released or not

        // get the pointer from  
        //NSString *string = [NSString stringWithFormat:@"%s: %p",
                            //object_getClassName(object),
                            //object];
        for (NSString* str in liveObjects) {
            NSRange range = [str rangeOfString:@": "];
            if (range.location != NSNotFound) {
                NSString* substr = [str substringFromIndex:range.location + range.length];
                NSScanner* scanner = [NSScanner scannerWithString:substr];
                unsigned long long* ptr = nil;
                
                [scanner scanHexLongLong:&ptr];
                if (ptr && NULL == malloc_zone_from_ptr(ptr)) {
                    [deadObjects addObject:str];
                } 
            } 
        }
        NSMutableSet* set = [[NSMutableSet alloc] initWithSet:liveObjects];
        [set minusSet:deadObjects];
        return set;
    }
}    

@end
