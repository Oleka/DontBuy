//
//  ScanViewController.swift
//  DontBuyForYourself
//
//  Created by Oleka on 14/12/16.
//  Copyright © 2016 Olga Blinova. All rights reserved.
//

import UIKit
import RSBarcodes_Swift

protocol selectBarcodeDelegate: class { //Setting up a Custom delegate for this class. I am using `class` here to make it weak.
    func sendDataBackToHomePageViewController(barcodeToRefresh: String?) //This function will send the data back to origin viewcontroller.
}

class ScanViewController: RSCodeReaderViewController {
    
    
    var barcodeString: String = ""
    weak var barcodeDelegateForDataReturn: selectBarcodeDelegate?
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Scan barcode
        self.focusMarkLayer.strokeColor = UIColor.red.cgColor
        self.cornersLayer.strokeColor   = UIColor.yellow.cgColor
        
        self.tapHandler = { point in
            print(point)
        }
        
        self.barcodesHandler = { barcodes in
            for barcode in barcodes {
                print("Barcode found: type=" + barcode.type + " value=" + barcode.stringValue)
                self.barcodeString = barcode.stringValue
                self.barcodeDelegateForDataReturn?.sendDataBackToHomePageViewController(barcodeToRefresh: self.barcodeString)
    
                //Close
                self.dismiss(animated: false, completion: nil)
                
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
