//
//  LeakCanary.h
//  LeakCanaryiOS
//
//  Created by Hai Feng Kao on 2015/11/18.
//
//

#import <Foundation/Foundation.h>
@interface LeakCanary : NSObject
+ (void)beginSnapShot:(NSArray*)array;
+ (NSSet*)endSnapShot;
@end
