//
//  TaskDetailViewController.swift
//  TaskIt
//
//  Created by SANTIPONG TANCHATCHAWAL on 6/23/15.
//  Copyright (c) 2015 SANTIPONG TANCHATCHAWAL. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    var detailTaskModel : TaskModel!
    //var mainVC : ViewController!

    @IBOutlet weak var taskTextField: UITextField!
    
    @IBOutlet weak var subTaskTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        println(self.detailTaskModel.task)
        taskTextField.text = detailTaskModel.task
        subTaskTextField.text = detailTaskModel.subtask
        dueDatePicker.date = detailTaskModel.date
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancellButtonTabbed(sender: UIBarButtonItem) {
        
        // Because we embedded into Navigation Controller, we can access its properties..
        self.navigationController?.popViewControllerAnimated(true)
        
    }

    @IBAction func doneButtonTabbed(sender: UIBarButtonItem) {
        
        // update taskArray
        //var task = TaskModel(task: taskTextField.text, subtask: subTaskTextField.text, date: dueDatePicker.date, completed: false)
        //mainVC.baseArray[0][mainVC.tableView.indexPathForSelectedRow()!.row] = task
        
        detailTaskModel.task = taskTextField.text
        detailTaskModel.subtask = subTaskTextField.text
        detailTaskModel.date = dueDatePicker.date
        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
        
        
        self.navigationController?.popViewControllerAnimated(true)
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
