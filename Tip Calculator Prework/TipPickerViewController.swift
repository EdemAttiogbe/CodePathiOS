//
//  TipPickerViewController.swift
//  Tip Calculator Prework
//
//  Created by Edem Attiogbe Cylindrical Mac Pro on 3/6/17.
//  Copyright © 2017 EndE Group. All rights reserved.
//

import UIKit

class TipPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var tipPercentagePicker: UIPickerView!//IB Outlet
    var percentagesPicks: [Int] = [Int]();//Create an array that will hold all the available percentages for the picker
    
    var tipPercentagesDict = [String: AnyObject]();//This dictionary represents the possible Tip percentage values to choose from.  Loaded from 'TipPercentages.plist'
    
    var tipPlistFormat = PropertyListSerialization.PropertyListFormat.xml;//Taking note that the plist is indeed in XML format
    
    //The Tip UIPickerView has indeed loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Make sure that the UIPickerViewDelegate and UIPickerViewDataSource are setup
        self.tipPercentagePicker.delegate = self;
        self.tipPercentagePicker.dataSource = self;
        
        let tipfilePath: String? = Bundle.main.path(forResource: "TipPercentages", ofType: "plist");//path to 'TipPercentages.plist'
        
        if let path = tipfilePath {
            let tipPercentageXMLData = FileManager.default.contents(atPath: path)!//Obtain the XML data representation of the Tip Percentagages plist file
            
            do{//Convert the Tip Percentages plist into a Dictionary
                tipPercentagesDict = try PropertyListSerialization.propertyList(from: tipPercentageXMLData, options: .mutableContainersAndLeaves, format: &tipPlistFormat) as! [String: AnyObject];
            }
            catch{
                print("Error converting TipPercentages plist into a Dictionary: \(error), format: \(tipPercentageXMLData)");
                
            }
            
            //Load the tip Amounts into an array
            let anyTipAmounts = noTipsAmounts();
            if anyTipAmounts{
                for tipAmounts in tipPercentagesDict.values{
                    percentagesPicks.append(tipAmounts as! Int);
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return (1);
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (percentagesPicks.count);
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return( percentagesPicks[row] as! String);
    }
    
    func noTipsAmounts() -> Bool {
        if tipPercentagesDict.isEmpty{ return true; }
        else{ return false; }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
