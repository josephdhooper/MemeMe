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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MemeDetailViewController.deleteMeme))
        
        
    }
    
    
            func deleteMeme() {
                let applicationDelegate = (UIApplication.shared.delegate as! AppDelegate)
                applicationDelegate.memes.removeLast()
                self.navigationController?.popViewController(animated: true)
                
            }
    
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

