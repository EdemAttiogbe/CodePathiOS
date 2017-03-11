//
//  TipPickerViewController.swift
//  Tip Calculator Prework
//
//  Created by Edem Attiogbe Cylindrical Mac Pro on 3/6/17.
//  Copyright © 2017 EndE Group. All rights reserved.
//

import UIKit

//This protocol will be used to pass the picked default percentage back to the TipMETableViewController for saving to the NSUserDefaults keystore
//protocol TipPickerDelegate{
   
//    func didChooseNewDefaultTipPercent(picker: TipPickerViewController, pickedKeyValue: String);//Used to transfer both the
//}

class TipPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {

    @IBOutlet weak var tipPercentagePicker: UIPickerView!//IB Outlet
    
    let dataLayer: TipPercentageDataModelSingleton = TipPercentageDataModelSingleton.tipPercentageSharedDataModel;//The data layer
    
    var percentagesPicks: [String] = [String]();//Create an array that will hold all the available percentages for the picker
    var newPercentageDefault: String?;//This string represents the new default tip selection by the user, returned back to the TipME Settings UiTableViewController to be displayed in the UITableViewCell
    
    //The Tip UIPickerView has indeed loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Make sure that the UIPickerViewDelegate and UIPickerViewDataSource are setup
        self.tipPercentagePicker.delegate = self;
        self.tipPercentagePicker.dataSource = self;
        
        self.tipPercentagePicker.showsSelectionIndicator = true;//Show the selection indicator
        
        //Make sure to set *this* UIPickerView as the app's Navigation Controller delegate.  Needed for passing data back from the UIPickerView to the previous ViewController (the UITableViewController)
        self.navigationController?.delegate = self;
        
        let tipPercentageKeys: [String] = Array(dataLayer.tipPercentData.tipDict.keys);
        for tipAmounts in tipPercentageKeys{
            percentagesPicks.append(tipAmounts);
        }
        print("TipMe Picker: Added tip amounts to tip picker: \(percentagesPicks)");
        print(percentagesPicks);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //Set Picker selection to default tip percentage
        for pickerItem in 0 ..< self.percentagesPicks.count{//Select the default tip percentage automatically
            let pickTitle: String = self.percentagesPicks[pickerItem];
            if (dataLayer.tipPercentData.defaultTipPercentage == pickTitle){ self.tipPercentagePicker.selectRow(pickerItem, inComponent: 0, animated: true); newPercentageDefault = self.percentagesPicks[pickerItem];}
            print("TipMe Picker: Setting selected picker item according to default tip percentage: \(self.percentagesPicks[pickerItem])");
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
        print ("TipMe Picker: About to show the previous ViewController: TipME Settings");
        if let tipMETableViewController = viewController as? TipMETableViewController {
            tipMETableViewController.tipAmountDisplay.text = newPercentageDefault;// using delegation to pass the newly selected default tip value back to the TableViewControler
            //Update the Data Model
            dataLayer.updateDefaultTipPercentage(defaultTipVal: newPercentageDefault!);
            dataLayer.updateObserver();
        }
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
