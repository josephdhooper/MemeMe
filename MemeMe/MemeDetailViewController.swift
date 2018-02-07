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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: UIBarButtonItemStyle.plain, target: self, action: Selector(("deleteMeme")))
        
        
    }
    
    //        func deleteMeme() {
    //            let object = UIApplication.shared.delegate
    //            let appDelegate = object as! AppDelegate
    //            for var index = 0; index < appDelegate.memes.count; index++ {
    //                if appDelegate.memes[index].memedImage == meme.memedImage {
    //                    appDelegate.memes.remove(at: index)
    //                    if let navigationController = self.navigationController {
    //                        navigationController.popToRootViewController(animated: true)
    //                    }
    //                }
    //            }
    //        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        imagePickerView!.image = meme.memedImage
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
        
    }
}

