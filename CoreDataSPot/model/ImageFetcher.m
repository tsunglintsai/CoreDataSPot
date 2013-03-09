//
//  ImageFetcher.m
//  SPoT
//
//  Created by Daniela on 2/28/13.
//  Copyright (c) 2013 Pyrogusto Studio. All rights reserved.
//

#import "ImageFetcher.h"

#define PHOTO_CACHE_PLIST_FILENAME @"CachePropertyList"
#define MAX_CACHE_SIZE 1024*1024*5 // 5MB


@interface ImageFetcher()<NSURLConnectionDelegate>{
    dispatch_semaphore_t sema;
    ProgressBlock callBackBlock;
}
@property (strong, nonatomic) NSMutableData *responseData; //stores the image data as it's being downloaded
@property (readwrite,nonatomic) long imageFileSize; //'expected' file size in bytes
@property (strong, nonatomic) NSURLConnection *connection; //the asynchronous network connection that you can send messages to
@end

@implementation ImageFetcher

-(UIImage*)getImageFromURL:(NSURL*)url{
    UIImage *result;
    NSURL *imageFileURL = [self imageFileURLFromInternetURL:url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageFileURL];
    if(imageData){ // if file not found download image from internet
        result = [UIImage imageWithData:imageData];
    }else{
        result = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]]; // simulate latency
        [UIImageJPEGRepresentation(result, 1.0) writeToURL:imageFileURL atomically:YES];
    }
    [self cleanupCache];
    return result;
}

-(UIImage*)getImageFromURL:(NSURL*)url WithProgressBlock:(ProgressBlock)block{
    UIImage *result;
    NSURL *imageFileURL = [self imageFileURLFromInternetURL:url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageFileURL];
    if(imageData){ // if file not found download image from internet
        result = [UIImage imageWithData:imageData];
    }else{
        callBackBlock = block;
        sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:url];
            NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
            if (theConnection) {}
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        result = [UIImage imageWithData:self.responseData];
        [UIImageJPEGRepresentation(result, 1.0) writeToURL:imageFileURL atomically:YES];
    }
    [self cleanupCache];
    return result;
}

-(void) cleanupCache{
    while([self totalCacheFileSizeInDisk]>MAX_CACHE_SIZE){
        [[NSFileManager defaultManager]removeItemAtURL:[self oldestImageFileURL] error:nil];
    }
}

-(NSURL*) oldestImageFileURL{
    NSMutableArray *fileURLs = [[NSMutableArray alloc]init];
    for(NSURL *fileUrl  in [[[NSFileManager alloc]init] contentsOfDirectoryAtURL:[self imageFolderUrl] includingPropertiesForKeys:@[NSURLContentAccessDateKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil]){
        [fileURLs addObject:fileUrl];
    }
    [fileURLs sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate *dateForFile1,*dateForFile2;
        [obj1 getResourceValue:&dateForFile1 forKey:NSURLContentAccessDateKey error:nil];
        [obj2 getResourceValue:&dateForFile2 forKey:NSURLContentAccessDateKey error:nil];
        return [dateForFile2 compare:dateForFile1]; // sort file in access order, oldest one be back
    }];
    return [fileURLs lastObject];
}

-(float) totalCacheFileSizeInDisk{ // in bytes
    float result = 0;
    for(NSURL *fileUrl  in [[[NSFileManager alloc]init] contentsOfDirectoryAtURL:[self imageFolderUrl] includingPropertiesForKeys:@[NSURLNameKey,NSURLContentAccessDateKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil]){
        result+= [self getFileSize:fileUrl];
    }
    return result;
}

-(NSURL*)imageFileURLFromInternetURL:(NSURL*)internetURL{
    return [[self imageFolderUrl] URLByAppendingPathComponent:[internetURL lastPathComponent]];
}

-(float) getFileSize: (NSURL*) fileUrl{ //  get image size in bytes
    // Get file attributes
    NSDictionary* attributeDict = [[NSFileManager defaultManager] attributesOfItemAtPath:[fileUrl path] error:nil];
    // Get size attribute
    NSNumber* fileSizeObj = [attributeDict objectForKey:NSFileSize];
    return fileSizeObj.floatValue;
}

-(NSURL*)imageFolderUrl{
    NSFileManager* fileManager = [[NSFileManager alloc]init];// don't use defaultFilemanager, it's not thread safe
    NSURL *result = [[fileManager URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil]URLByAppendingPathComponent:@"image"];
    return result;
}

-(void) createImageFolder{
    NSFileManager* fileManager = [[NSFileManager alloc]init];// don't use defaultFilemanager, it's not thread safe
    [fileManager createDirectoryAtURL:[self imageFolderUrl] withIntermediateDirectories:YES attributes:nil error:nil];
}

#pragma mark - NSURLConnection deleagte

-(NSMutableData*)responseData{
    if(!_responseData){
        _responseData = [[NSMutableData alloc]init];
    }
    return _responseData;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
    self.imageFileSize = [response expectedContentLength];
    callBackBlock([self.responseData length],self.imageFileSize);
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.responseData appendData:data];
    callBackBlock([self.responseData length],self.imageFileSize);
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    dispatch_semaphore_signal(sema);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    dispatch_semaphore_signal(sema);
    callBackBlock([self.responseData length],self.imageFileSize);
}
@end
