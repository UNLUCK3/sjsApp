//
//  ViewController.swift
//  SJS
//
//  Created by Bryndan Eigl on 2019-04-13.
//  Copyright © 2019 Bryndan Eigl. All rights reserved.
//

import UIKit
import SafariServices
import EventKit
import EventKitUI

class ViewController: UIViewController, SFSafariViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, AddTask, ChangeButton {
    
    let userD = UserDefaults.standard
    var tasks: [Task] = []
    //let eventStore = EKEventStore()
    
    //var calendars: [EKCalendar]?
    
    //Date formatter for the top dateLabel (dateLabel)
    let formatter = DateFormatter()
    //Date formatter for the bottom dateLabel (dateLabel2)
    let formatter2 = DateFormatter()
    var timer = Timer()
    
    //IBOutlets for the dateLabels
    @IBOutlet weak var sjsIcon: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateLabel2: UILabel!
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var permissionButton: UIButton!
    
    /*func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 // This was put in mainly for my own unit testing
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let calendars = self.calendars {
            return calendars.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell")!
        
        if let calendars = self.calendars {
            let calendarName = calendars[(indexPath as NSIndexPath).row].title
            cell.textLabel?.text = calendarName
        } else {
            cell.textLabel?.text = "Unknown Calendar Name"
        }
        
        return cell
    }*/
    
    //The following code manages the links at the bottom of the screen, and calling in-app safari to show the linked content.
    //When one of the link buttons is pressed, the corresponding logic will be executed
    //Open ManageBac
    @IBAction func mbopenURL(_ sender: Any) {
        guard let url = URL(string: "https://sjs.managebac.com/student") else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }
    //Open the SJS website
    @IBAction func sjsopenURL(_ sender: Any) {
        guard let url = URL(string: "https://www.stjohns.bc.ca/Home") else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }
    //Open Gmail
    @IBAction func gmopenURL(_ sender: Any) {
        guard let url = URL(string: "https://mail.google.com/mail/u/0/") else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }
    //Open MyBackpack
    @IBAction func bpopenURL(_ sender: Any) {
        guard let url = URL(string: "https://stjohns.seniormbp.com/SeniorApps/facelets/home/home.xhtml") else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(tasks)
        if let tasksData = userD.data(forKey: "savedTasksData"), let savedTasksData = try? JSONDecoder().decode(Task.self, from: tasksData) {
            tasks.append(savedTasksData)
            print(tasks)
            tableView.reloadData()
        }
        //let userTasks = userD.object(forKey: "savedTasksData") as? [Task] ?? [Task]()
        //tasks.append(contentsOf: userTasks)
        
        //permissionButton.isHidden = true
        
        //Requesting access to the calendar
        //requestCalendarAccess()
        //Capture the current date at initialisation
        let currentDateTime = Date()
        
        //Format the top label styles (dateLabel)
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        //Format the bottom label styles (dateLabel2)
        formatter2.timeStyle = .medium
        formatter2.dateStyle = .none
        
        //Update both labels so as to not show the placeholders
        dateLabel.text = formatter.string(from: currentDateTime)
        dateLabel2.text = formatter2.string(from: currentDateTime)
        
        //Schedule a timer to update the dateLabels every minute
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatedateLabel), userInfo: nil, repeats: true);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //checkCalendarAuthStatus()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        
        cell.taskNameLabel.text = tasks[indexPath.row].name
        
        if tasks[indexPath.row].checked {
            cell.checkBoxOutlet.setBackgroundImage(#imageLiteral(resourceName: "checkBoxFILLED "), for: UIControl.State.normal)
        } else {
            cell.checkBoxOutlet.setBackgroundImage(#imageLiteral(resourceName: "checkBoxOUTLINE "), for: UIControl.State.normal)
        }
        
        cell.delegate = self
        cell.indexP = indexPath.row
        cell.tasks = tasks
        
        return cell
    }
    
    func changeButton(checked: Bool, index: Int) {
        tasks[index].checked = checked
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddTaskController
        vc.delegate = self
    }
    
    func addTask(name: String) {
        tasks.append(Task(name: name))
        updateUserD()
        tableView.reloadData()
    }
    
    func updateUserD() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            userD.set(encoded, forKey: "savedTasksData")
        }
    }
    
    /*
    func checkCalendarAuthStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            requestCalendarAccess()
        case EKAuthorizationStatus.authorized:
            loadCalendars()
            refreshTableView()
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            break
        }
    }
    
    /*
     This function runs every minute, and updates the dateLabels.
     This function should eventually be split to only update the minutes every minute, and the date every day if time is available.
    */*/
    @objc func updatedateLabel() {
        let DateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        formatter2.timeStyle = .medium
        formatter2.dateStyle = .none
        dateLabel.text = formatter.string(from: DateTime)
        dateLabel2.text = formatter2.string(from: DateTime)
        //updateUserD()
    }
    /*
    func requestCalendarAccess() {
        eventStore.requestAccess(to: EKEntityType.event, completion: { (accessGranted: Bool, error: Error?) in
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    self.loadCalendars()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    self.needPermissionview()
                })
            }
        })
    }
    
    func loadCalendars() {
        self.calendars = eventStore.calendars(for: EKEntityType.event)
    }
    
    func needPermissionview() {
        permissionButton.isHidden = false
    }
    @IBAction func permissionButtonPressed(_ sender: Any) {
        let openSettingsURL = URL(string: UIApplication.openSettingsURLString)
        UIApplication.shared.openURL(openSettingsURL!)
    }
    
    func refreshTableView() {
        tableView.reloadData()
    }*/
    
}

class Task: Codable {
    var name = ""
    var checked = false
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
