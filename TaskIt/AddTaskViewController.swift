//
//  AddTaskViewController.swift
//  TaskIt
//
//  Created by SANTIPONG TANCHATCHAWAL on 6/24/15.
//  Copyright (c) 2015 SANTIPONG TANCHATCHAWAL. All rights reserved.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController {
    
    // this is to pass VC from the main VC during prepareForSegue 
    // so that we can access its properties.
    //var mainVC : ViewController!

    @IBOutlet weak var taskTextField: UITextField!
    
    @IBOutlet weak var subTaskTextField: UITextField!
    
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addTaskButtonPressed(sender: UIButton) {
//        var task:TaskModel = TaskModel(task: taskTextField.text, subtask: subTaskTextField.text, date: dueDatePicker.date, completed: false)
//        mainVC.baseArray[0].append(task)
        
        // because core data functionalities are in AppDelegate. First thing is to get AppDelegate
        var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("TaskModel", inManagedObjectContext: managedObjectContext!)
        let taskModel = TaskModel(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
        // Now we get the taskModel. We can put the data in
        taskModel.task = taskTextField.text
        taskModel.subtask = subTaskTextField.text
        taskModel.date = dueDatePicker.date
        taskModel.completed = false
        // Now save into CoreData
        appDelegate.saveContext()
        
        // This is how to fetch data from Coredata
        var request = NSFetchRequest(entityName: "TaskModel")
        var error:NSError? = nil
        var result:NSArray = managedObjectContext!.executeFetchRequest(request, error: &error)!
        for res in result {
            println(res)
        }
        
        
        self.dismissViewControllerAnimated(true, completion: nil)

    }

    @IBAction func cancelButtonPressed(sender: UIButton) {
        // want to remove the addTaskViewController.. Because we use present modally
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
