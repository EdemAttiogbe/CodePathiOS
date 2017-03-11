//
//  TipPercentageDataModelSingleton.swift
//  Tip Calculator Prework
//
//  Created by Edem Attiogbe Cylindrical Mac Pro on 3/10/17.
//  Copyright © 2017 EndE Group. All rights reserved.
//

import UIKit

/* This class represents the data model object used for accessing desired Tip amounts from the TipPercentages plist */
class TipPercentageDataModelSingleton: NSObject {
    
    static let tipPercentageSharedDataModel = TipPercentageDataModelSingleton();//Singleton object that represents access to the share data model
    
    /**
     This struct defines the key used to save the default selected Tip percentage from the Tip Percentage Data Model singleton's properties to NSUserDefaults.
     */
    struct TipPercentageData{
        
        var defaultTipPercentage: String;//Used to set the default tip percentage key in the NSUserDefaults Defaults dictionary
        let defaultTipPercentageKey: String = "DefaultTipKey";//Used to define and look up a key in NSUserDefaults dictionary for default tip percentage
        var tipDict = [String: Double]();//This dictionary represents the Tip Percentages that can be loaded from TipPercentages Plist.
    }
    var tipPercentData = TipPercentageData(defaultTipPercentage: "Nothing", tipDict: [:]);//Initialized Tip Percentage Data Model

    //When the app goes to the background, this background observer object will save the currently selected tip percentage as the default.
    var goToBackgroundObserver: AnyObject?
    
    override init()//default initializer
    {
        super.init();
    }
    
    deinit {//deinitializer
        
        NotificationCenter.default.removeObserver(self);//Remove any observers in the data model
    }
    
    func setup(tipDefault: String, tipDictionary: [String: AnyObject]){//This initializer needs both the current 'default' Tip percentage, as well as the dictionary of available tip percentage amounts from the AppDelegate
        
        var tipKeys: [String]? = Array(tipDictionary.keys);//Maps a 'LazyMapCollection object', of all keys (unknown at this point) in the dictionary of tips received from the AppDelegete, to an array
        
        //The '3' tip percentage keys. Note, only '3' tips are supported right now, as defined in the UI
        let firstPercentageKey: String? = tipKeys?[0] ?? "Nothing";
        let secondPercentageKey: String? = tipKeys?[1] ?? "Nothing";
        let thirdPercentageKey: String? = tipKeys?[2] ?? "Nothing";
        
        //The '3' tip percentage values. Note, only '3' tips are supported right now, as defined in the UI
        var firstPercentageValue: Double?;
        var secondPercentageValue: Double?;
        var thirdPercentageValue: Double?;
        
        //-----------------------------------------------------------------------------
        //Load the Tip Dictionary with tip default, keys, and values from AppDelegate
        firstPercentageValue = tipDictionary[firstPercentageKey!] as? Double ?? 0.0;
        secondPercentageValue = tipDictionary[secondPercentageKey!] as? Double ?? 0.0;
        thirdPercentageValue = tipDictionary[thirdPercentageKey!] as? Double ?? 0.0;
        
        //Stores the default tip percentage 'key' in the data model, given by the AppDelegate.  Will be used to perform tip percentage look ups anywhere using the tip dictionary
        self.tipPercentData.defaultTipPercentage = tipDefault;
        print("DataModel: Setting initial default tip setting.....\(self.tipPercentData.defaultTipPercentage)");
        //Stores all the Tip Percentages in the data model, given by the AppDelegate.  Will be used when look ups are performed for tip percentage calculations
        self.tipPercentData.tipDict = [firstPercentageKey!:firstPercentageValue!, secondPercentageKey!:secondPercentageValue!, thirdPercentageKey!:thirdPercentageValue!];
        print("DataModel: Setting initial default tip dictionary.....\(tipPercentData.tipDict)");
        //-----------------------------------------------------------------------------
        
        //Add an obsever for the UIApplicationDidEnterBackgroundNotification. When the app goes to the background, the code block saves our properties to NSUserDefaults
        goToBackgroundObserver = NotificationCenter.default.addObserver(
            forName: NSNotification.Name.UIApplicationDidEnterBackground,
            object: nil,
            queue: nil)
        {
            (note: Notification!) -> Void in
            let defaults = UserDefaults.standard
            //-----------------------------------------------------------------------------
            //This code saves the singleton's properties to NSUserDefaults.
            //edit this code to save your custom properties
            defaults.set(self.tipPercentData.defaultTipPercentage, forKey: self.tipPercentData.defaultTipPercentageKey);
            //-----------------------------------------------------------------------------
            
            //Tell NSUserDefaults to save to disk now.
            defaults.synchronize();
            print("DataModel: Setup of observer for application entering background complete");
        }

    }
    
    func updateDefaultTipPercentage(defaultTipVal: String){
        
        self.tipPercentData.defaultTipPercentage = defaultTipVal;
        let tipDefaults = UserDefaults.standard;
        tipDefaults.set(self.tipPercentData.defaultTipPercentage, forKey: self.tipPercentData.defaultTipPercentageKey);
        tipDefaults.synchronize();
        print("DataModel: Updated UserDefault dictionary with new default tip value......\(String(describing: tipDefaults.string(forKey: self.tipPercentData.defaultTipPercentageKey)))");
    }

    func updateObserver(){
        
        //Remove any observers in the data model
        NotificationCenter.default.removeObserver(self);
        //Add an obsever for the UIApplicationDidEnterBackgroundNotification. When the app goes to the background, the code block saves our properties to NSUserDefaults
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidEnterBackground, object: nil, queue: nil, using: self.processNotification(notify:));
        print("DataModel: Update of observer for application entering background complete");
    }
    
    func processNotification(notify: Notification!){
        
        let tipDefaults = UserDefaults.standard;
        //-----------------------------------------------------------------------------
        //This code saves the singleton's properties to NSUserDefaults.
        //edit this code to save your custom properties
        tipDefaults.set(self.tipPercentData.defaultTipPercentage, forKey: self.tipPercentData.defaultTipPercentageKey);
        //-----------------------------------------------------------------------------
        //Tell NSUserDefaults to save to disk now.
        tipDefaults.synchronize();
    }
}
