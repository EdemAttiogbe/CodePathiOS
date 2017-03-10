//
//  TipPickerViewController.swift
//  Tip Calculator Prework
//
//  Created by Edem Attiogbe Cylindrical Mac Pro on 3/6/17.
//  Copyright © 2017 EndE Group. All rights reserved.
//

import UIKit

class TipPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {

    @IBOutlet weak var tipPercentagePicker: UIPickerView!//IB Outlet
    var percentagesPicks: [String] = [String]();//Create an array that will hold all the available percentages for the picker
    var tipPercentagesDict = [String: AnyObject]();//This dictionary represents the possible Tip percentage values to choose from.  Loaded from 'TipPercentages.plist'
    var tipPlistFormat = PropertyListSerialization.PropertyListFormat.xml;//Taking note that the plist is indeed in XML format
    var newPercentageDefault: String?;//This string represents the new default tip selection by the user, returned back to the TipME Settings UiTableViewController to be displayed in the UITableViewCell
    
    //The Tip UIPickerView has indeed loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Make sure that the UIPickerViewDelegate and UIPickerViewDataSource are setup
        self.tipPercentagePicker.delegate = self;
        self.tipPercentagePicker.dataSource = self;
        
        //Make sure to set *this* UIPickerView as the app's Navigation Controller delegate.  Needed for passing data back from the UIPickerView to the previous ViewController (the UITableViewController)
        self.navigationController?.delegate = self;
        
        let tipfilePath: String? = Bundle.main.path(forResource: "TipPercentages", ofType: "plist");//path to 'TipPercentages.plist'
        
        if let path = tipfilePath {
            print("Obtained path to TipPercentages plist file: \(tipfilePath ?? "No Plist Found")");
            let tipPercentageXMLData = FileManager.default.contents(atPath: path)!//Obtain the XML data representation of the Tip Percentagages plist file
            
            do{//Convert the Tip Percentages plist into a Dictionary
                tipPercentagesDict = try PropertyListSerialization.propertyList(from: tipPercentageXMLData, options: .mutableContainersAndLeaves, format: &tipPlistFormat) as! [String: AnyObject];
                print("Added all the available tip percentages into a Dictionary");
            }
            catch{
                print("Error converting TipPercentages plist into a Dictionary: \(error), format: \(tipPercentageXMLData)");
                
            }
            
            //Load the tip Amounts into an array
            let anyTipAmounts = noTipsAmounts();
            if !anyTipAmounts{
                for tipAmounts in tipPercentagesDict.keys{
                    percentagesPicks.append(tipAmounts);
                }
                print("Added tip amounts to tip picker");
                print(percentagesPicks);
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
        return( percentagesPicks[row]);
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        newPercentageDefault = percentagesPicks[row];
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        <#code#>
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
