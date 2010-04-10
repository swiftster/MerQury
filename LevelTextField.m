//
//  LevelTextField.m
//  QSync
//
//  Created by Jason Tratta on 4/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LevelTextField.h"


@implementation LevelTextField



-(BOOL)becomeFirstResponder 
{
	BOOL result = [super becomeFirstResponder]; 
	if (result) {
		[self performSelector:@selector(selectText:) withObject:self afterDelay:0];
	}
	
	return result;
}




@end
