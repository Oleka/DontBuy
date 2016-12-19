//
//  SearchByScanViewController.swift
//  DontBuyForYourself
//
//  Created by Oleka on 16/12/16.
//  Copyright © 2016 Olga Blinova. All rights reserved.
//

import UIKit
import RSBarcodes_Swift
import CoreData

class SearchByScanViewController: RSCodeReaderViewController {

    var barcodeString: String = ""
    var searched_product : [Products] = []
    
    
    func searchProductInDB(){
        let _context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            
            let request = NSFetchRequest<Products>(entityName: "Products")
            request.predicate = NSPredicate(format: "barcode == \(barcodeString)")
            searched_product = try _context.fetch(request)
            
        } catch {
            print("There was an error fetching Plus Operations.")
        }

    }
    
    func openSearchDetail(){
        DispatchQueue.main.async(execute: { () -> Void in
            self.performSegue(withIdentifier: "toSearchDetail", sender: self)
        })
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
                
                self.openSearchDetail()
                
                //Stop scan
                self.session.stopRunning()
                
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toSearchDetail")
        {
            searchProductInDB()
            let viewController : DetailViewController = segue.destination as! DetailViewController
            viewController.product = searched_product
            
        }
    }

}
