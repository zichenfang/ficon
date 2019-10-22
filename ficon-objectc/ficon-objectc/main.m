//
//  main.m
//  ficon-objectc
//
//  Created by 方子辰 on 2019/10/22.
//  Copyright © 2019 方子辰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

int testA(int a);

int testA(int a){
    return a;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        BOOL exit = NO;
        while (exit ==NO) {
            char sourceFilePathChar[200] = {0};
            NSLog(@"拖拽文件到此处并回车(输入q退出):");
            scanf("%s",sourceFilePathChar);
            NSString *sourceFilePath = [NSString stringWithUTF8String:sourceFilePathChar];
            //获取图片
            NSImage *sourceImage =[[NSImage alloc] initWithContentsOfFile:sourceFilePath];
            if ([sourceFilePath isEqualToString:@"q"]||[sourceFilePath isEqualToString:@"Q"]) {
                exit =YES;
                break;
            }
            if (sourceImage ==nil) {
                NSLog(@"无效的文件，请重新输入");
                continue;
            }
    //        char saveFilePathChar[200] = {0};
    //        printf("输入目标存储路径并回车:");
    //        scanf("%s",saveFilePathChar);
    //        NSString *saveFilePath = [NSString stringWithUTF8String:saveFilePathChar];
            NSString *saveFilePath=[[NSBundle mainBundle] resourcePath];
            NSLog(@"保存到=%@",saveFilePath);

            NSArray *sizeArray = @[@1024,@180,@167,@152,@120,@87,@80,@60,@58,@40,@29,@20];
            for (NSNumber *size in sizeArray) {
                float width = [size doubleValue];
                float height = [size doubleValue];
                
                NSImage *smallImage = [[NSImage alloc] initWithSize: CGSizeMake(width, height)];
                [smallImage lockFocus];
                [sourceImage setSize: CGSizeMake(width, height)];
                [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
                [sourceImage drawAtPoint:NSZeroPoint fromRect:CGRectMake(0,0,sourceImage.size.width,sourceImage.size.height) operation:NSCompositingOperationCopy fraction:1.0];
                [smallImage unlockFocus];

                NSData *imageData = [smallImage TIFFRepresentation];

                BOOL isSuccess = [imageData writeToFile:[NSString stringWithFormat:@"%@/%.0fx%.0f.jpeg",saveFilePath,width,height]atomically:YES];    //保存的文件路径一定要是绝对路径，相对路径不行
                NSLog(@"%.0fx%.0f saved %@",width,height,isSuccess?@"success":@"faild");

            }
            exit =YES;
            NSLog(@"------------完成------------");

        }
        
        
        
        
    }
    return 0;
}
