//
//  HomeTableViewController.swift
//  TableViewSample
//
//  Created by Kavya on 08/05/18.
//  Copyright © 2018 Kavya. All rights reserved.
//

import UIKit

let cellReuseIdentifier = "Cell"

class HomeTableViewController: UITableViewController {

    var arrayOfData = ["Apple", "Apricot", "Banana", "Blueberry", "Orange"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNewdataButton()
        self.tableView.allowsSelectionDuringEditing = true
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addNewdataButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewRowWithData))
    }
    
    // MARK: Tableview DataSource Method
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfData.count
    }
    
    internal override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = String(self.arrayOfData[indexPath.row])

        return cell
    }
    
    // MARK: Tableview Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Adding UIAlertController for editing data in to table view cell
        
        let alertController = UIAlertController(title: String.localizedValueForKey(key: kEdit_Name_Title_String), message:String.localizedValueForKey(key:kGENERAL_Empty_string), preferredStyle: UIAlertControllerStyle.alert)
        let saveAction = UIAlertAction(title: String.localizedValueForKey(key:kGENERAL_Save_String), style: UIAlertActionStyle.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0]
            let cell = self.tableView.cellForRow(at: indexPath)
            cell?.textLabel?.text = firstTextField.text

        })
        let cancelAction = UIAlertAction(title: String.localizedValueForKey(key:kGENERAL_Cancel_String), style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in })
        alertController.addTextField { (textField : UITextField!) -> Void in
            let indexPath = tableView.indexPathForSelectedRow
            
            let currentCell = tableView.cellForRow(at: indexPath!)
            
            textField.text = currentCell?.textLabel!.text
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            self.arrayOfData.remove(at: indexPath.row)
            let arrIndexesToDelete = [indexPath]
            self.tableView.deleteRows(at: arrIndexesToDelete as [IndexPath], with: UITableViewRowAnimation.right)
        }
    }
    
    // MARK: - Reordering
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let rowContent = self.arrayOfData[sourceIndexPath.row]
        self.arrayOfData.remove(at: sourceIndexPath.row)
        self.arrayOfData.insert(rowContent, at: destinationIndexPath.row)
    }
    
    @objc func insertNewRowWithData(sender: UIBarButtonItem) {
        
        // Adding UIAlertController for entring new data in to table view
        
        let alertController = UIAlertController(title:String.localizedValueForKey(key: kAdd_Name_Title_String), message:String.localizedValueForKey(key: kGENERAL_Empty_string), preferredStyle: UIAlertControllerStyle.alert)
        let saveAction = UIAlertAction(title:String.localizedValueForKey(key: kGENERAL_Save_String), style: UIAlertActionStyle.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0]
            let secondTextField = alertController.textFields![1]
            
            let index = (secondTextField.text! as NSString).integerValue
            
            if(index > self.arrayOfData.count){
                self.showInvalidIndexAlert()
            } else if (firstTextField.text != String.localizedValueForKey(key: kGENERAL_Empty_string)){
                /*
                 If index is lesser than array count take that index and insert value for that index else value will be inserted for zero index
                 */
                self.insertElementAtIndex(element: firstTextField.text, index: index)
            }
        })
        let cancelAction = UIAlertAction(title:String.localizedValueForKey(key:kGENERAL_Cancel_String), style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = String.localizedValueForKey(key:kEnter_Name_PlaceHolder_String)
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = String.localizedValueForKey(key:kEnter_index_PlaceHolder_String)
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // Insert value for a given index
    
    func insertElementAtIndex(element: String?, index: Int) {
        
        // Cell index will start from zero.But from user prospective it should start from one.
        
        var insertingIndex = index - 1
        
        if (insertingIndex < 0) {
            insertingIndex = 0
        }
        
        while arrayOfData.count <= insertingIndex {
            arrayOfData.append(element!)
        }
        arrayOfData.insert(element!, at: insertingIndex)
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath.init(row: insertingIndex, section: 0)], with: .automatic)
        self.tableView.endUpdates()
    }
    
    func showInvalidIndexAlert() {
        let alert = UIAlertController(title: String.localizedValueForKey(key:kError_Title_String), message: String.localizedValueForKey(key: kError_Message_String), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title:String.localizedValueForKey(key:kGENERAL_Ok_string), style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

