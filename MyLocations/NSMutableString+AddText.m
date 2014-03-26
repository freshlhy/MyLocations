//
//  NSMutableString+AddText.m
//  MyLocations
//
//  Created by freshlhy on 14-3-26.
//  Copyright (c) 2014年 showgram. All rights reserved.
//

#import "NSMutableString+AddText.h"

@implementation NSMutableString (AddText)

- (void)addText:(NSString *)text withSeparator:(NSString *)separator {
    if (text != nil) {
        if ([self length] > 0) {
            [self appendString:separator];
        }
        [self appendString:text];
    }
}

@end
