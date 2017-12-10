//
//  UserInfo.h
//  ArchivingTest
//
//  Created by Mujtahid Akon on 5/12/17.
//  Copyright © 2017 Mujtahid Akon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject<NSCoding>
//@property (nonatomic) BOOL isStored;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

- (void)printData;
+ (void) writeData;
+ (void) writeUsername:(NSString*) username andPassword: (NSString*) password;
+ (UserInfo*) readData;

@end
