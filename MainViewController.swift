//
//  MainViewController.swift
//  Grumpbee
//
//  Created by Thomas Yu on 11/1/14.
//  Copyright (c) 2014 thomaswhyyou. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBAction func didPressLink(sender: AnyObject) {
        if (DBSession.sharedSession().isLinked() != true) {
            DBSession.sharedSession().linkFromController(self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
