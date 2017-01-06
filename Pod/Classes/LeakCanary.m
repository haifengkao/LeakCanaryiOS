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

@interface LCWeakObject : NSObject
@property (nonatomic, weak) id object;
- (instancetype)initWithObject:(id)object NS_DESIGNATED_INITIALIZER;
@end

@implementation LCWeakObject

- (instancetype)init
{
    return [self initWithObject:nil];
}

- (instancetype)initWithObject:(id)object;
{
    if (self = [super init]) {
        _object = object;
    }
    return self;
}
@end

@interface LeakCanary()
@end

static NSSet* liveObjects = nil;
static NSMutableDictionary* cache = nil;
@implementation LeakCanary

+ (void)beginSnapShot:(NSArray*)array
{
    // use synchronized because the order of beginSnapShot and endSnapshot should be preserved
    // to avoid EXE_BAD_ACCESS of zone->introspect->enumerator
    @synchronized(self) {
        liveObjects = nil;
        cache = [[NSMutableDictionary alloc] init];
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
            if (range.location == NSNotFound) { continue; }
            NSString* substr = [str substringFromIndex:range.location + range.length];
            LCWeakObject* obj = [cache objectForKey:substr];
            if (!obj) {
                id ptr = [HINSPHeapStackInspector objectForPointer:substr];
                obj = [[LCWeakObject alloc] initWithObject:ptr];
                cache[substr] = obj;
            } 

            if (!obj) { continue; }  // something went wrong

            if (!obj.object) {
                // the weak object has been released
                [deadObjects addObject:str];
            }
        }
        NSMutableSet* set = [[NSMutableSet alloc] initWithSet:liveObjects];
        [set minusSet:deadObjects];
        return set;
    }
}    

@end
