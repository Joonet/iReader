//
//  ReaderPageViewCell.m
//  iReader
//
//  Created by zzyong on 2018/7/12.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "ReaderPageViewCell.h"
#import "IREpubHeaders.h"
#import "IRHtmlModel.h"
#import "IRChapterModel.h"
#import <YYLabel.h>
#import "IRPageModel.h"
#import "IRReaderConfig.h"

@interface ReaderPageViewCell ()

@property (nonatomic, strong) YYLabel *readerPage;
@property (nonatomic, strong) NSString *chapterHtmlStr;

@end

@implementation ReaderPageViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _readerPage.frame = self.contentView.bounds;
}

- (void)setupSubviews
{
    _readerPage = [[YYLabel alloc] init];
    _readerPage.numberOfLines = 0;
    _readerPage.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
    _readerPage.textAlignment = NSTextAlignmentJustified;
    _readerPage.displaysAsynchronously = YES;
    [self.contentView addSubview:_readerPage];
}

- (void)setChapter:(IRTocRefrence *)chapter
{
    if (chapter.resource.itemId == _chapter.resource.itemId) {
        return;
    }
    
    _chapter = chapter;
    
    IRDebugLog(@"Chapter name: %@", chapter.title);
    
    NSError *error = nil;
    _chapterHtmlStr = [NSString stringWithContentsOfFile:chapter.resource.fullHref
                                                encoding:NSUTF8StringEncoding
                                                   error:&error];
    if (error) {
        IRDebugLog(@"[ReaderPageViewCell] Read chapter resource failed, error: %@", error);
        return;
    }
    
    IRChapterModel *chapterModel = [IRChapterModel modelWithHtmlModel:[IRHtmlModel modelWithHtmlString:_chapterHtmlStr]];
    YYTextContainer *container = [YYTextContainer containerWithSize:[IR_READER_CONFIG pageSize] insets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:chapterModel.contents.firstObject.content];
    _readerPage.textLayout = textLayout;
    
    [self setNeedsLayout];
}

@end