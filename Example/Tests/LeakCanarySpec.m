//
//  LeakCanarySpec.m
//  LeakCanaryiOS
//
//  Created by Hai Feng Kao on 11/18/2015.
//  Copyright (c) 2015 Hai Feng Kao. All rights reserved.
//

#import "LeakCanary.h"
@interface Foo : NSObject
@end
@implementation Foo

@end

SpecBegin(LeakCanarySpec)

context(@"no leaked objects", ^{
    it(@"should not detect any objects", ^{
        [LeakCanary beginSnapShot:@[@"UIVi"]];
        NSSet* leakedObjects = [LeakCanary endSnapShot];
        expect(leakedObjects).to.beEmpty();
    });
});
context(@"has leaked objects", ^{
    it(@"should get leaked views", ^{
        @autoreleasepool{
            [LeakCanary beginSnapShot:@[@"UIVi"]];
            UIView* dummyView = [UIView new];
            NSSet* leakedObjects = [LeakCanary endSnapShot];
            expect(leakedObjects).to.haveACountOf(1);
            dummyView = nil;
        }
        NSSet* leakedObjects = [LeakCanary endSnapShot];
        expect(leakedObjects).to.beEmpty();
    });
    it(@"should get leaked foos", ^{
        @autoreleasepool{
            [LeakCanary beginSnapShot:@[@"Foo"]];
            Foo* foo = [Foo new];
            NSSet* leakedObjects = [LeakCanary endSnapShot];
            expect(leakedObjects).to.haveACountOf(1);
            foo = nil;
        }
        NSSet* leakedObjects = [LeakCanary endSnapShot];
        expect(leakedObjects).to.beEmpty();
    });
});
SpecEnd
