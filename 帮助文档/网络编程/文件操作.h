//
//  Copyright (c) 2014年 lichq. All rights reserved.
//


#pragma mark - 文件操作－文件操作柄，NSFileHandle

利用"文件操作柄"(也就是NSFileHandle这类物件)，我们可以更加近距离地操作文件。一般来说，操作文件需要下面三个步骤：
①、打开文件，为这个文件创建文件操作柄；
②、进行输入／输出操作；
③、关闭文件。

下面的表格  总结了  可以对文件操作柄所采取的措施：
措施名称	描述
+(NSFileHandle *)fileHandleForReadingAtPath:path	打开文件以便读取
+(NSFileHandle *)fileHandleForWritingAtPath:path	打开文件以便写入
+(NSFileHandle *)fileHandleForUpdatingAtPath:path	打开文件以便读写
-(NSData *)availableData            产生的结果为其实施对象中可用的数据
-(NSData *)readDataToEndOfFile                  "读取文件末尾处之前的数据/从当前的节点读取到文件末尾":如果一项措施直到文件末尾处都没有读取到任何数据，那么这项措施会产生出一个空的NSData类型的物件。你可以对这个NSData类型的物件采取length这项措施,从而检查是否从文件中读取到任何数据。
-(NSData *)readDataOfLength:(NSUInteger)bytes	"读取长度为bytes字节的数据/从当前节点读取制定length的长度数据"
-(void)writeData:data               将数据data写入文件
-(unsigned long long)offsetInFile	"获取当前文件中的操作位置/获取当前文件的偏移量"
-(void)seekToFileOffset:offset      "将当前文件的操作位置设定为offset/跳到指定的文件偏移量"
-(unsigned long long)seekToEndOfFile	将当前文件的操作位置设定为文件的末尾处/跳到文件末尾
-(void)truncateFileAtOffset:offset	"将文件的长度设定为offset"
-(void)closeFile	关闭文件
你应该注意：利用文件操作柄并不能创建文件。创建文件只能利用文件管理器，也就是NSFileManager这类物件。所以"向NSFileHandle这类物件  发送fileHandleForWritingAtPath:  和 fileHandleForUpdatingAtPath:这两条消息的前提  是文件必须存在，如果文件并不存在，那么NSFileHandle这类物件就会产生出空值nil"。在这两种情况之下，文件的操作位置都被设定在文件的开头处。

二： 获取一个文件的大小：
NSFileManager *defaultManger = [NSFileManager defaultManager];
NSDictionary *dic=  [defaultManger attributesOfItemAtPath:filePath error:nil];
NSNumber *fileNum = [dic objectForKey:NSFileSize];
NSLog(@"fileNum : %f",[fileNum floatValue]);




#pragma mark 文件位置的控制
如果  你打开一个文件进行读、写，那么文件的操作位置会被设定在文件的开头处。
你可以将文件操作位置设定为其它位置，再进行读、写操作，比如将文件的操作位置设定在第10个字节处，就可以这样：
[myFileHandle seekToFileOffset:10];

先获取当前的文件操作位置，然后再对这个文件操作位置加上或者减去一定的字节数，我们就可以得到一个相对的文件操作位置。比如，在当前文件操作位置的基础上  向前  跳过  128字节，可以这样：
[myFileHandle seekToFileOffset:[myFileHandleoffsetInFile]+128];

如果要将当前文件操作位置向回移动5个整数值的长度，那么我们可以利用这样的语句：
[myFileHandle seekToFileOffset:[myFileHandleoffsetInFile]-5*sizeof(int)];






#pragma mark 下面的程序  示范了如何利用文件操作柄来操作文件：
#import <Foundation/NSObject.h>
#import <Foundation/NSString.h>
#import <Foundation/NSFileHandle.h>
#import <Foundation/NSFileManager.h>
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSData.h>
int main(int argc,const char *argv[])
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    NSFileHandle *inFile,*outFile;
    NSData *buffer;
    
    //为文件testfile创建文件操作柄，以便读取数据
    inFile=[NSFileHandle fileHandleForReadingAtPath:@"testfile"];
    if(inFile==nil)
    {
        NSLog(@"打开文件失败！");
        return 1;
    }
    
    //创建文件testfile2
    [[NSFileManager defaultManager] createFileAtPath:@"testfile2" contents:nil attributes:nil];
    
    //为文件testfile2创建文件操作柄，以便写入数据
    outFile=[NSFileHandle fileHandleForWritingAtPath:@"testfile2"];
    if(outFile==nil)
    {
        NSLog(@"打开文件失败！");
        return 2;
    }
    //将文件testfile2的长度剪短为0（如果你习惯于在UNIX之下编程，你应该注意到打开文件并不能将这个文件剪短。你得自己将文件剪短。）
    [outFile truncateFileAtOffset:0];
    
    //将文件testfile中的数据读取到缓冲区buffer当中
    buffer=[inFile readDataToEndOfFile];//readDataToEndOfFile:这项措施可以读取文件末尾处之前的数据(长达xxxxx个字节的数据)。这对于你所编写的任何程序来说  都足够大了。你可以设定一个循环利用缓冲区在文件之间传输数据，这个可以通过readDataOfLength:这项措施办到。缓冲区的大小可以是8192字节或者131072字节，因为底层的操作系统一般以这种大小的数据块执行输入／输出操作。
    
    
    //将缓冲区buffer中的数据写入到文件testfile2当中
    [outFile writeData:buffer];
    
    //将两个文件关闭
    [inFile closeFile];
    [outFile closeFile];
    
    //将testfile2的内容显示出来，用以验证之前的操作是否成功
    NSLog(@"%@",[NSString stringWithContentsOfFile:@"testfile2" encoding:NSUTF8StringEncoding error:nil]);
    [pool drain];
    return 0;
}







