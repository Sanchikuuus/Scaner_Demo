//
//  GPUImageWrapper.h
//  Scaner Demo
//
//  Created by Sashko Shel on 15.02.2022.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPUImageWrapper : NSObject

+ (UIImage *)processUsingGPUImage:(UIImage*)input;

@end

NS_ASSUME_NONNULL_END
