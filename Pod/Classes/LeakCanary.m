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
    // use synchronized because the order of beginSnapShot and endSnapshot should be preserved
    // to avoid EXE_BAD_ACCESS of zone->introspect->enumerator
    @synchronized(self) {
        // need to call reset after endSnapShot
        // otherwise, we may get EXE_BAD_ACCESS of zone->introspect when performHeapShot is called
        [HINSPHeapStackInspector reset];
        [NSObject addClassPrefixesToRecord:array];
        [NSObject beginSnapshot];
        [HINSPHeapStackInspector performHeapShot];
    }
}

+ (NSSet*)endSnapShot
{
    @synchronized(self) {
        [NSObject endSnapshot];
        NSSet* set = [HINSPHeapStackInspector recordedHeap];
        return set;
    }
}    

@end
