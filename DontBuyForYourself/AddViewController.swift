//
//  AddViewController.swift
//  DontBuyForYourself
//
//  Created by Oleka on 09/12/16.
//  Copyright © 2016 Olga Blinova. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var rate1: UIButton!
    @IBOutlet weak var rate2: UIButton!
    @IBOutlet weak var rate3: UIButton!
    @IBOutlet weak var rate4: UIButton!
    @IBOutlet weak var rate5: UIButton!
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var imageForAdd:  UIImageView!
    @IBOutlet weak var reasonField:  UITextField!
    @IBOutlet weak var nameField:    UITextField!
    
    var rating : Int16 = 0
    var rateArray:[Bool] = [Bool](repeating: false, count:5)

    
    //Ratings issue
    
    
    
    @IBAction func changeRateState(_ sender: Any) {
        
        let rateIndex: Int = (sender as! UIButton).tag
        
        self.rateArray[rateIndex] = !self.rateArray[rateIndex]
        rating = changeRating(state: self.rateArray[rateIndex])
        
        if (self.rateArray[rateIndex]){
            (sender as! UIButton).isSelected=true
        }
        else{
            (sender as! UIButton).isSelected=false
        }
        
        //Animation
        
        UIView.animate(withDuration: 0.4, animations:{
            
           (sender as! UIButton).transform = CGAffineTransform(scaleX: 1.3, y: 1.3) },
                       completion:{
                        (finish: Bool) in UIView.animate(withDuration: 0.4, animations:{
                            (sender as! UIButton).transform = CGAffineTransform.identity
                        
                        })
        })
        

    }
    
    
    func changeRating(state: Bool) -> Int16 {
        
        if state {
            rating += 1
        }
        else{
            rating -= 1
        }
        
        return rating
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        nameField.delegate=self
        reasonField.delegate=self
        imageForAdd.image = UIImage(named: "empty_photo")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    //Photo controller
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //Change aspect when not dummy image
            self.imageForAdd?.contentMode = .scaleAspectFill
            self.imageForAdd?.clipsToBounds = true
            self.imageForAdd?.image = pickedImage
        }
        self.dismiss(animated: true, completion: nil)
        //self.bCamera.isHidden=true
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true)
    }
    
    func fn_photoFromCameraAction(){
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)
            imagePicker.mediaTypes = availableMediaTypes!
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    func fn_pickFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false //2
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary //3
            present(imagePicker, animated: true, completion: nil)//4
        }
    }
    
    func fn_clearPhoto(){
        self.imageForAdd?.image  = UIImage(named: "empty_photo")
    }
    
    
    
    //Select button action
    @IBAction func selectPhoto(_ sender: Any) {
        guard let viewRect = sender as? UIView else {
            return
        }
        
        let photoSettingsAlert = UIAlertController(title: NSLocalizedString("Please choose a photo", comment: ""), message: NSLocalizedString("", comment: ""), preferredStyle: .actionSheet)
        photoSettingsAlert.modalPresentationStyle = .popover
        
        let clear = UIAlertAction(title: NSLocalizedString("Clear Photo", comment: ""), style: .default) { action in
            self.fn_clearPhoto()
        }
        let photoFromAlbumAction = UIAlertAction(title: NSLocalizedString("Select Photo from Album", comment: ""), style: .default) { action in self.fn_pickFromLibrary()
            
        }
        let photoFromCameraAction = UIAlertAction(title: NSLocalizedString("Take Photo from Camera", comment: ""), style: .default) { action in self.fn_photoFromCameraAction()
            
        }
        
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { action in
            
        }
        
        photoSettingsAlert.addAction(cancel)
        photoSettingsAlert.addAction(photoFromCameraAction)
        photoSettingsAlert.addAction(photoFromAlbumAction)
        photoSettingsAlert.addAction(clear)
        
        if let presenter = photoSettingsAlert.popoverPresentationController {
            presenter.sourceView = viewRect;
            presenter.sourceRect = viewRect.bounds;
        }
        present(photoSettingsAlert, animated: true, completion: nil)
    }
    

    
    @IBAction func saveData(_ sender: Any) {
        
        //Check Empty Data
        if (reasonField.text ?? "").isEmpty && (nameField.text ?? "").isEmpty {
            let errAlert = UIAlertController(title: "Error!", message: "Empty data. Select the Name and the Reason", preferredStyle: UIAlertControllerStyle.alert)
            
            errAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
            }))
            present(errAlert, animated: true, completion: nil)
        }
        else {
            
            let _context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            //Add into StatLog
            let product = Products(context: _context)
            product.dt = NSDate()
            
            product.rating = rating
            
            if reasonField.text != nil {
                product.reason = reasonField.text
            }
            
            if nameField.text != nil {
                product.name = nameField.text
            }
            
            let uuid = NSUUID().uuidString
            product.id = uuid
            
            if imageForAdd  != nil {
                let contactImageData:NSData = UIImageJPEGRepresentation(imageForAdd.image!,1.0)! as NSData
                product.image = contactImageData
            }
        
            //Save data to CoreData
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
            dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func goToList(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}
