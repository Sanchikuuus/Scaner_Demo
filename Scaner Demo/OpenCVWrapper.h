//
//  OpenCVWrapper.h
//  Scaner Demo
//
//  Created by Sashko Shel on 15.02.2022.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

+ (UIImage *)toGray:(UIImage *)source;
+ (UIImage *)rotateCW:(UIImage *)source;

@end

NS_ASSUME_NONNULL_END
