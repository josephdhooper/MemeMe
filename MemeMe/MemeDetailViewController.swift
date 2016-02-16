//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Joseph Hooper on 1/24/16.
//  Copyright © 2016 josephdhooper. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    var meme: Meme!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: UIBarButtonItemStyle.Plain, target: self, action: "deleteMeme")
        
        
    }
    
        func deleteMeme() {
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            for var index = 0; index < appDelegate.memes.count; index++ {
                if appDelegate.memes[index].memedImage == meme.memedImage {
                    appDelegate.memes.removeAtIndex(index)
                    if let navigationController = self.navigationController {
                        navigationController.popToRootViewControllerAnimated(true)
                    }
                }
            }
        }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = true
        imagePickerView!.image = meme.memedImage
        
    }
        
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.hidden = false
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    
    }
}
