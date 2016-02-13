//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Joseph Hooper on 1/24/16.
//  Copyright © 2016 josephdhooper. All rights reserved.
//  The "if statement" in func keyboardWillShow(notification: NSNotification) and func keyboardWillHide(notification: NSNotification were taken github and from the following stackoverflow page: http://stackoverflow.com/questions/34082835/swift-2-addobserver-for-specific-textfield-with-the-object-parameter


import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var memes: [Meme]!
    var selectedImage: UIImage?
    
    let memeTextAttributes = [
        NSForegroundColorAttributeName : UIColor.blackColor(),
        NSStrokeColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "Impact", size: 30)!,
        NSStrokeWidthAttributeName : -2.0 ]
    
    let topDefaultText = "TOP"
    let bottomDefaultText = "Bottom"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField(topText)
        setupTextField(bottomText)


//        topText.text = "TOP"
//        bottomText.text = "BOTTOM"
        shareButton.enabled = false
//
//        bottomText.defaultTextAttributes = memeTextAttributes
//        topText.defaultTextAttributes = memeTextAttributes
//        
//        bottomText.textAlignment = NSTextAlignment.Center
//        topText.textAlignment = NSTextAlignment.Center
//        
//        bottomText.delegate = self
//        topText.delegate = self
        
        
    
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subsribeToKeyboardNotification()
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotification()
}


    
    @IBAction func pickAnImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion:nil)
    }
    
    
    @IBAction func takePhoto(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion:nil)
        
    }
    
    
    @IBAction func shareMeme(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
        activityController.completionWithItemsHandler = { activity, success, items, error in
            if( activity == UIActivityTypeSaveToCameraRoll && success) {
                self.saveMeme()
                self.presentSentMeme()
            }
        }
        
    }
    
    
    @IBAction func cancelMeme(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        bottomText.text = "BOTTOM"
        topText.text = "TOP"
        imagePickerView.image = nil
        shareButton.enabled = false
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //Clear default text
        if textField.text == "BOTTOM" || textField.text == "TOP" {
            textField.text = ""
        }
    }

    func saveMeme() {
        if(imagePickerView.image != nil){
            let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, image: imagePickerView.image!, memedImage: generateMemedImage())
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.append(meme)
            UIImageWriteToSavedPhotosAlbum(generateMemedImage(), self, Selector("image:didFinishSavingWithError:contextInfo:"), nil)
        }
        
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafePointer<()>) {
        dispatch_async(dispatch_get_main_queue(), {
            
        })
    }

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            shareButton.enabled = true
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func presentSentMeme() {
        let memeMeTabBarViewController = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarController") as! UITabBarController
        self.presentViewController(memeMeTabBarViewController, animated: true, completion: nil)
    }

    
    func generateMemedImage() -> UIImage {
        
        let desiredSize = CGSize(width: view.frame.width, height: view.frame.height - toolBar.frame.height)
        
        navBar.hidden = true
        toolBar.hidden = true
        
        UIGraphicsBeginImageContext(desiredSize)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        navBar.hidden = false
        toolBar.hidden = false
        
        return memedImage
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func resetText(){
        topText.text = topDefaultText
        bottomText.text = bottomDefaultText
    }
    
    func setupTextField(textField: UITextField) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.Center
        textField.delegate = self
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func subsribeToKeyboardNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
}





    