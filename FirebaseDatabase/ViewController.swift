//
//  ViewController.swift
//  FirebaseDatabase
//
//  Created by Julian Abhari on 7/30/16.
//  Copyright © 2016 Julian Abhari. All rights reserved.
//

import UIKit
import Firebase

struct postStruct {
    let message : String!
}

class ViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {
   
    @IBOutlet var ScrollView: UIScrollView!
    @IBOutlet var table: UITableView!
    @IBOutlet var textField: UITextField!
    
    var posts = [postStruct]()
    var userMessage: String = ""
        
    func post() { //post function
        let post : [String : String] = ["message" : userMessage]
        let databaseRef = FIRDatabase.database().reference()
        
        databaseRef.child("Posts").childByAutoId().setValue(post)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("Posts").queryOrderedByKey().observe(.childAdded, with: {
            
            snapshot in
            let message = (snapshot.value! as! [String: String]) ["message"]!
            self.posts.insert(postStruct(message: message), at: 0)
            self.table.reloadData()
            
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        ScrollView.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        ScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        userMessage = textField.text!
        post()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //TableView numberOfRowsInSection
        return posts.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell { //TableView manage CellsAtIndexPath
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let label = cell?.viewWithTag(1) as! UILabel
        label.text = posts[(indexPath as NSIndexPath).row].message
        return cell!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

