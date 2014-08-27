//
//  ValueController.m
//  Blank Check
//
//  Created by Spencer Fornaciari on 8/19/14.
//  Copyright (c) 2014 Blank Check Labs. All rights reserved.
//

#import "ValueController.h"
#import "Worker.h"
#import "Connection.h"
#import "Job.h"

@implementation ValueController

+(NSString *)careerSearch:(id)sender {
    
    NSDictionary *newCareerDictionary = @{
                                       @"Partner":@270755,
                                       @"Managing Partner@":@254166,
                                       @"Senior Vice President":@237123,
                                       @"Chief Revenue Officer":@195333,
                                       @"Senior Director of Product Management":@182893,
                                       @"CEO and Managing Director":@180000,
                                       @"CEO/ Managing Director":@180000,
                                       @"Founder and Retired Managing Director":@180000,
                                       @"Managing Director":@180000,
                                       @"VP Product Management":@175823,
                                       @"Director of Program Management":@175000,
//                                       @"Random tier 1 title, var 3 [if string == "director'' or "vp", the tier 1]     172,633
                                       @"Group Program Manager":@170000,
                                       @"CMO":@160000,
                                       @"President":@160000,
//                                       @"Random tier 1 title, var 5 [if string == "director'' or "vp", the tier 1]     153,596
                                       @"Executive Director":@150000,
                                       @"VP of Marketing":@147823,
                                       @"VP, Product Marketing":@147823,
//                                       @"Random tier 1 title, var 1 [if string == "director'' or "vp", the tier 1]     146,827
                                       @"Principal Program Manager":@146754,
                                       @"Attorney":@145000,
                                       @"Contract Attorney":@145000,
                                       @"Deputy Attorney":@145000,
                                       @"Director of Engineering":@145000,
                                       @"Founder and Patent Attorney":@145000,
                                       @"Principal Product Manager, Amazon Local Restaurants":@142000,
                                       @"Group Product Manager":@141666,
                                       @"Business Development Director":@140000,
                                       @"Director of Business Development":@140000,
//                                       @"Random tier 1 title, var 2 [if string == "director'' or "vp", the tier 1]     138,844
                                       @"Chief Operating Officer":@137832,
                                       @"COO":@137832,
                                       @"Director":@135000,
                                       @"Director of Product Development, Engineering":@135000,
                                       @"Director of Product Management":@135000,
                                       @"Director Product Management":@135000,
                                       @"Director, Product Management":@135000,
                                       @"Executive Vice President":@135000,
                                       @"First Vice President":@135000,
                                       @"Principal":@135000,
                                       @"Product Management Director":@135000,
                                       @"Senior Vice President and General Manager Latin America":@135000,
                                       @"Senior Vice President- Digital Services Marketing & Infrastructure":@135000,
                                       @"Senior Vice President, Products":@135000,
                                       @"Vice President":@135000,
                                       @"Vice President - Product":@135000,
                                       @"Vice President | Product Development | Enterprise Storage | Backup | Business Continuity":@135000,
                                       @"Vice President and General Manager":@135000,
                                       @"Vice President of Corporate Services":@135000,
                                       @"Vice President of Marketing":@135000,
                                       @"Vice President of Product Management":@135000,
                                       @"Vice President Online Marketing Strategy":@135000,
                                       @"Vice President, Associate Analyst":@135000,
                                       @"Vice President, Development":@135000,
                                       @"Vice President, Director of Strategy for Chase Wealth Management":@135000,
                                       @"Vice President, Human Resources":@135000,
                                       @"Vice President, MP Operations":@135000,
                                       @"Vice President, Partner":@135000,
                                       @"Vice President, Product Growth & Engagement":@135000,
                                       @"Vice President, Product Manager":@135000,
                                       @"Vice President, Products":@135000,
                                       @"Vice President, Sales":@135000,
                                       @"Vice President, Sales Strategy and Operations":@135000,
                                       @"Chief Product Officer":@133444,
                                       @"Group Product Marketing Manager":@129355,
                                       @"Senior Product Marketing Manager / Digital Publishing":@128840,
                                       @"Senior Program Manager Lead":@128812,
                                       @"Senior Product Marketing Manager":@128000,
                                       @"Senior Product Marketing Manager (Consultant)":@128000,
                                       @"Senior Product Marketing Manager (Incubation Business), Cloud and Enterprise Division":@128000,
                                       @"Sr. Product Marketing Manager":@128000,
                                       @"CTO and Co-Founder":@127716,
                                       @"CTO":@127517,
//                                       @"Random tier 1 title, var 4 [if string == "director'' or "vp", the tier 1]     126,792
                                       @"Senior Program Manager":@125658,
                                       @"Senior Technical Program Manager":@125658,
                                       @"Management Consulting - Senior Manager":@125000,
                                       @"Senior Manager":@125000,
                                       @"Senior Manager - Kindle Ad Products":@125000,
                                       @"Senior Manager - M&A Finance":@125000,
                                       @"Senior Manager - Performance Marketing":@125000,
                                       @"Senior Manager - Strategic Business Development":@125000,
                                       @"Senior Manager, Ads-in-Apps Business Planning and Analytics, Microsoft Advertising Business Group":@125000,
                                       @"Senior Manager, Business and Marketing Analytics":@125000,
                                       @"Senior Manager, Business Development, Global Business":@125000,
                                       @"Senior Manager, Corporate Planning and Business Development":@125000,
                                       @"Senior Manager, Corporate Strategy & Analysis":@125000,
                                       @"Senior Manager, Internet Marketing":@125000,
                                       @"Senior Manager, Microsoft Office Division":@125000,
                                       @"Senior Manager, Product Marketing":@125000,
                                       @"Senior Manager, Product Quality Operations":@125000,
                                       @"Senior Manager, Site Planning (Media Solutions)":@125000,
                                       @"Senior Manager, Strategy and Marketing":@125000,
                                       @"Talent Acquisition Senior Manager supporting Gannett Digital":@125000,
                                       @"Lead Product Marketing Manager, Ad Interfaces, Feed Ads, and Delivery":@123000,
                                       @"Developer Evangelist":@121000,
                                       @"Senior Product Manager":@120000,
                                       @"Senior Product Manager - Small Cells":@120000,
                                       @"Senior Product Manager Digital Goods":@120000,
                                       @"Senior Product Manager- Xbox TV/Video Advertising":@120000,
                                       @"Senior Product Manager, Digital Strategy":@120000,
                                       @"Senior Product Manager, Kindle":@120000,
                                       @"Senior Product Manager, Norton Business Unit":@120000,
                                       @"Senior Product Manager, Shopping / Transaction Flows":@120000,
                                       @"Sr. Product Manager":@120000,
                                       @"Lead Product Manager":@119750,
                                       @"Senior Partner Marketing Manager, Office Commercial Product Management Group":@118000,
                                       @"Engineering Manager":@117248,
                                       @"Principal Strategist":@117000,
                                       @"Director of Product Marketing":@110000,
                                       @"Senior Product Manager - Leadership Rotation Program at Sprint":@110000,
                                       @"Summer Associate":@110000,
                                       @"Customer Strategy & Growth Senior Associate":@109395,
                                       @"Senior Associate":@109395,
                                       @"Principal Consultant":@108977,
                                       @"Associate Director":@108000,
                                       @"Venture Capital":@107000,
//                                       @"Random tier 2 title, var 4 [if string == 'manager', then tier 2]  106,067
                                       @"Brand Manager":@105000,
                                       @"Product Marketing Manager":@105000,
                                       @"Product Marketing Manager - Education, K-12":@105000,
                                       @"Product Marketing Manager, Google Play for Education":@105000,
                                       @"Technical Product Manager":@105000,
                                       @"Technical Product Marketing Manager - Automotive Business Unit":@105000,
                                       @"Director of Marketing":@102124,
                                       @"Marketing Director":@102124,
                                       @"Product":@100000,
                                       @"Product Management":@100000,
                                       @"Product Manager":@100000,
                                       @"Adjunct Professor":@98770,
                                       @"Senior Consultant":@95902,
//                                       @"Random tier 2 title, var 1 [if string == 'manager', then tier 2]  94,185
//                                       @"Random tier 2 title, var 5 [if string == 'manager', then tier 2]  93,979
                                       @"L&D Program Manager, Manager Development":@93129,
                                       @"Program Manager":@93129,
                                       @"Technical Program Manager":@93129,
                                       @"Customer Programs PM":@93000,
//                                       @"Random tier 2 title, var 3 [if string == 'manager', then tier 2]  92,965
                                       @"Manager":@90303,
                                       @"Senior Software Engineer":@90055,
                                       @"Sr. Software Engineer":@90055,
                                       @"Staff Software Engineer":@90055,
                                       @"Associate":@90000,
                                       @"Business Development":@90000,
                                       @"Business Development Manager":@90000,
                                       @"Senior Product Manager Intern - International Category Expansion":@90000,
                                       @"Associate Professor":@85000,
                                       @"Product Marketing":@85000,
                                       @"Project Manager":@85000,
                                       @"Senior Account Manager":@85000,
//                                       @"Random tier 2 title, var 2 [if string == 'manager', then tier 2]  82,125
                                       @"Consumer Marketing Manager":@80900,
                                       @"Global Online Marketing Manager for Bing Ads":@80900,
                                       @"Marketing Manager":@80900,
                                       @"Marketing Manager - Modern Datacenter":@80900,
                                       @"Senior Product Manager Intern":@80000,
                                       @"Summer Associate - Senior Consultant":@80000,
                                       @"Senior Sales Manager":@79000,
                                       @"HR Manager":@77814,
                                       @"Consultant":@77411,
                                       @"Software Development Engineer":@75411,
                                       @"Software Engineer":@75411,
                                       @"Program Director":@74903,
                                       @"Assistant Professor":@73101,
                                       @"Sr Sales Manager":@73000,
                                       @"Developer":@72510,
                                       @"Associate Product Manager":@72504,
                                       @"Sr. HR Manager":@72000,
                                       @"CDP Summer Associate, Advanced Analytics":@70000,
                                       @"Advertising Sales Manager - Pacific Northwest":@69000,
                                       @"Territory Sales Manager":@69000,
                                       @"Business Owner / Consultant":@67500,
                                       @"Co-Owner, Vice President":@67500,
                                       @"Founder/Owner":@67500,
                                       @"Owner":@67500,
                                       @"Web Developer, Owner":@67500,
                                       @"Database Administrator":@66410,
                                       @"Senior Business Analyst":@65841,
                                       @"Agency Lead":@65000,
                                       @"Senior Account Executive":@65000,
                                       @"Web Developer":@64494,
//                                       @"Random tier 3 title, var 5    61,758
//                                       @"Random tier 3 title, var 4    60,669
                                       @"Analyst":@60507,
                                       @"Business Analyst":@60507,
                                       @"Partner / Analyst":@60507,
                                       @"Systems Analyst":@60507,
                                       @"Account Manager":@60000,
                                       @"Business Developement Manager":@60000,
                                       @"Enterprise Account Manager":@60000,
                                       @"Senior Technical Account Manager":@60000,
                                       @"Technical Account Manager":@60000,
                                       @"Account Executive":@55000,
                                       @"General Manager":@55000,
                                       @"law clerk":@55000,
                                       @"Marketing Consultant":@55000,
                                       @"Staffing Consultant":@52500,
                                       @"Graduate Student Instructor and Researcher":@51408,
                                       @"Instructor":@51408,
                                       @"Managing Director of Instructor Development & Curriculum R&D":@51408,
                                       @"Financial Advisor":@50752,
//                                       @"Random tier 3 title, var 3    48,259
                                       @"Lecturer":@47731,
                                       @"Recruiter":@47500,
//                                       @"Random tier 3 title, var 1    47,223
                                       @"Research Associate":@45563,
                                       @"Technical Recruiter":@45000,
                                       @"Graphic Designer":@42500,
                                       @"Employment Legal Intern":@42224,
                                       @"Legal Intern":@42224,
                                       @"Coordinator":@42000,
                                       @"Mathematics Teacher / Mathematics: ICT/Learning and Teaching Technologies Co-ordinator":@42000,
                                       @"Program Coordinator, MBA Career Management Group":@42000,
                                       @"Adjunct Professor of Entrepreneurship":@36000,
//                                       @"Random tier 3 title, var 2    35,168
                                       @"Assistant":@35000,
                                       @"Graduate Student":@26000,
                                       @"Graduate Research Teaching Assistant, Distributed Systems":@19500,
                                       @"iOS Teaching Assistant":@19500,
                                       @"Product Marketing Manager Intern":@9000
                                       };
    
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
    
    NSString *finalString;
    
    if ([sender isKindOfClass:[Connection class]]) {
        Connection *connection = (Connection *)sender;
        NSArray *jobsArray = [connection.jobs array];
        
        for (Job *job in jobsArray) {
//            NSLog(@"Job Title: %@", job.title);
            NSPredicate *careerPredicate = [NSPredicate predicateWithFormat:@"%@ CONTAINS[cd] SELF", job.title];
            NSArray *filtered = [careerArray filteredArrayUsingPredicate:careerPredicate];
            
            if (filtered.count > 0) {
                NSString *string = filtered[0];
                if (finalString == nil) {
                    finalString = string;
                    
                } else if ([finalString isEqualToString:@"OTHER"]) {
                    if (![string isEqualToString:@"OTHER"]) {
                        finalString = string;
                        
                    }
                } else {
                    
                }
            } else {
                if (finalString == nil) {
                    finalString = @"OTHER";
                }
   
            }
        }
    }
    
    if ([sender isKindOfClass:[Worker class]]) {
        Worker *worker = (Worker *)sender;
        NSArray *jobsArray = [worker.jobs array];
        
        for (Job *job in jobsArray) {
            NSPredicate *careerPredicate = [NSPredicate predicateWithFormat:@"%@ CONTAINS[cd] SELF", job.title];
            NSArray *filtered = [careerArray filteredArrayUsingPredicate:careerPredicate];
            
            if (filtered.count > 0) {
                NSString *string = filtered[0];
                if (finalString == nil) {
                    finalString = string;
                    
                } else if ([finalString isEqualToString:@"OTHER"]) {
                    if (![string isEqualToString:@"OTHER"]) {
                        finalString = string;
                        
                    }
                } else {
                    
                }
            } else {
                if (finalString == nil) {
                    finalString = @"OTHER";
                }
                
            }
        }
    }
    
//    NSLog(@"Final String: %@", finalString);
    
    return [careerDictionary valueForKey:finalString];
    
//    if (filtered.count > 0) {
//        return filtered[0];
//        //            if (finalNumber == nil) {
//        //                finalNumber = [jobDictionary objectForKey:job.name];
//        //            } else if (finalNumber) {
//        //                if ([jobDictionary objectForKey:job.name] < finalNumber) {
//        //                    finalNumber = [jobDictionary objectForKey:job.name];
//        //                } else {
//        //
//        //                }
//        //            }
//    } else {
//        return @"OTHER";
//    }
    
//    for (NSString *string in careerArray) {
//        //        NSLog(@"Job: %@", job.name);
//        
//        
//    }

}

