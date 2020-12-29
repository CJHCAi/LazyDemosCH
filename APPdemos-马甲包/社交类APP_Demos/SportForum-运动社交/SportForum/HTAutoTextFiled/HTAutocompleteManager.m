//
//  HTAutocompleteManager.m
//  HotelTonight
//
//  Created by Jonathan Sibley on 12/6/12.
//  Copyright (c) 2012 Hotel Tonight. All rights reserved.
//

#import "HTAutocompleteManager.h"

static HTAutocompleteManager *sharedManager;

@implementation HTAutocompleteManager

+ (HTAutocompleteManager *)sharedManager
{
	static dispatch_once_t done;
	dispatch_once(&done, ^{ sharedManager = [[HTAutocompleteManager alloc] init]; });
	return sharedManager;
}

#pragma mark - HTAutocompleteTextFieldDelegate

- (NSString *)textField:(HTAutocompleteTextField *)textField
    completionForPrefix:(NSString *)prefix
             ignoreCase:(BOOL)ignoreCase
{
    if (textField.autocompleteType == HTAutocompleteTypeEmail)
    {
        static dispatch_once_t onceToken;
        static NSArray *autocompleteArray;
        dispatch_once(&onceToken, ^
        {
            autocompleteArray = @[  @"gmail.com",
                                    @"sina.com",
                                    @"sohu.com",
                                    @"google.com",
                                    @"inbox.com",
                                    @"yahoo.com",
                                    @"hotmail.com",
                                    @"msn.com",
                                    @"googlemail.com",
                                    @"mail.com",
                                    @"qq.com",
                                    @"163.com",
                                    @"sky.com",
                                    @"icloud.com",
                                    @"126.com",
                                    @"yahoo.com.hk",
                                    @"yahoo.com.cn"];
        });

        // Check that text field contains an @
        NSRange atSignRange = [prefix rangeOfString:@"@"];
        if (atSignRange.location == NSNotFound)
        {
            return @"";
        }

        // Stop autocomplete if user types dot after domain
        NSString *domainAndTLD = [prefix substringFromIndex:atSignRange.location];
        NSRange rangeOfDot = [domainAndTLD rangeOfString:@"."];
        if (rangeOfDot.location != NSNotFound)
        {
            return @"";
        }

        // Check that there aren't two @-signs
        NSArray *textComponents = [prefix componentsSeparatedByString:@"@"];
        if ([textComponents count] > 2)
        {
            return @"";
        }

        if ([textComponents count] > 1)
        {
            // If no domain is entered, use the first domain in the list
            if ([(NSString *)textComponents[1] length] == 0)
            {
                return [autocompleteArray objectAtIndex:0];
            }

            NSString *textAfterAtSign = textComponents[1];

            NSString *stringToLookFor;
            if (ignoreCase)
            {
                stringToLookFor = [textAfterAtSign lowercaseString];
            }
            else
            {
                stringToLookFor = textAfterAtSign;
            }

            for (NSString *stringFromReference in autocompleteArray)
            {
                NSString *stringToCompare;
                if (ignoreCase)
                {
                    stringToCompare = [stringFromReference lowercaseString];
                }
                else
                {
                    stringToCompare = stringFromReference;
                }

                if ([stringToCompare hasPrefix:stringToLookFor])
                {
                    return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
                }

            }
        }
    }
    else if (textField.autocompleteType == HTAutocompleteTypeEquip)
    {
        static dispatch_once_t colorOnceToken;
        static NSArray *colorAutocompleteArray;
        dispatch_once(&colorOnceToken, ^
        {
            colorAutocompleteArray = @[ @"小米手环",
                                        @"荣耀手环",
                                        @"ibody 追客手环",
                                        @"ibody Rainbow 蓝牙健康追踪器",
                                        @"埃微(iwown) I5手环",
                                        @"Nike+ Running sportwatch",
                                        @"Nike Fuelband",
                                        @"埃微（iwown）派系列手环",
                                        @"玩咖（wan-ka）手环",
                                        @"卓棒（Jawbone）手环",
                                        @"Misfit Shine 运动追踪器",
                                        @"山水（SANSUI） H1手环",
                                        @"Fitbit Flex手环",
                                        @"Fitbit Charge手环",
                                        @"bong2手环",
                                        @"三星（SAMSUNG）Gear Fit",
                                        @"咕咚（Codoon）HB-B021",
                                        @"乐心（LIFESENSE）BonBon手环",
                                        @"乐心（LIFESENSE） Mambo手环",
                                        @"USAMS手环",
                                        @"TCL手环",
                                        @"美创手环",
                                        @"Weloop Now Classic手环",
                                        @"唯动（vidonn）手环",
                                        @"SENBOWE 智能蓝牙手表",
                                        @"智蝶科技（SMARTFLY）手环",
                                        @"Hi Cling手环",
                                        @"佳明（GARMIN）vivofit手环",
                                        @"品佳手环",
                                        @"联想（Lenovo）手环",
                                        @"索尼（SONY）SWR10手环",
                                        @"XIMU手环",
                                        @"幻响（i-mu）手环",
                                        @"风彩手环",
                                        @"我动 Star手环",
                                        @"奥思Star.21手环",
                                        @"OPPO I901 O-Band手环",
                                        @"酷道 F1手环",
                                        @"运动令（yundongling）手环",
                                        @"爱迪思（Aidis）蓝牙手表",
                                        @"威马仕（WELMAX）智能蓝牙手表",
                                        @"菲尔德（Phyode）W/Me手环",
                                        @"爱国者（aigo）纽扣HB01手环",
                                        @"一丁手环",
                                        @"喜越（CIYOYO）CY360手环",
                                        @"lovefit手环",
                                        @"中兴（ZTE）Grand Band I 手环",
                                        @"GYENNO One手环",
                                        @"",
                                        @"MATE手环"];
        });

        NSString *stringToLookFor;
        if (ignoreCase)
        {
            stringToLookFor = [prefix lowercaseString];
        }
        else
        {
            stringToLookFor = prefix;
        }

        for (NSString *stringFromReference in colorAutocompleteArray)
        {
            NSString *stringToCompare;
            if (ignoreCase)
            {
                stringToCompare = [stringFromReference lowercaseString];
            }
            else
            {
                stringToCompare = stringFromReference;
            }

            if ([stringToCompare hasPrefix:stringToLookFor])
            {
                return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
            }

        }
    }
    else if (textField.autocompleteType == HTAutocompleteTypeSoftware)
    {
        static dispatch_once_t softwareOnceToken;
        static NSArray *softwareAutocompleteArray;
        dispatch_once(&softwareOnceToken, ^
                      {
                          softwareAutocompleteArray = @[ @"咕咚",
                                                      @"乐动力",
                                                      @"NikeRunning",
                                                      @"Runtastic",
                                                      @"Cyberace 赛跑乐",
                                                      @"Runkeeper",
                                                      @"益动GPS",
                                                      @"悦跑圈",
                                                      @"endomondo",
                                                      @"Strava"];
                      });
        
        NSString *stringToLookFor;
        if (ignoreCase)
        {
            stringToLookFor = [prefix lowercaseString];
        }
        else
        {
            stringToLookFor = prefix;
        }
        
        for (NSString *stringFromReference in softwareAutocompleteArray)
        {
            NSString *stringToCompare;
            if (ignoreCase)
            {
                stringToCompare = [stringFromReference lowercaseString];
            }
            else
            {
                stringToCompare = stringFromReference;
            }
            
            if ([stringToCompare hasPrefix:stringToLookFor])
            {
                return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
            }
            
        }
    }
    else if (textField.autocompleteType == HTAutocompleteTypeShoes)
    {
        static dispatch_once_t shoesOnceToken;
        static NSArray *shoesAutocompleteArray;
        dispatch_once(&shoesOnceToken, ^
                      {
                          shoesAutocompleteArray = @[ @"Adidas",
                                                      @"Aetrex",
                                                      @"Altra",
                                                      @"Anatom",
                                                      @"Asics",
                                                      @"Brooks",
                                                      @"Columbia",
                                                      @"Ecco",
                                                      @"Etonic",
                                                      @"Hoka One One",
                                                      @"Icebug",
                                                      @"Inov-8",
                                                      @"Kalenji",
                                                      @"Karhu",
                                                      @"K-Swiss",
                                                      @"La Sportiva",
                                                      @"Merrell",
                                                      @"Mizuno",
                                                      @"Montrail",
                                                      @"New Balance",
                                                      @"Newton",
                                                      @"Nike",
                                                      @"On",
                                                      @"Patagonia",
                                                      @"Pearl Izumi",
                                                      @"Puma",
                                                      @"Reebok",
                                                      @"Salomon",
                                                      @"Saucony",
                                                      @"Scarpa",
                                                      @"Scott",
                                                      @"Skechers",
                                                      @"Skora",
                                                      @"Speedo",
                                                      @"Spira",
                                                      @"Tecnica",
                                                      @"Terra Plana",
                                                      @"Teva",
                                                      @"The North Face",
                                                      @"Topo Athletic",
                                                      @"Treksta",
                                                      @"Under Armour",
                                                      @"Vibram",
                                                      @"Vivobarefoot",
                                                      @"Zoot",
                                                      @"阿迪达斯（Adidas）",
                                                      @"特步（XTEP）",
                                                      @"安踏（ANTA）",
                                                      @"李宁（LI-NING）",
                                                      @"鸿星尔克（ERKE）",
                                                      @"乔丹",
                                                      @"新百伦（newbalance）",
                                                      @"亚瑟士（ASICS）",
                                                      @"新百伦纽巴伦（NEW BARLUN）",
                                                      @"彪马（Puma）",
                                                      @"三叶草（Adidas）",
                                                      @"美津浓（MIZUNO）",
                                                      @"花花公子（PLAYBOY）",
                                                      @"双星（Double Star）",
                                                      @"匹克（PEAK）",
                                                      @"卡帕（Kappa）",
                                                      @"斯凯奇（Skechers）",
                                                      @"斐乐（FILA）",
                                                      @"贵人鸟",
                                                      @"迪亚多纳（Diadora）",
                                                      @"乐途（LOTTO）",
                                                      @"波尼（PONY）",
                                                      @"八哥（Bage）",
                                                      @"回力（Warrior）",
                                                      @"中大鳄鱼（ZJIEYU）",
                                                      @"苹果（Apple）",
                                                      @"德尔惠（Deerway）",
                                                      @"领舞者（LINGWUZHE）",
                                                      @"茵宝（Umbro）",
                                                      @"索康尼（SAUCONY）",
                                                      @"耐克（NIKE）",
                                                      @"德尔加多（Delocrd）",
                                                      @"多威（DO-WIN）",
                                                      @"公牛世家",
                                                      @"JAZOVO",
                                                      @"乔丹格兰（Joedon Golan）",
                                                      @"沃特（VOIT）",
                                                      @"艾弗森",
                                                      @"onemix",
                                                      @"意尔康",
                                                      @"NBH",
                                                      @"执行官（Excetive Officer）",
                                                      @"METRIX",
                                                      @"左丹狼",
                                                      @"海尔斯（health）",
                                                      @"361"];
                      });
        
        NSString *stringToLookFor;
        if (ignoreCase)
        {
            stringToLookFor = [prefix lowercaseString];
        }
        else
        {
            stringToLookFor = prefix;
        }
        
        for (NSString *stringFromReference in shoesAutocompleteArray)
        {
            NSString *stringToCompare;
            if (ignoreCase)
            {
                stringToCompare = [stringFromReference lowercaseString];
            }
            else
            {
                stringToCompare = stringFromReference;
            }
            
            if ([stringToCompare hasPrefix:stringToLookFor])
            {
                return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
            }
            
        }
    }

    return @"";
}

@end
