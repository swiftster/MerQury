//
//  ClientMessage.h
//  QSSync
//
//  Created by jtratta on 12/4/09.
//  Copyright 2009 Sound Character . All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Message : NSObject <NSCoding> {
    int tag;
    NSData *dataContent;
}

-(int)tag;
-(void)setTag:(int)value;

-(NSData *)dataContent;
-(void)setDataContent:(NSData *)value;

@end
