//
//  HudView.h
//  MyLocations
//
//  Created by freshlhy on 3/18/14.
//  Copyright (c) 2014 showgram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HudView : UIView

+ (instancetype)hudInView:(UIView *)view animated:(BOOL)animated;

@property(nonatomic, strong) NSString *text;

@end
