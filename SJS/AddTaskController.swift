//
//  AddTaskController.swift
//  SJS
//
//  Created by Bryndan Eigl on 2019-04-21.
//  Copyright © 2019 Bryndan Eigl. All rights reserved.
//

import UIKit

protocol AddTask {
    func addTask(name: String)
}
class AddTaskController: UIViewController {

    @IBOutlet weak var taskNameOutlet: UITextField!
    
    @IBAction func addAction(_ sender: Any) {
        if taskNameOutlet.text != "" {
            delegate?.addTask(name: taskNameOutlet.text ?? "nil")
            navigationController?.popViewController(animated: true)
        }
    }
    
    var delegate: AddTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
