//
//  ViewController.swift
//  ghclient-ios
//
//  Created by Xin Guo  on 2018/10/28.
//  Copyright © 2018 com.thoughtworks.workshop. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    
    override func viewDidLoad() {
    super.viewDidLoad()
    let currentDateTime = Date()
        timelabel.text = "12:12"
        
    // Do any additional setup after loading the view, typically from a nib.
  }


}

