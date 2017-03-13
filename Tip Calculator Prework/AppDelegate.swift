//
//  AppDelegate.swift
//  Tip Calculator Prework
//
//  Created by Edem Attiogbe Cylindrical Mac Pro on 3/4/17.
//  Copyright © 2017 EndE Group. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var tipPercentagesDict: [String: AnyObject]? = [String: AnyObject]();//This dictionary represents the possible Tip percentage values to choose from.  Loaded from 'TipPercentages.plist'
    var tipPlistFormat = PropertyListSerialization.PropertyListFormat.xml;//Taking note that the plist is indeed in XML format
    let dataLayer: TipPercentageDataModelSingleton = TipPercentageDataModelSingleton.tipPercentageSharedDataModel;//The data layer
    let tipDefaults = UserDefaults.standard;//The NSUserDefault dictionary
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        //This code loads all tips percentages from a plist file
        let tipfilePath: String? = Bundle.main.path(forResource: "TipPercentages", ofType: "plist");//path to 'TipPercentages.plist'
        
        if let path = tipfilePath {
            
            print("AppDeletage: Obtained path to TipPercentages plist file: \(tipfilePath ?? "No Plist Found")");
            let tipPercentageXMLData = FileManager.default.contents(atPath: path)!//Obtain the XML data representation of the Tip Percentagages plist file
            
            do{//Convert the Tip Percentages plist into a Dictionary
                tipPercentagesDict = try PropertyListSerialization.propertyList(from: tipPercentageXMLData, options: .mutableContainersAndLeaves, format: &tipPlistFormat) as? [String: AnyObject];
                print("AppDeletage: Added all the available tip percentages into a Dictionary from the plist");
            }
            catch{
                print("AppDeletage: Error converting TipPercentages plist into a Dictionary: \(error), format: \(tipPercentageXMLData)");
            }
            
            self.loadTipAndBillAmounts();
        }
        else{
            
        }
        
        return true
    }
    
    func loadTipAndBillAmounts(){
        
        //Load the tip Amounts into an array
        let anyTipAmounts = noTipsAmounts();
        let tipKeys: [String]? = Array(tipPercentagesDict!.keys);
        var defaultTip: String = tipKeys![0];//Iniitially, set the default selected tip to the first one found from the tip dictionary
        var defaultTipFound: Bool = false;//No default tip initially found (have't tried a look up in NSUserDefaults at this point yet)
        if !anyTipAmounts{
            
            if tipDefaults.bool(forKey: dataLayer.tipPercentData.defaultTipPercentageKey){ defaultTip = tipDefaults.string(forKey: dataLayer.tipPercentData.defaultTipPercentageKey)!; defaultTipFound = true; print("AppDeletage: Found default tip value from UserDefaults.....setting to data model...default tip percent: \(defaultTip)");}
            if(!defaultTipFound ){ tipDefaults.set(defaultTip, forKey: dataLayer.tipPercentData.defaultTipPercentageKey); tipDefaults.synchronize(); print("AppDeletage: Didn't find default tip value from UserDefaults...will choose default value from TipPercentages dictionary...new default tip percent: \(defaultTip)"); }//If no default tip exists in NSUserDefaults, set one
            dataLayer.setup(tipDefault: defaultTip, tipDictionary: tipPercentagesDict!);//Send the default selected tip, as well as all avaible tips, to the data model
        }
        
        //Load the persisted bill Amount
        var persistedBill: Double = 0.00;
        var persistedBillFound: Bool = false;//No persited bill initially found (haven't tried a look up in NSUserDefault at this point yet)
        if tipDefaults.bool(forKey: dataLayer.tipPercentData.persistedBillAmountKey){ persistedBill = tipDefaults.double(forKey: dataLayer.tipPercentData.persistedBillAmountKey); persistedBillFound = true; print("AppDeletage: Found persisted bill value from UserDefaults.....setting to data model...persisted bill value: \(persistedBill)");}
        if(!persistedBillFound){ tipDefaults.set(persistedBill, forKey: dataLayer.tipPercentData.persistedBillAmountKey); tipDefaults.synchronize(); print("AppDeletage: Didn't find persisted bill value from UserDefaults...will choose bill value...new default tip percent: \(persistedBill)"); }
        dataLayer.tipPercentData.billAmount = persistedBill;
    }
    
    func noTipsAmounts() -> Bool {//Check if the Tip Percentages Dictionary is empty
        if tipPercentagesDict!.isEmpty{ print("AppDeletage: No Tip values found from attempted load from plist!!"); return true; }
        else{ print("AppDeletage: Tip values found and successfully loaded into dictionary from plist"); return false; }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        dataLayer.updateObserver();
        dataLayer.updateBillAmount();
        dataLayer.updateDefaultTipPercentage();
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        dataLayer.updateObserver();//Update the Notification to make sure the default tip percentage selected is saved
        dataLayer.updateBillAmount();
        dataLayer.updateDefaultTipPercentage();
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground
        
        dataLayer.updateObserver();//Update the Notification to make sure the default tip percentage selected is saved
        dataLayer.updateBillAmount();
        dataLayer.updateDefaultTipPercentage();
    }
}

