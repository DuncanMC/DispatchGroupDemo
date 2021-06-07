//
//  ViewController.swift
//  DispatchGroupDemo
//
//  Created by Duncan Champney on 6/6/21.
//

import UIKit

class ViewController: UIViewController {

    // Create a type that holds a work item index and a value
    typealias WorkItemResult = (workItemIndex: Int, value: Int)

    // An array to hold the results of our work items.
    var results = [WorkItemResult]()

    // A dispatch group to keep track of the work items.
    let group = DispatchGroup()
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var doStuffButton: UIButton!

    func dispatchGroupNotify() {
        // Submit a closure to be run when the last task submitted above completes.
        group.notify(queue: DispatchQueue.main) {

            // Find the WorkItemResult in our results array with the largest value
            if let maxItem = self.results.max(by: { $0.value < $1.value }) {
                self.textView.text = self.textView.text + "\n" + "All done. Max item: \n\(maxItem)\n"
            }
            self.doStuffButton.isEnabled = true
        }
    }

    @IBAction func doStuffAction(_ sender: UIButton) {
        self.textView.text = ""

        sender.isEnabled = false
        // Zero out our results array for this run
        results = [WorkItemResult]()

        for workItemNumber in 1...10 {

            self.group.enter() // Tell the DispatchGroup we are submitting another work item

            // Submit a task on a global backround thread
            DispatchQueue.global(qos: .background).async() {
                // Delay for a random 10,000 ... 500,000 microseconds (1/10 to 1/2 second)
                // This simulates an async task (like a network request)
                // that takes an unpredictable amount of time to finish
                let delay = UInt32.random(in: 10000...500000)
                usleep(delay)

                // Generate a random value
                let returnValue = Int.random(in: 1...10000)

                // On the main thread, add the results of this item to our array of results
                DispatchQueue.main.async {
                    self.results.append((workItemNumber, returnValue))
                    let workItemNumberString = String(format: "%2d", workItemNumber)
                    let resultString = String(format: "%4d", returnValue)
                    self.textView.text = self.textView.text  + "Work item \(workItemNumberString): Result = \(resultString)\n"
                    self.group.leave()
                }
            }
        }
        dispatchGroupNotify()
    }
}

