//
//  PrefsWindow.m
//  QSync
//
//  Created by Jason Tratta on 5/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PrefsWindow.h"


@implementation PrefsWindow

- (id)initWithContentRect:(NSRect)contentRect
				styleMask:(NSUInteger)windowStyle
				  backing:(NSBackingStoreType)bufferingType
					defer:(BOOL)deferCreation
{
    self = [super
			initWithContentRect:contentRect
			styleMask: (NSTitledWindowMask | NSMiniaturizableWindowMask | NSClosableWindowMask)
			
			backing:bufferingType
			defer:deferCreation];
    if (self)
    {
        
        [self setBackgroundColor:[NSColor whiteColor]];
		[self setShowsResizeIndicator:FALSE];
    }
    return self;
}



@end
