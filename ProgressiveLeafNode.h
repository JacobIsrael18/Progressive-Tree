/************************************
  ProgressiveLeafNode.h

  Created by Jacob Israel. on 3/14/18.
  Copyright  © 2018 - ∞  Jacob Israel . All rights reserved.
************************************/
#import "ProgressiveNode.h"

extern const NSString* MY_OBJECT_KEY;

@interface ProgressiveLeafNode : ProgressiveNode

-(instancetype) initWithObject:(NSObject*) object andKey:(uint64_t) key;

-(NSObject*) object;
@end
