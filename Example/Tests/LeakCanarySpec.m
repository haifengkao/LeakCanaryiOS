//
//  LeakCanarySpec.m
//  LeakCanaryiOS
//
//  Created by Hai Feng Kao on 11/18/2015.
//  Copyright (c) 2015 Hai Feng Kao. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "LeakCanary.h"

SPEC_BEGIN(LeakCanarySpec)

describe(@"LeakCanary", ^{
    context(@"no leaked objects", ^{
        it(@"should not detect any objects", ^{
            [LeakCanary beginSnapShot:@[@"UIVi"]];
            NSSet* leakedObjects = [LeakCanary endSnapShot];
            [[@(leakedObjects.count) should] equal:@(0)];
        });
    });
    context(@"has leaked objects", ^{
        it(@"should get these objects", ^{
            @autoreleasepool{
                [LeakCanary beginSnapShot:@[@"UIVi"]];
                UIView* dummyView = [UIView new];
                NSSet* leakedObjects = [LeakCanary endSnapShot];
                [[@(leakedObjects.count) should] equal:@(1)];
            }
            NSSet* leakedObjects = [LeakCanary endSnapShot];
            [[@(leakedObjects.count) should] equal:@(0)];
            
        });
    });

});

SPEC_END
