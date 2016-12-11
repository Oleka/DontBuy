//
//  DetailViewController.swift
//  DontBuyForYourself
//
//  Created by Oleka on 10/12/16.
//  Copyright © 2016 Olga Blinova. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    @IBOutlet weak var rate1: UIButton!
    @IBOutlet weak var rate2: UIButton!
    @IBOutlet weak var rate3: UIButton!
    @IBOutlet weak var rate4: UIButton!
    @IBOutlet weak var rate5: UIButton!
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var imageForAdd:  UIImageView!
    @IBOutlet weak var reasonField:  UILabel!
    @IBOutlet weak var nameField:    UILabel!
    
    var product : [Products] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reasonField.text = product[0].reason!
        nameField.text   = product[0].name
        imageForAdd.image = UIImage(data: product[0].image as! Data)!
        cameraButton.isHidden=true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToList(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}
