//
//  LdsHttpRequest.h
//  Pods
//
//  Created by 廖亚雄 on 2020/5/6.
//

#import <Foundation/Foundation.h>



@interface LdsHttpRequest : NSObject
/// 请求URL
@property(nonatomic, copy, nonnull) NSString *url;
/// method （post,get,put,delete,patch,head），不传默认为get
@property(nonatomic, copy, nullable) NSString *method;
/// 超时时长,不传默认为60s
@property(nonatomic, assign) NSTimeInterval timeoutInterval;
/// http 请求参数，统一拼接到URL上
@property(nonatomic, strong, nullable) NSDictionary *parameters;
/// 请求体
@property(nonatomic, strong, nullable) NSDictionary *body;
/// 请求头
@property(nonatomic, strong, nullable) NSDictionary *header;

/// 抽象接口
/// @param progress 进度，选填。
/// @param success 成功回调
/// @param failure 失败回调
- (void)requestOnProgress:(void (^_Nullable)(NSProgress * _Nullable))progress onSuccess:(void (^_Nullable)(id _Nullable))success onError:(void (^_Nullable)(NSError * _Nullable))failure;
@end

@interface LdsHttpUploadFileInfo : NSObject
@property(nonatomic, copy) NSString * _Nonnull mimeType;//指定数据的MIME类型。 （例如，JPEG图像的MIME类型为image/jpeg。）有关有效MIME类型的列表，请参见http://www.iana.org/assignments/media-types/。 该参数不能为“ nil”。
@property(nonatomic, copy) NSString *_Nonnull name;//与指定数据关联的名称。 该参数不能为“ nil”。
@property(nonatomic, copy) NSString *_Nullable filePath;//"filepath"有效文件的绝对路径，上传文件路径是必传
@property(nonatomic, strong) NSData *_Nullable fileData;//文件流数据，上传文件流时必传
@property(nonatomic, copy) NSString *_Nonnull fileName;//"fileName"与指定数据关联的文件名。 该参数不能为“ nil”,
@end


@protocol LdsHttpUploadProtocol <NSObject>
@property(nonatomic, copy) NSArray <LdsHttpUploadFileInfo*> * _Nonnull fileInfos;
@end
@protocol LdsHttpDownloadProtocol <NSObject>
@property(nonatomic, copy) NSString *_Nonnull destination;//文件下载完成后的存放地址
@end
@interface LdsHttpUploadRequest : LdsHttpRequest <LdsHttpUploadProtocol>
@end
@interface LdsHttpDownloadRequest : LdsHttpRequest <LdsHttpDownloadProtocol>
@end


