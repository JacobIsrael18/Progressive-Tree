//  ProgressiveLeafNode.m
 
//  Created by newcomp on 3/14/18.
//  Copyright © 2018 JacobIsrael. All rights reserved.
//

#import "ProgressiveLeafNode.h"

@implementation ProgressiveLeafNode{
@protected
    NSObject* myObject;
}

-(instancetype) initWithObject:(NSObject*) object andValue:(uint64_t) value{
    self = [super initWithValue: value];
    myObject = object;
    return self;
}

-(NSObject*) object{
    return myObject;
}

-(NSDictionary*) dictionaryRepresentation{
    NSMutableDictionary* output = [NSMutableDictionary new];
    output[@"myObject"] = myObject; 
    return  output;
}

-(instancetype) initFromDictionaryRepresentation:(NSDictionary*) dictionary{
    self = [super init];
      myObject = dictionary[@"myObject"];  
    return self;
}
@end
