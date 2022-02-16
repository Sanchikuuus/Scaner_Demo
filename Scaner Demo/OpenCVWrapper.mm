//
//  OpenCVWrapper.m
//  Scaner Demo
//
//  Created by Sashko Shel on 15.02.2022.
//

#import "OpenCVWrapper.h"
#import <opencv2/opencv.hpp>

@implementation OpenCVWrapper

using namespace cv;

+(NSString * ) openCVVersionString {
    return [NSString stringWithFormat: @ "OpenCV Version %s", CV_VERSION];
}

#pragma mark Public
    +(UIImage * ) toGray: (UIImage * ) source {
//        std::cout << "OpenCV: ";
        return [OpenCVWrapper _imageFrom: [OpenCVWrapper _grayFrom: [OpenCVWrapper _matFrom: source]]];
    }

    +(UIImage * ) rotateCW: (UIImage * ) source {
    //        std::cout << "OpenCV: ";
        return [OpenCVWrapper _imageFrom: [OpenCVWrapper _rotateFrom: [OpenCVWrapper _matFrom: source]]];
    }

#pragma mark Private
    +(Mat) _grayFrom: (Mat) source {
//        std::cout << "-> grayFrom ->";
        cv::Mat result;
        cvtColor(source, result, COLOR_BGR2GRAY);
        return result;
    }

    +(Mat) _rotateFrom: (Mat) source {
    //        std::cout << "-> grayFrom ->";
        cv::Mat result;
        transpose(source, source);
        flip(source, source ,1);
        return source;
    }

    +(Mat) _matFrom: (UIImage * ) source {
//        std::cout << "matFrom ->";
        CGImageRef image = CGImageCreateCopy(source.CGImage);
        CGFloat cols = CGImageGetWidth(image);
        CGFloat rows = CGImageGetHeight(image);
        Mat result(rows, cols, CV_8UC4);
        CGBitmapInfo bitmapFlags = kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault;
        size_t bitsPerComponent = 8;
        size_t bytesPerRow = result.step[0];
        CGColorSpaceRef colorSpace = CGImageGetColorSpace(image);
        CGContextRef context = CGBitmapContextCreate(result.data, cols, rows, bitsPerComponent, bytesPerRow, colorSpace, bitmapFlags);
        CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, cols, rows), image);
        CGContextRelease(context);
        return result;
    }

    +(UIImage * ) _imageFrom: (Mat) source {
//        std::cout << "-> imageFrom\n";
        NSData * data = [NSData dataWithBytes: source.data length: source.elemSize() * source.total()];
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef) data);
        CGBitmapInfo bitmapFlags = kCGImageAlphaNone | kCGBitmapByteOrderDefault;
        size_t bitsPerComponent = 8;
        size_t bytesPerRow = source.step[0];
        CGColorSpaceRef colorSpace = (source.elemSize() == 1 ? CGColorSpaceCreateDeviceGray() : CGColorSpaceCreateDeviceRGB());
        CGImageRef image = CGImageCreate(source.cols, source.rows, bitsPerComponent, bitsPerComponent * source.elemSize(), bytesPerRow, colorSpace, bitmapFlags, provider, NULL, false, kCGRenderingIntentDefault);
        UIImage * result = [UIImage imageWithCGImage: image];
        CGImageRelease(image);
        CGDataProviderRelease(provider);
        CGColorSpaceRelease(colorSpace);
        return result;
    }

@end
