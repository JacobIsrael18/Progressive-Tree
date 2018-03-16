/************************************
  ProgressiveNode.h

  Created by Jacob Israel on 3/14/18.
  Copyright © 2018 Jacob Israel. All rights reserved.
************************************/
#import <Foundation/Foundation.h>

@interface ProgressiveNode : NSObject
-(instancetype) initWithValue:(uint64_t) value;

-(uint64_t) value;

// Serialization
-(NSDictionary*) dictionaryRepresentation;
-(instancetype) initFromDictionaryRepresentation:(NSDictionary*) dictionary;
@end
