//
//  ViewController.swift
//  Camer Demo
//
//  Created by Billy Mahmood on 28/10/2016.
//  Copyright © 2016 Billy Mahmood. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
        UIImagePickerControllerDelegate,
        UINavigationControllerDelegate
    {
    
    @IBOutlet weak var PhotoLibrary: UIButton!
    @IBOutlet weak var Camera: UIButton!
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var sepiaBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isHidden = true
        sepiaBtn.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func PhotoLibraryAction(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            
            imagePicker.allowsEditing = true;
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    @IBAction func CameraAction(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            
            imagePicker.allowsEditing = true;
            self.present(imagePicker, animated: true, completion: nil)
            
            saveButton.isHidden = false
            sepiaBtn.isHidden = false

            Camera.setTitle("Take another photo", for: UIControlState.normal)
        }

    }
    
    
    @IBAction func saveAction(_ sender: UIButton) {
        let imageData = UIImageJPEGRepresentation(imagePicked.image!, 0.6)
        let compressedJPEGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPEGImage!, nil, nil, nil)
        
        saveNotice()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject: AnyObject]!) {
        
        imagePicked.image = image
        self.dismiss(animated: true, completion: nil);

    }
    
    func saveNotice() {
        let alertController = UIAlertController(title: "Picture was saved.", message: "Your picture was saved", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
        saveButton.isHidden = true
        sepiaBtn.isHidden = true

    }
    
    @IBAction func addFilterAction(_ sender: UIButton) {
        guard let image = self.imagePicked.image?.cgImage else { return }
        
        let openGLContext = EAGLContext(api: .openGLES3)
        let context = CIContext(eaglContext: openGLContext!)
        
        let ciImage = CIImage(cgImage: image)
        
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(1, forKey: kCIInputIntensityKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            self.imagePicked?.image = UIImage(cgImage: context.createCGImage(output, from: output.extent)!)
        }
    }
}

