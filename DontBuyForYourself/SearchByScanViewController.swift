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

    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var rate1: UIButton!
    @IBOutlet weak var rate2: UIButton!
    @IBOutlet weak var rate3: UIButton!
    @IBOutlet weak var rate4: UIButton!
    @IBOutlet weak var rate5: UIButton!
    @IBOutlet weak var bg:  UIImageView!
    @IBOutlet weak var imageForAdd:  UIImageView!
    @IBOutlet weak var reasonField:  UILabel!
    @IBOutlet weak var nameField:    UILabel!
    @IBOutlet weak var barcodeNotFound: UILabel!
    
    var barcodeString: String = ""
    var searched_product : [Products] = []
    var rating : Int16 = 0
    var rateArray:[Bool] = [Bool](repeating: false, count:5)
    
    func setRateButtons(){
        //Implement rating into rateArray
        
        var ind: Int = 0
        while rating>0 {
            rateArray[ind]=true
            rating -= 1
            ind += 1
        }
        
        //Set rate button state from rateArray state
        var i: Int = 1
        for r in rateArray {
            let iButton = self.view.viewWithTag(i) as? UIButton
            if r==true{
                iButton?.isSelected=true
            }
            else{
                iButton?.isSelected=false
            }
            i+=1
        }
    }

    
    
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
        
        searchProductInDB()
        
        DispatchQueue.main.async(execute: { () -> Void in
            if self.searched_product.count==0 {
                self.detailView.isHidden=false
                self.bg.isHidden=false
                self.barcodeNotFound.isHidden = false
                self.barcodeNotFound.text = "Barcode Not found!"
                self.reasonField.isHidden = true
                self.nameField.isHidden   = true
                self.imageForAdd.isHidden = true
                self.rate1.isHidden = true
                self.rate2.isHidden = true
                self.rate3.isHidden = true
                self.rate4.isHidden = true
                self.rate5.isHidden = true
            }
            else{
                self.barcodeNotFound.isHidden = true
                self.rating=self.searched_product[0].rating
                self.detailView.isHidden=false
                self.nameField.isHidden=false
                self.reasonField.isHidden=false
                self.bg.isHidden=false
                self.imageForAdd.isHidden=false
                self.nameField.text = self.searched_product[0].name
                self.reasonField.text = self.searched_product[0].reason
                self.imageForAdd.image = UIImage(data: self.searched_product[0].image as! Data)!
                self.rate1.isHidden=false
                self.rate2.isHidden=false
                self.rate3.isHidden=false
                self.rate4.isHidden=false
                self.rate5.isHidden=false
                self.setRateButtons()
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.detailView.isHidden=true
        self.bg.isHidden=true
        self.imageForAdd.isHidden=true
        self.nameField.isHidden=true
        self.reasonField.isHidden=true
        self.rate1.isHidden=true
        self.rate2.isHidden=true
        self.rate3.isHidden=true
        self.rate4.isHidden=true
        self.rate5.isHidden=true
        
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
    
    @IBAction func goToList(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
}