+(NSArray *)jobValue:(NSString *)title {
    NSDictionary *jobDictionary = @{@"SOFTWARE ENGINEER":@[@75411,@27877, @37.0],
                                    @"SOFTWARE DEVELOPER":@[@72510,@10980, @15.1],
                                    @"BUSINESS ANALYST":@[@65841,@5482,@8.3],
                                    @"SENIOR CONSULTANT":@[@95902,@4761,@5.0],
                                    @"CONSULTANT":@[@77411,@6713,@8.7],
                                    @"SENIOR SOFTWARE ENGINEER":@[@90055,@20534,@22.8],
                                    @"PROJECT MANAGER":@[@78305,@12875,@16.4],
                                    @"DATABASE ADMINISTRATOR":@[@66410,@4013,@6.0],
                                    @"ASSISTANT PROFESSOR":@[@98770,@-5693,@-5.8],
                                    @"WEB DEVELOPER":@[@64494,@7376,@11.4],
                                    @"MECHANICAL ENGINEER":@[@68844,@9663,@14.0],
                                    @"ACCOUNTANT":@[@50282,@3506,@7.0],
                                    @"FINANCIAL ANALYST":@[@64146,@9733,@15.2],
                                    @"POSTDOCTORAL FELLOW":@[@45806,@3505,@7.7],
                                    @"INDUSTRIAL DESIGNER":@[@54071,@19002,@35.1],
                                    @"MARKET RESEARCH ANALYST":@[@48118,@4314,@9.0],
                                    @"PHYSICIAN":@[@157355,@38693,@24.6],
                                    @"PRODUCT MANAGER":@[@95024,@17898,@18.8],
                                    @"OTHER":@[@50000,@7122,@14.2]
                                    };
    
    /*
     NSDictionary *jobDictionary = @{@"SOFTWARE ENGINEER":@[@75411,@27877, @37.0],
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
    */
    
    
    return [jobDictionary valueForKey:title];
}

+(NSArray *)generateBackValues:(NSNumber *)value {
    NSMutableArray *backValuesArray = [NSMutableArray new];
    
    //Add some random offset
    float percentage = [value floatValue] * .05;
    int random = (arc4random_uniform((int)percentage) + 1) - (int)(percentage / 2);

    float startingPoint = ([value floatValue] + (float)random);
    
    NSDictionary *change = @{@"value":[NSNumber numberWithFloat:startingPoint],
                             @"change":[NSNumber numberWithFloat:0.0]};
    
    [backValuesArray addObject:change];
    
    for (int i = 0; i < 5; i++) {
        float change = [ValueController randomFloatBetween:.25 and:1.75];
//        NSLog(@"Change: %f", change);
        startingPoint = startingPoint * (1 - (change/100));
//        NSLog(@"Floating %i: %f", i, startingPoint);
        NSDictionary *changeDictionary = @{@"value":[NSNumber numberWithFloat:startingPoint],
                                           @"change":[NSNumber numberWithFloat:change]};
        [backValuesArray addObject:changeDictionary];
    }
    
    NSArray *reversedArray = [[backValuesArray reverseObjectEnumerator] allObjects];
    
    return reversedArray;
}

+(float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

@end
