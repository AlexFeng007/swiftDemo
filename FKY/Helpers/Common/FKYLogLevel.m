//
//  FKYLogLevel.m
//  FKY
//
//  Created by Rabe on 09/08/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//

#import "FKYLogLevel.h"

@import CocoaLumberjack.DDLegacyMacros;

DDLogLevel ddLogLevel =
#ifdef DEBUG
DDLogLevelVerbose;
#else
//LOG_LEVEL_WARN;
DDLogLevelWarning;
#endif
