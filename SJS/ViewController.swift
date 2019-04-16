//
//  ViewController.swift
//  SJS
//
//  Created by Bryndan Eigl on 2019-04-13.
//  Copyright © 2019 Bryndan Eigl. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, SFSafariViewControllerDelegate {
    
    //Date formatter for the top dateLabel (dateLabel)
    let formatter = DateFormatter()
    //Date formatter for the bottom dateLabel (dateLabel2)
    let formatter2 = DateFormatter()
    var timer = Timer()
    
    //IBOutlets for the dateLabels
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateLabel2: UILabel!
    
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
        //Capture the current date at initialisation
        let currentDateTime = Date()
        
        //Format the top label styles (dateLabel)
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        //Format the bottom label styles (dateLabel2)
        formatter2.timeStyle = .short
        formatter2.dateStyle = .none
        
        //Update both labels so as to not show the placeholders
        dateLabel.text = formatter.string(from: currentDateTime)
        dateLabel2.text = formatter2.string(from: currentDateTime)
        
        //Schedule a timer to update the dateLabels every minute
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updatedateLabel), userInfo: nil, repeats: true);
    }
    
    /*
     This function runs every minute, and updates the dateLabels.
     This function should eventually be split to only update the minutes every minute, and the date every day if time is available.
    */
    @objc func updatedateLabel() {
        let DateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        formatter2.timeStyle = .short
        formatter2.dateStyle = .none
        dateLabel.text = formatter.string(from: DateTime)
        dateLabel2.text = formatter2.string(from: DateTime)
    }
}
