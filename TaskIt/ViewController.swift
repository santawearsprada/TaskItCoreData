//
//  ViewController.swift
//  TaskIt
//
//  Created by SANTIPONG TANCHATCHAWAL on 6/22/15.
//  Copyright (c) 2015 SANTIPONG TANCHATCHAWAL. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    //var taskArray : [Dictionary<String,String>] = []
    //var taskArray : [TaskModel] = []
    
    //var baseArray:[[TaskModel]] = []
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    var fetchedResultController:NSFetchedResultsController = NSFetchedResultsController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self    // THis is to add NSFetchedResultControllerDelegate protocol
        fetchedResultController.performFetch(nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultController.sections!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return baseArray[section].count  // return number of row in each (incomplete, complete) section
        return fetchedResultController.sections![section].numberOfObjects!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let thisTask = fetchedResultController.objectAtIndexPath(indexPath) as! TaskModel
        
        var taskCell : TaskCell = tableView.dequeueReusableCellWithIdentifier("myCell") as! TaskCell
        
        
        taskCell.taskLabel.text = thisTask.task
        taskCell.subTaskLabel.text = thisTask.subtask
        taskCell.dateTaskLabel.text = Date.toString(date: thisTask.date)
        
        return taskCell
    }
    
    //UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("Selected: \(indexPath.row)")
        performSegueWithIdentifier("showTaskDetail", sender: self)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if fetchedResultController.sections?.count == 1 {  // if there is only 1 section
            let thisTask = fetchedResultController.fetchedObjects![0] as! TaskModel
            return thisTask.completed.boolValue ? "Completed" : "To Do"
            
        } else {
            return section == 0 ? "To Do" : "Completed"
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // By Default ... action is "Delete" ????
        /*
        let thisTask = baseArray[indexPath.section][indexPath.row]
        
        var newTask = TaskModel(task: thisTask.task, subtask: thisTask.subtask, date: thisTask.date, completed : true)
        baseArray[indexPath.section].removeAtIndex(indexPath.row)
        baseArray[1].append(newTask)
        tableView.reloadData()
        */
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let thisTask = fetchedResultController.objectAtIndexPath(indexPath) as! TaskModel
        
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler: {
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            //self.managedObjectContext.deletedObjects(self.fetchedResultController.objectAtIndexPath(indexPath) as! TaskModel)
            self.managedObjectContext.deleteObject(self.fetchedResultController.objectAtIndexPath(indexPath) as! TaskModel)
            (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
            
        })
        
        
        var completeTaskAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Complete", handler: {
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            let thisTask = self.fetchedResultController.objectAtIndexPath(indexPath) as! TaskModel
            
            thisTask.completed = true
            
            (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
            
            
        })

        completeTaskAction.backgroundColor = UIColor(red: 255.0/255.0, green: 166.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        
        var inCompleteTaskAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Incomplete", handler: {
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            let thisTask = self.fetchedResultController.objectAtIndexPath(indexPath) as! TaskModel
            
            thisTask.completed = false
            
            (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
            
            
          })
        
        inCompleteTaskAction.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 200.0/255.0, alpha: 1.0)
        
        if thisTask.completed == false {
            return [deleteAction, completeTaskAction]
        } else {
            return [deleteAction, inCompleteTaskAction]
        }
    }
    
    
    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showAddTask", sender: self)
        
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTaskDetail" {
            let detailVC : TaskDetailViewController = segue.destinationViewController as! TaskDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow()
            detailVC.detailTaskModel = fetchedResultController.objectAtIndexPath(indexPath!) as! TaskModel
            //detailVC.mainVC = self
            
            
        } else if segue.identifier == "showAddTask" {
            let addTaskVC : AddTaskViewController = segue.destinationViewController as! AddTaskViewController
            
            //addTaskVC.mainVC = self   // passing this view controller to destination VC which is AddTaskViewController
            
        }
    }
    
    // NSFetchedResultController Delegate function
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        // This function will be called everytime when the Entity is changed!
        println("RELOAD")
        tableView.reloadData()
    }
    
    // Helper Function
    func getFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "TaskModel")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let sortByCompleteDescriptor = NSSortDescriptor(key: "completed", ascending: true)
        fetchRequest.sortDescriptors = [sortByCompleteDescriptor, sortDescriptor]  // This is to tell the sorter to sort by "completed" field and sorted by "date" field

        
        return fetchRequest
    }
    
    func getFetchedResultController() -> NSFetchedResultsController {
        // sectionNameKeyPath is the field to make the section
        fetchedResultController = NSFetchedResultsController(fetchRequest: getFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: "completed", cacheName: nil)
        
        return fetchedResultController
    }
    
}

