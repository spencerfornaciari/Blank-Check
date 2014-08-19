//
//  ValueController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 8/19/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "ValueController.h"

@implementation ValueController

+(NSString *)careerSearchWithString:(NSString *)title {
    
    NSDictionary *careerDictionary = @{
                                       @"SOFTWARE ENGINEER":@"SOFTWARE ENGINEER",
                                       @"APPLICATION PROGRAMMER":@"SOFTWARE ENGINEER",
                                       @"APPLICATION DEVELOPER":@"SOFTWARE ENGINEER",
                                       @"APPLICATION DEVELOPER II":@"SOFTWARE ENGINEER",
                                       @"APPLICATION DEVELOPER III":@"SOFTWARE ENGINEER",
                                       @"APPLICATION DEVELOPER - SOFTWARE":@"SOFTWARE ENGINEER",
                                       @"APPLICATION DEVELOPMENT ENGINEER":@"SOFTWARE ENGINEER",
                                       @"APPLICATION DEVELOPMENT ENGINEER II":@"SOFTWARE ENGINEER",
                                       @"APPLICATION ENGINEER":@"SOFTWARE ENGINEER",
                                       @"APPLICATION ENGINEER II":@"SOFTWARE ENGINEER",
                                       @"APPLICATIONS ENGINEER":@"SOFTWARE ENGINEER",
                                       @"COMPUTER PROGRAMMER":@"SOFTWARE ENGINEER",
                                       @"COMPUTER PROGRAMMER I":@"SOFTWARE ENGINEER",
                                       @"COMPUTER PROGRAMMER II":@"SOFTWARE ENGINEER",
                                       @"COMPUTER SCIENTIST":@"SOFTWARE ENGINEER",
                                       @"COMPUTER SOFTWARE ENGINEER":@"SOFTWARE ENGINEER",
                                       @".NET DEVELOPER":@"SOFTWARE ENGINEER",
                                       @"C# DEVELOPER":@"SOFTWARE ENGINEER",
                                       @"DOT NET / C# DEVELOPER":@"SOFTWARE ENGINEER",
                                       @"DOT NET DEVELOPER":@"SOFTWARE ENGINEER",
                                       @"ENGINEER":@"SOFTWARE ENGINEER",
                                       @"ENGINEER - SOFTWARE":@"SOFTWARE ENGINEER",
                                       @"GIS/SOFTWARE DEVELOPER":@"SOFTWARE ENGINEER",
                                       @"PROGRAMMER":@"SOFTWARE ENGINEER",
                                       
                                       @"SOFTWARE DEVELOPER":@"SOFTWARE DEVELOPER",
                                       @"CONSULTANT/DEVELOPER":@"SOFTWARE DEVELOPER",
                                       
                                       @"BUSINESS ANALYST":@"BUSINESS ANALYST",
                                       @"COMPUTER PROGRAM ANALYST":@"BUSINESS ANALYST",
                                       @"STRATEGY ANALYST":@"BUSINESS ANALYST",
                                       @"BUSINESS STRATEGY ANALYST":@"BUSINESS ANALYST",
                                       @"BUSINESS SYSTEMS ANALYST":@"BUSINESS ANALYST",
                                       @"BUSINESS SYSTEMS INTEGRATOR ANALYST":@"BUSINESS ANALYST",
                                       @"BUSINESS ASSOCIATE":@"BUSINESS ANALYST",
                                       @"STRATEGY ASSOCIATE":@"BUSINESS ANALYST",
                                       @"BUSINESS SYSTEMS ASSOCIATE":@"BUSINESS ANALYST",
                                       @"APPLICATION SOFTWARE ANALYST":@"BUSINESS ANALYST",
                                       @"APPLICATIONS ANALYST":@"BUSINESS ANALYST",
                                       @"APPLICATIONS ANALYST/DEVELOPER":@"BUSINESS ANALYST",
                                       @"APPLICATIONS SUPPORT SENIOR ANALYST":@"BUSINESS ANALYST",
                                       @"ASSOCIATE - BUSINESS ANALYTICS":@"BUSINESS ANALYST",
                                       @"ASSOCIATE":@"BUSINESS ANALYST",
                                       @"ASSOCIATE ANALYST":@"BUSINESS ANALYST",
                                       @"ASSOCIATE ANALYST 1":@"BUSINESS ANALYST",
                                       @"ASSOCIATE ANALYST II":@"BUSINESS ANALYST",
                                       @"ASSOCIATE BUSINESS ANALYST":@"BUSINESS ANALYST",
                                       @"ASSOCIATE CONSULTANT - IT":@"BUSINESS ANALYST",
                                       @"BUSINESS STRATEGY AND DEVELOPMENT ANALYST":@"BUSINESS ANALYST",
                                       @"BUSINESS SYSTEMS ANALYST I":@"BUSINESS ANALYST",
                                       @"BUSINESS SYSTEMS ANALYST II":@"BUSINESS ANALYST",
                                       @"BUSINESS SYSTEMS ANALYST III":@"BUSINESS ANALYST",
                                       @"BUSINESS SYSTEMS ANALYST IV":@"BUSINESS ANALYST",
                                       @"BUSINESS/SYSTEMS ANALYST":@"BUSINESS ANALYST",
                                       @"COMPUTER DATA ANALYST":@"BUSINESS ANALYST",
                                       @"COMPUTER SYSTEM ANALYST":@"BUSINESS ANALYST",
                                       @"COMPUTER SYSTEMS ANALYST":@"BUSINESS ANALYST",
                                       @"CONSULTANT SYSTEMS ANALYST":@"BUSINESS ANALYST",
                                       @"CONSUMER RESEARCH ANALYST":@"BUSINESS ANALYST",
                                       @"CONSUMER STRATEGIC ANALYST III":@"BUSINESS ANALYST",
                                       @"DATA ANALYST":@"BUSINESS ANALYST",
                                       @"REPORTING ANALYST":@"BUSINESS ANALYST",
                                       @"DATA SYSTEM ANALYST":@"BUSINESS ANALYST",
                                       @"DATA STRATEGIC ANALYST":@"BUSINESS ANALYST",
                                       @"GLOBAL PLANNING ANALYST":@"BUSINESS ANALYST",
                                       @"GLOBAL INDUSTRY ANALYST":@"BUSINESS ANALYST",
                                       @"GLOBAL LOGISTICS ANALYST":@"BUSINESS ANALYST",
                                       @"HR SYSTEMS ANALYST":@"BUSINESS ANALYST",
                                       @"MARKET AND PRICING ANALYST":@"BUSINESS ANALYST",
                                       @"MARKET DATA ANALYST":@"BUSINESS ANALYST",
                                       @"MARKET DEVELOPMENT ANALYST":@"BUSINESS ANALYST",
                                       @"MARKET RISK ANALYST":@"BUSINESS ANALYST",
                                       @"MARKET RISK REPORTING ANALYST":@"BUSINESS ANALYST",
                                       @"QUANTITATIVE ANALYST":@"BUSINESS ANALYST",
                                       @"RISK ANALYST":@"BUSINESS ANALYST",
                                       
                                       @"SENIOR CONSULTANT":@"SENIOR CONSULTANT",
                                       
                                       @"CONSULTANT":@"CONSULTANT",
                                       @"COMPUTER CONSULTANT":@"CONSULTANT",
                                       @"CONSULTANT 1":@"CONSULTANT",
                                       @"CONSULTANT 2":@"CONSULTANT",
                                       @"CONSULTANT 3":@"CONSULTANT",
                                       @"CONSULTANT, SYSTEMS ANALYSIS":@"CONSULTANT",
                                       @"CONSULTANT, BUSINESS ANALYTICS":@"CONSULTANT",
                                       @"CONSULTANT, DATA MANAGEMENT":@"CONSULTANT",
                                       @"CONSULTANT PRODUCT MANAGER":@"CONSULTANT",
                                       @"MANAGING CONSULTANT STRY":@"CONSULTANT",
                                       @"MANAGING CONSULTANT, BRAND AND PORTFOLIO STRATEGY":@"CONSULTANT",
                                       @"PROJECT FINANCIAL ANALYST":@"CONSULTANT",
                                       
                                       @"SENIOR SOFTWARE ENGINEER":@"SENIOR SOFTWARE ENGINEER",
                                       @"ENGINEERING SENIOR":@"SENIOR SOFTWARE ENGINEER",
                                       
                                       @"PROJECT MANAGER":@"PROJECT MANAGER",
                                       @"PROJECT LEADER":@"PROJECT MANAGER",
                                       @"PROJECT MANAGER I":@"PROJECT MANAGER",
                                       @"PROJECT MANAGER II":@"PROJECT MANAGER",
                                       @"PROJECT MANAGER III":@"PROJECT MANAGER",
                                       
                                       @"DATABASE ADMINISTRATOR":@"DATABASE ADMINISTRATOR",
                                       
                                       @"ASSISTANT PROFESSOR":@"ASSISTANT PROFESSOR",
                                       
                                       @"WEB DEVELOPER":@"WEB DEVELOPER",
                                       
                                       @"MECHANICAL ENGINEER":@"MECHANICAL ENGINEER",
                                       
                                       @"ACCOUNTANT":@"ACCOUNTANT",
                                       @"FUND ACCOUNTING ANALYST":@"ACCOUNTANT",
                                       @"FUND ACCOUNTING SPECIALIST":@"ACCOUNTANT",
                                       @"GENERAL ACCOUNTANT":@"ACCOUNTANT",
                                       @"GENERAL ACCOUNTANT 1":@"ACCOUNTANT",
                                       @"GENERAL ACCOUNTANT I":@"ACCOUNTANT",
                                       @"GENERAL ACCOUNTANT II":@"ACCOUNTANT",
                                       @"GENERAL ACCOUNTANT III":@"ACCOUNTANT",
                                       @"GENERAL LEDGER ACCOUNTANT":@"ACCOUNTANT",
                                       
                                       @"FINANCIAL ANALYST":@"FINANCIAL ANALYST",
                                       @"FINANCIAL REPORTING ANALYST":@"FINANCIAL ANALYST",
                                       @"FINANCIAL ANALYST - CORPORATE FINANCE":@"FINANCIAL ANALYST",
                                       @"FINANCIAL ANALYST / ACCOUNTANT":@"FINANCIAL ANALYST",
                                       @"FINANCIAL ANALYST AND MARKETING COORDINATOR":@"FINANCIAL ANALYST",
                                       @"FINANCIAL ANALYST- DERIVATIVES TRADER":@"FINANCIAL ANALYST",
                                       @"FINANCIAL ANALYST I":@"FINANCIAL ANALYST",
                                       @"FINANCIAL ANALYST II":@"FINANCIAL ANALYST",
                                       @"FINANCIAL ANALYST, ASIAN MARKETS":@"FINANCIAL ANALYST",
                                       @"FINANCIAL ANALYST, DERIVATIVES TRADER":@"FINANCIAL ANALYST",
                                       @"FINANCIAL ANALYST, FINANCIAL PLANNING & ANALYSIS":@"FINANCIAL ANALYST",
                                       @"FINANCIAL ANALYST, POLYFINANCE":@"FINANCIAL ANALYST",
                                       @"FINANCIAL ANALYST, PRIVATE EQUITY":@"FINANCIAL ANALYST",
                                       @"FINANCIAL AND PLANNING ANALYST":@"FINANCIAL ANALYST",
                                       @"FINANCIAL PLANNING ANALYST":@"FINANCIAL ANALYST",
                                       @"FINANCIAL PLANNING AND BUDGET ANALYST":@"FINANCIAL ANALYST",
                                       @"FINANCIAL QUALITATIVE ANALYST":@"FINANCIAL ANALYST",
                                       @"FINANCIAL QUANTITATIVE ANALYST":@"FINANCIAL ANALYST",
                                       @"FINANCIAL QUANTITATIVE ANALYSTS":@"FINANCIAL ANALYST",
                                       @"FINANCIAL QUANTITATIVE RISK ANALYST":@"FINANCIAL ANALYST",
                                       @"FINANCIAL RESEARCH ANALYST":@"FINANCIAL ANALYST",
                                       @"FINANCIAL RISK ANALYST I":@"FINANCIAL ANALYST",
                                       @"FINANCIAL RISK ANALYST II":@"FINANCIAL ANALYST",
                                       @"FINANCIAL RISK ANALYST III":@"FINANCIAL ANALYST",
                                       @"FUND ANALYST":@"FINANCIAL ANALYST",
                                       
                                       @"POSTDOCTORAL FELLOW":@"POSTDOCTORAL FELLOW",
                                       @"POSTDOCTORAL ASSOCIATE":@"POSTDOCTORAL FELLOW",
                                       @"POSTDOCTORAL RESEARCH ASSOCIATE":@"POSTDOCTORAL FELLOW",
                                       @"POSTDOCTORAL SCHOLAR":@"POSTDOCTORAL FELLOW",
                                       @"POSTDOCTORAL RESEARCHER I":@"POSTDOCTORAL FELLOW",
                                       @"POSTDOCTORAL RESEARCHER II":@"POSTDOCTORAL FELLOW",
                                       @"POSTDOCTORAL RESEARCHER III":@"POSTDOCTORAL FELLOW",
                                       @"POSTDOCTORAL RESEARCH FELLOW I":@"POSTDOCTORAL FELLOW",
                                       @"POSTDOCTORAL RESEARCH FELLOW II":@"POSTDOCTORAL FELLOW",
                                       @"POSTDOCTORAL RESEARCH FELLOW III":@"POSTDOCTORAL FELLOW",
                                       
                                       @"INDUSTRIAL DESIGNER":@"INDUSTRIAL DESIGNER",
                                       @"COMMERCIAL AND INDUSTRIAL DESIGNER":@"INDUSTRIAL DESIGNER",
                                       @"INDUSTRIAL AND OPERATION DESIGNER":@"INDUSTRIAL DESIGNER",
                                       @"INDUSTRIAL DESIGNER (MANUFACTURING SYSTEMS)":@"INDUSTRIAL DESIGNER",
                                       
                                       @"MARKET RESEARCH ANALYST":@"MARKET RESEARCH ANALYST",
                                       @"MARKETING & RESEARCH ANALYST":@"MARKET RESEARCH ANALYST",
                                       @"MARKETING ANALYTICS PROFESSIONAL":@"MARKET RESEARCH ANALYST",
                                       
                                       @"PHYSICIAN":@"PHYSICIAN",
                                       @"DOCTOR":@"PHYSICIAN",
                                       @"ADULT MEDICINE PHYSICIAN":@"PHYSICIAN",
                                       
                                       @"PRODUCT MANAGER":@"PRODUCT MANAGER",
                                       @"PRODUCER":@"PRODUCT MANAGER",
                                       @"PRODUCT MANAGER I":@"PRODUCT MANAGER",
                                       @"PRODUCT MANAGER II":@"PRODUCT MANAGER",
                                       @"PRODUCT MANAGER III":@"PRODUCT MANAGER",
                                       @"PRODUCT MANAGER 1":@"PRODUCT MANAGER",
                                       @"PRODUCT MANAGER 2":@"PRODUCT MANAGER",
                                       @"PRODUCT MANAGER 3":@"PRODUCT MANAGER",
                                       @"PRODUCT MANAGEMENT 1":@"PRODUCT MANAGER",
                                       @"PRODUCT MANAGEMENT 2":@"PRODUCT MANAGER",
                                       @"PRODUCT MANAGEMENT 3":@"PRODUCT MANAGER",
                                       
                                       @"OTHER":@"OTHER"
                                       };
    
    NSArray *careerArray = [careerDictionary allKeys];
    
    NSPredicate *careerPredicate = [NSPredicate predicateWithFormat:@"%@ MATCHES[CD] description", title];
    NSArray *filtered = [careerArray filteredArrayUsingPredicate:careerPredicate];
    
    if (filtered.count > 0) {
        return filtered[0];
        //            if (finalNumber == nil) {
        //                finalNumber = [jobDictionary objectForKey:job.name];
        //            } else if (finalNumber) {
        //                if ([jobDictionary objectForKey:job.name] < finalNumber) {
        //                    finalNumber = [jobDictionary objectForKey:job.name];
        //                } else {
        //
        //                }
        //            }
    } else {
        return @"OTHER";
    }
    
//    for (NSString *string in careerArray) {
//        //        NSLog(@"Job: %@", job.name);
//        
//        
//    }

}

