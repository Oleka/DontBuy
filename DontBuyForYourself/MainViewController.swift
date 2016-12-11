//
//  ViewController.swift
//  DontBuyForYourself
//
//  Created by Oleka on 09/12/16.
//  Copyright © 2016 Olga Blinova. All rights reserved.
//

import UIKit
import CoreData

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}


class MainViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hiImage: UIImageView!
    
    var prd : [Products] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate   = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
        
        if prd.count>0 {
            hiImage.isHidden=true
        }
        else{
            hiImage.isHidden=false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ProductsRow")
        {
            
            let viewController : DetailViewController = segue.destination as! DetailViewController
            let indexPath = tableView.indexPathForSelectedRow
            let pr = prd[(indexPath?.row)!]
            viewController.product = [pr]
            //NSString *newID = [[NSUUID UUID] UUIDString];
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "ProductsRow", sender:self )
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prd.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell()
        
        let cellId: String = "MyCell"
        let cell: CellController = tableView.dequeueReusableCell(withIdentifier: cellId)! as! CellController
        
        let pr = prd[indexPath.row]
        let table_label = "\(pr.name!)"
        cell.nameField?.text = table_label
        cell.reasonField?.text = "\(pr.reason!)"
        
        let productImage:UIImage = UIImage(data: pr.image as! Data)!
        cell.productImage?.image = productImage
        cell.productImage?.layer.masksToBounds = false
        cell.productImage?.layer.cornerRadius = (cell.productImage?.frame.height)!/2
        cell.productImage?.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //Delete stat row
        let _context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {
            let pr = prd[indexPath.row]
            _context.delete(pr)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            //update data after deleting
            do{
                prd = try _context.fetch(Products.fetchRequest())
            }
            catch{
                print("Fetching Error after deleting!")
            }
            tableView.reloadData()
        }
    }
    
    func getData(){
        let _context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            prd = try _context.fetch(Products.fetchRequest())
        }
        catch{
            print("Fetching Error!")
        }
        
    }
    
    @IBAction func clearTableView(_ sender: Any) {
        //Delete stat row
        let _context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Remove all charging data from persistent storage
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try _context.execute(deleteRequest)
        } catch {
            let deleteError = error as NSError
            NSLog("\(deleteError), \(deleteError.localizedDescription)")
        }
        
        //Save
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        //update data after deleting
        do{
            prd = try _context.fetch(Products.fetchRequest())
        }
        catch{
            print("Fetching Error after deleting!")
        }
        tableView.reloadData()
        
    }


}

