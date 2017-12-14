//
//  Logger.h
//  Hajirakhata
//
//  Created by Mujtahid Akon on 13/12/17.
//  Copyright © 2017 Mujtahid Akon. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSLog(args...) _Log(@"DEBUG ", __FILE__,__LINE__,__PRETTY_FUNCTION__,args);

@interface Logger : NSObject
    void _Log(NSString *prefix, const char *file, int lineNumber, const char *funcName, NSString *format,...);
@end
