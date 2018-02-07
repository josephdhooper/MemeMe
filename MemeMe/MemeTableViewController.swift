//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Joseph Hooper on 1/24/16.
//  Copyright © 2016 josephdhooper. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    @IBOutlet weak var addNewMeme: UIBarButtonItem!
    
    var memes : [Meme]!
    var deleteBool : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        deleteBool = false
        tableView.setEditing(deleteBool, animated: true)
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.remove(at: indexPath.row)
        memes.remove(at: indexPath.row)
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell", for : indexPath as IndexPath) as! MemeTableViewCell
        
        let meme = memes[indexPath.row]
        cell.topLabel.text = meme.topText
        cell.bottomLabel.text = meme.bottomText
        cell.imageView?.image = meme.memedImage
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        
        navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    @IBAction func deleteMeme(sender: AnyObject) {
        deleteBool = !deleteBool
        tableView.setEditing(deleteBool, animated: true)
    }
    
    
    @IBAction func createMeme(sender: AnyObject) {
        let editorController = storyboard!.instantiateViewController(withIdentifier: "memeMeVC") as! MemeEditorViewController
        present(editorController, animated: true, completion: nil)
    }
    
}


    
