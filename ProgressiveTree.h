/******************************************
 ProgressiveTree.h

 Created by Jacob Israel on 3/13/18.
 Copyright © 2018 Jacob Israel. All rights reserved.
 ******************************************/
#import <Foundation/Foundation.h>
#import "ProgressiveNode.h"

@interface ProgressiveTree : NSObject

-(NSObject*) findObjectWithValue:(uint64_t) value;
-(void) addObject:(NSObject*) object withValue:(uint64_t) value;
-(void) removeObjectWithValue:(uint64_t) value;



// Convenience methods
-(BOOL) isEmpty;
-(ProgressiveNode*) topNode;
-(uint16_t) getTreeDepth;

-(NSDictionary*) dictionaryRepresentation;
-(instancetype) initFromDictionaryRepresentation:(NSDictionary*) dictionary;
@end
