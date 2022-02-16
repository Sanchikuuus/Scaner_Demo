//
//  GPUImageWrapper.m
//  Scaner Demo
//
//  Created by Sashko Shel on 15.02.2022.
//

#import "GPUImageWrapper.h"
#import <GPUImage/GPUImage.h>

@implementation GPUImageWrapper

#pragma mark Public

+ (UIImage *)processUsingGPUImage:(UIImage*)input {
  
  // 1. Create the GPUImagePictures
  GPUImagePicture* inputGPUImage = [[GPUImagePicture alloc] initWithImage:input];
  
//  UIImage* ghostImage = [self createPaddedGhostImageWithSize:input.size];
//  GPUImagePicture* ghostGPUImage = [[GPUImagePicture alloc] initWithImage:ghostImage];

  // 2. Set up the filter chain
  GPUImageAlphaBlendFilter* alphaBlendFilter = [[GPUImageAlphaBlendFilter alloc] init];
  alphaBlendFilter.mix = 0.5;
  
  [inputGPUImage addTarget:alphaBlendFilter atTextureLocation:0];
//  [ghostGPUImage addTarget:alphaBlendFilter atTextureLocation:1];
  
  GPUImagePixellateFilter* pixellateFilter = [[GPUImagePixellateFilter alloc] init];
  
  [alphaBlendFilter addTarget:pixellateFilter];
  
  // 3. Process & grab output image
  [pixellateFilter useNextFrameForImageCapture];
  [inputGPUImage processImage];
//  [ghostGPUImage processImage];
  
  UIImage* output = [pixellateFilter imageFromCurrentFramebuffer];
  
  return output;
}

@end