+(NSArray *)jobValue:(NSString *)title {
    NSDictionary *jobDictionary = @{@"SOFTWARE ENGINEER":@[@"$75,411",@"$27,877", @"37.0%"],
                                    @"SOFTWARE DEVELOPER":@[@"$72,510",@"$10,980", @"15.1%"],
                                    @"BUSINESS ANALYST":@[@"$65,841",@"$5,482",@"8.3%"],
                                    @"SENIOR CONSULTANT":@[@"$95,902",@"$4,761",@"5.0%"],
                                    @"CONSULTANT":@[@"$77,411",@"$6,713",@"8.7%"],
                                    @"SENIOR SOFTWARE ENGINEER":@[@"$90,055",@"$20,534",@"22.8%"],
                                    @"PROJECT MANAGER":@[@"$78,305",@"$12,875",@"16.4%"],
                                    @"DATABASE ADMINISTRATOR":@[@"$66,410",@"$4,013",@"6.0%"],
                                    @"ASSISTANT PROFESSOR":@[@"$98,770",@"-$5,693",@"-5.8%"],
                                    @"WEB DEVELOPER":@[@"$64,494",@"$7,376",@"11.4%"],
                                    @"MECHANICAL ENGINEER":@[@"$68,844",@"$9,663",@"14.0%"],
                                    @"ACCOUNTANT":@[@"$50,282",@"$3,506",@"7.0%"],
                                    @"FINANCIAL ANALYST":@[@"$64,146",@"$9,733",@"15.2%"],
                                    @"POSTDOCTORAL FELLOW":@[@"$45,806",@"$3,505",@"7.7%"],
                                    @"INDUSTRIAL DESIGNER":@[@"$54,071",@"$19,002",@"35.1%"],
                                    @"MARKET RESEARCH ANALYST":@[@"$48,118",@"$4,314",@"9.0%"],
                                    @"PHYSICIAN":@[@"$157,355",@"$38,693",@"24.6%"],  // @[@157355, @38693, @24.6],
                                    @"PRODUCT MANAGER":@[@"$95,024",@"$17,898",@"18.8%"],
                                    @"OTHER":@[@"$50,000",@"$7,122",@"14.2%"]
                                    };
    
    
    return [jobDictionary valueForKey:title];
}

@end
