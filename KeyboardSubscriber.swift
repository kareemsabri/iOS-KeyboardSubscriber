import Foundation
import UIKit

protocol KeyboardSubscriber: class {
    var keyboardObservers: [NSObjectProtocol] { get set }
    var activeField: UIView! { get }
    var scrollView: UIScrollView! { get}
    func registerForKeyboardNotifications()
    func deregisterForKeyboardNotifications()
    func keyboardWasShown(notification: NSNotification)
    func keyboardWillBeHidden(notification: NSNotification)
}

extension KeyboardSubscriber {
    func registerForKeyboardNotifications() {
        self.keyboardObservers = [
            NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardDidShowNotification, object: nil, queue: nil) { [unowned self] notification in
                self.keyboardWasShown(notification)
            },
            NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: nil) { [unowned self] notification in
                self.keyboardWillBeHidden(notification)
            }
        ]
    }
    
    func deregisterForKeyboardNotifications() {
        for observer in keyboardObservers {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
    }
    
    func keyboardWasShown(notification: NSNotification) {
        let keyboardSize = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]!.CGRectValue!.size
        let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
        self.scrollView.setContentOffset(CGPoint(x: 0, y: self.activeField.frame.minY - 8), animated: true)
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        let contentInset = UIEdgeInsetsZero
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
    }
}

