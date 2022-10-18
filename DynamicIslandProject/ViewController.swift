//
//  ViewController.swift
//  DynamicIslandProject
//
//  Created by Anas Sharif on 06/10/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func actionDynamisList(_ sender: UIButton) {
        let dynamicView = DynamicIslandView(items: ["Title 1", "Title 2", "Title 3","Title 4"])
        self.view.addSubview(dynamicView)
        dynamicView.show()
    }
    
    @IBAction func actionDynamicIslandBtn(_ sender: UIButton) {
        let dynamicView = DynamicIslandView(items: ["SHAKE TO UNDO"])
        self.view.addSubview(dynamicView)
        dynamicView.show()
    }
}

