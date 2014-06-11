//
//  LanguageProcessing.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 6/9/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "LanguageProcessing.h"

@implementation LanguageProcessing

+(NSDictionary *)processWord:(NSString *)string{
    NSDictionary *dictionary = [NSDictionary new];
    
    NSString *newString = @"NBA coaching sources have told ESPN.com's Marc Stein that the Cleveland Cavaliers' recent pitch to Kentucky coach John Calipari was actually a 10-year offer worth nearly $80 million and included the role of coach and team president.";
    
    NSInteger options = NSLinguisticTaggerOmitWhitespace | NSLinguisticTaggerOmitPunctuation | NSLinguisticTaggerJoinNames;
    NSLinguisticTagger *wordTagger = [[NSLinguisticTagger alloc] initWithTagSchemes:@[NSLinguisticTagSchemeLanguage, NSLinguisticTagSchemeLemma, NSLinguisticTagSchemeNameTypeOrLexicalClass]
                                                                            options:options];
    
    [wordTagger setString:newString];
    [wordTagger setOrthography:[NSOrthography orthographyWithDominantScript:@"Latn" languageMap:@{@"Latn": @[@"en"]}] range:NSMakeRange(0, newString.length)];
    
    NSInteger sentenceCounter = 0;
    NSRange currentSentence = [wordTagger sentenceRangeForRange:NSMakeRange(0, 1)];
    while (currentSentence.location != NSNotFound) {
        __block NSInteger tokenPosition = 0;
        [wordTagger enumerateTagsInRange:currentSentence scheme:NSLinguisticTagSchemeNameTypeOrLexicalClass options:options usingBlock:^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop) {
            NSString *token = [newString substringWithRange:tokenRange];
            NSString *lemma = [wordTagger tagAtIndex:tokenRange.location scheme:NSLinguisticTagSchemeLemma tokenRange: NULL sentenceRange:NULL];
            if (lemma == nil) {
                lemma = token;
            }
//            [self.delegate receiveWord:@{@"token": token,@"postag": tag, @"lemma": lemma, @"position":  @(tokenPosition), @"sentence": @(sentenceCounter)}];
            tokenPosition++;
        }];
        sentenceCounter++;
        if (currentSentence.location + currentSentence.length == [newString length]) {
            currentSentence.location = NSNotFound;
        } else {
            NSRange nextSentence = NSMakeRange(currentSentence.location + currentSentence.length + 1, 1);
            currentSentence = [wordTagger sentenceRangeForRange:nextSentence];
            NSLog(@"current sentence is %@", NSStringFromRange(currentSentence));
        }
    }
    
    
    return dictionary;
}

@end
