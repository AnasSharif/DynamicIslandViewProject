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


    @IBAction func actionDynamicIslandBtn(_ sender: UIButton) {
        let dynamicView = DynamicIslandView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 38))
        self.view.addSubview(dynamicView)
        dynamicView.show()
    }
}

