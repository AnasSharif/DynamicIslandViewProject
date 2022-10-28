//
//  ViewController.swift
//  DynamicIslandProject
//
//  Created by Anas Sharif on 06/10/2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var linkTextField: UITextField!
    
    private let list = ["Contacts", "Descriptions" ,"Events", "Groups", "Tasks", "Category"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.linkTextField.text = "1"
    }

    @IBAction func actionDynamisList(_ sender: UIButton) {
        if let text = linkTextField.text, let count = Int(text) {
            
            var list: [String] = []
            for i in 0...count-1 {
                list.append(self.list[i])
            }
            let dynamicView = DynamicIslandView(items: list)
            self.view.addSubview(dynamicView)
            dynamicView.show()
        }
        self.linkTextField.endEditing(true)
    }
    
    @IBAction func actionDynamicIslandBtn(_ sender: UIButton) {
        let dynamicView = DynamicIslandView(items: ["Shake To Undo"])
        self.view.addSubview(dynamicView)
        dynamicView.show()
    }
}

