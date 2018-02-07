//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Joseph Hooper on 1/24/16.
//  Copyright © 2016 josephdhooper. All rights reserved
//  See site for information on pinch, zoom and pan: https://stackoverflow.com/questions/45402639/pinch-pan-and-rotate-text-simultaneously-like-snapchat-swift-3


import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var width: CGFloat = 0
    var height: CGFloat = 0
    
    var memes: [Meme]!
    var selectedImage: UIImage?
    
    let memeTextAttributes = [NSAttributedStringKey : Any] ()
    
    let topDefaultText = "TOP"
    let bottomDefaultText = "BOTTOM"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField(textField: topText)
        setupTextField(textField: bottomText)
        
        //add pan gesture
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        gestureRecognizer.delegate = self
        imagePickerView.addGestureRecognizer(gestureRecognizer)
        
        //add pinch gesture
        let pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(pinchRecognized(pinch:)))
        pinchGesture.delegate = self
        imagePickerView.addGestureRecognizer(pinchGesture)
        
        //add rotate gesture
//        let rotate = UIRotationGestureRecognizer.init(target: self, action: #selector(handleRotate(recognizer:)))
//        rotate.delegate = self
//        imagePickerView.addGestureRecognizer(rotate)
        
    }
    
    func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {

            let translation = gestureRecognizer.translation(in: self.view)
            // note: 'view' is optional and need to be unwrapped
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
        }

    }
    
    func pinchRecognized(pinch: UIPinchGestureRecognizer) {
        
        if let view = pinch.view {
            view.transform = view.transform.scaledBy(x: pinch.scale, y: pinch.scale)
            pinch.scale = 1
        }
    }
    
//    func handleRotate(recognizer : UIRotationGestureRecognizer) {
//        if let view = recognizer.view {
//            view.transform = view.transform.rotated(by: recognizer.rotation)
//            recognizer.rotation = 0
//        }
//    }
    
    func gestureRecognizer(_: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.contentMode = .scaleAspectFit
            imagePickerView.image = image
            shareButton.isEnabled = true
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func presentImagePickerWithSource(sourceType: UIImagePickerControllerSourceType) {
        let imagePickerView = UIImagePickerController()
        imagePickerView.delegate = self
        imagePickerView.sourceType = sourceType
        self.present(imagePickerView, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImage(sender: Any) {
       presentImagePickerWithSource(sourceType: .photoLibrary)
    }
    
    @IBAction func takePhoto(sender: Any) {
         presentImagePickerWithSource(sourceType: .camera)
    }

    func saveMeme() {
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, image: imagePickerView.image!, memedImage: generateMemedImage())
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
       
        let activityController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        activityController.completionWithItemsHandler = { activity, success, items, error in
            
            if success {
                self.saveMeme()
                self.presentingViewController?.dismiss(animated: true, completion: nil)
                
            }
        }
    }
    
    @IBAction func cancelMeme(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        resetText()
        imagePickerView.image = nil
        shareButton.isEnabled = false
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        if textField.text == "BOTTOM" || textField.text == "TOP" {
            textField.text = ""
        }
    }
   
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        DispatchQueue.main.async {
            
        }
    }
    
    func presentSentMeme() {
        let memeMeTabBarViewController = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        present(memeMeTabBarViewController, animated: true, completion: nil)
    }
    
    func hideToolbarAndNavbar (hide: Bool){
        navBar.isHidden = hide
        toolBar.isHidden = hide
    }
    
    func generateMemedImage() -> UIImage {
        hideToolbarAndNavbar(hide: true)
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideToolbarAndNavbar(hide: false)
        
        return memedImage
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func resetText(){
        topText.text = topDefaultText
        bottomText.text = bottomDefaultText
    }
    
    func setupTextField(textField: UITextField) {
        textField.defaultTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
        NSStrokeColorAttributeName : UIColor.black,
        NSFontAttributeName: UIFont(name: "Impact", size: 30)!,
        NSStrokeWidthAttributeName : -2.0]
        textField.textAlignment = NSTextAlignment.center
        textField.delegate = self
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: Move keyboard up and down
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    

    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow (_ notification:Notification) {
        if bottomText.isFirstResponder {
        view.frame.origin.y = getKeyboardHeight(notification) * (-1)
    }
    }
    
    func keyboardWillHide (_ notification: Notification){
        if bottomText.isFirstResponder {
        view.frame.origin.y = 0
    }
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}


    
