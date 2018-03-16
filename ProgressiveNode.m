/************************************
 ProgressiveNode.m
 
 Created by Jacob Israel on 3/14/18.
 Copyright © 2018 Jacob Israel. All rights reserved.
 ************************************/
#import "ProgressiveNode.h"

@implementation ProgressiveNode{
@protected 
    uint64_t myValue;
}

-(instancetype) initWithValue:(uint64_t) value{
    self = [super init];
    myValue = value;
    return self;
}

-(uint64_t) value{return myValue;}
// For subclasses (Internal use only)
-(void) setMyValue:(uint64_t)newValue{ myValue = newValue; }

-(NSDictionary*) dictionaryRepresentation{
    NSLog(@"Implement in subclass");
    return nil;
}
-(instancetype) initFromDictionaryRepresentation:(NSDictionary*) dictionary{
    NSLog(@"Implement in subclass");
    return nil;
}
@end
