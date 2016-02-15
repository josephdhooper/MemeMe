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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        deleteBool = false
        tableView.setEditing(deleteBool, animated: true)
        tableView.reloadData()
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.removeAtIndex(indexPath.row)
        memes.removeAtIndex(indexPath.row)
        tableView.reloadData()
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell", forIndexPath : indexPath) as! MemeTableViewCell
        
        let meme = memes[indexPath.row]
        cell.topLabel.text = meme.topText
        cell.bottomLabel.text = meme.bottomText
        cell.imageView?.image = meme.memedImage
        return cell
    
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        
        navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    @IBAction func deleteMeme(sender: AnyObject) {
        deleteBool = !deleteBool
        tableView.setEditing(deleteBool, animated: true)
    }
    
    
    @IBAction func createMeme(sender: AnyObject) {
        let editorController = storyboard!.instantiateViewControllerWithIdentifier("memeMeVC") as! MemeEditorViewController
        presentViewController(editorController, animated: true, completion: nil)
    }

}
    