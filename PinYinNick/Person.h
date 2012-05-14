//  Created by Chen Yufei on 12-5-3.
//  Copyright (c) 2012. All rights reserved.

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface Person : NSObject

@property (readwrite, strong, nonatomic) NSString *nickName;
@property (readonly, strong) NSString *fullName;
@property (readonly, strong) NSString *fullNamePinyin;
@property (readonly, strong) ABPerson *abPerson;
@property (readwrite, assign, nonatomic, getter = isModified) BOOL modified;

- (id)initWithPerson:(ABPerson *)person;

@end
