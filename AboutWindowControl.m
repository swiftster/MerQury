//
//  About.m
//  QAutoSaver
//
//  Created by Jason Tratta 2/4/09.
//  Copyright 2009 Sound Character. All rights reserved.
//

#import "AboutWindowControl.h"


@implementation AboutWindowControl

-(id)init 
{ 
	if (![super initWithWindowNibName:@"AboutWindow"])
		return nil;
	
	[self setVersionNumber]; 
	
	return self; 
}

-(void)windowDidLoad 
{ 
	NSLog(@"About Nib is loaded"); 
	
}


-(void)setVersionNumber 
{ 
	NSString *versionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleGetInfoString"]; 
	NSLog(@"Version String: %f",versionNumber);
	[versionOutput setStringValue:versionNumber];
	
}


-(IBAction)openPayPalInBrowser: (id) sender
{ 
	
	NSWorkspace *payWorkSpace = [NSWorkspace sharedWorkspace]; 
	NSURL *donateURL = [NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=11321666"];
	NSLog(@"URL is %@", donateURL);
	
	[payWorkSpace openURL:donateURL];
	
	
}

-(IBAction)imageGoHome:(id) sender
{
	NSWorkspace *goHomeSpace = [NSWorkspace sharedWorkspace]; 
	NSURL *homeURL = [NSURL URLWithString:@"http://www.jasontratta.com/merqury"]; 
	
	[goHomeSpace openURL:homeURL]; 
	
}



@end
