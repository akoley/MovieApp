//
//  ViewController.swift
//  Assignment
//
//  Created by Amrita Koley on 9/16/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import UIKit
import Reachability

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private static let spaceBetweenMessageLabelAndRetryButton: CGFloat = 40.0
    
    @IBOutlet internal var activityIndicatorView: RUIActivityIndicatorView!
    private var networkImage: UIImageView!
    private var messageLabel: UILabel!
    private var refreshButton: UIButton!
    private var messageLabelYConstraint: NSLayoutConstraint!
    private var retryButtonYConstraint: NSLayoutConstraint!
    private var networkImageYConstraint: NSLayoutConstraint!
    
    internal var _initialOriginY : CGFloat = CGFloat.greatestFiniteMagnitude
    
    internal var reachability : Reachability!
    internal var _isReachabilityRecieved = false
    
    internal var _isViewVisible:Bool = false
    
    class func identifier() -> String {
        return "ViewController"
    }
    
    open override var shouldAutorotate: Bool {
        return false
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override open func loadView() {
        super.loadView()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _isViewVisible = true
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _isViewVisible = false
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        reachability = Reachability()
        
        // Do any additional setup after loading the view.
        initViewController()
    }
    
    deinit {
        if (reachability != nil) {
            reachability.stopNotifier()
        }
        NotificationCenter.default.removeObserver(
            self,
            name: .reachabilityChanged,
            object: reachability)
        NotificationCenter.default.removeObserver(self)
    }
    
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer) {
            if(navigationController!.viewControllers.count > 1){
                return true
            }
            return false
        }
        
        return true
    }
    
    private func initViewController() {
        if activityIndicatorView == nil {
            activityIndicatorView = RUIActivityIndicatorView(style: .whiteLarge)
            self.view.addSubview(activityIndicatorView)
            installCenterInParentConstraints(self.view, childView: activityIndicatorView)
        }
        //activityModalView = ULModalActivityView()
        
        let heightFactor: CGFloat = 1/1
        let windowWidth : CGFloat = sizeOfWindowWrtEye().width
        let imageWidth: CGFloat = windowWidth
        let imageHeight: CGFloat = heightFactor*imageWidth
        networkImage = UIImageView(frame: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
        networkImage.image = UIImage(named: "no_network_image")
        networkImage.contentMode = .scaleAspectFit
        self.view.addSubview(networkImage)
        installMatchSuperviewMarginLayoutConstraints(
            self.view,
            childView: networkImage,
            locations: [MarginLayoutLocation.Left, MarginLayoutLocation.Right])
        _ = installCenterXInParentConstraints(
            self.view,
            childView: networkImage)
        networkImageYConstraint = installCenterYInParentConstraints(
            self.view,
            childView: networkImage)
        networkImageYConstraint.constant = networkImageYConstraint.constant - ViewController.spaceBetweenMessageLabelAndRetryButton
        
        messageLabel = UILabel()
        messageLabel.text = Constants.ErrorString.SomethingWentWrong
        messageLabel.font = UIFont.MrEavesXlModOTRegularFont(fontSize: 18)
        messageLabel.textColor = UIColor.orange
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(messageLabel)
        installMatchSuperviewMarginLayoutConstraints(
            self.view,
            childView: messageLabel,
            locations: [MarginLayoutLocation.Left, MarginLayoutLocation.Right])
        _ = installCenterXInParentConstraints(
            self.view,
            childView: messageLabel)
        messageLabelYConstraint = installCenterYInParentConstraints(self.view, childView: messageLabel)
        messageLabelYConstraint.constant = networkImageYConstraint.constant + 2 * ViewController.spaceBetweenMessageLabelAndRetryButton
        
        refreshButton = UIButton()
        refreshButton.titleLabel?.textAlignment = NSTextAlignment.center
        refreshButton.setTitle(
            "\t" + Constants.StringConstants.Retry + "\t",
            for: UIControl.State())
        refreshButton.titleLabel?.font = UIFont.MrEavesXlModOTRegularFont(fontSize: 18)
        refreshButton.setTitleColor(UIColor.orange, for: UIControl.State())
        refreshButton.backgroundColor = UIColor.clear
        refreshButton.layer.borderColor = UIColor.orange.cgColor
        refreshButton.layer.borderWidth = 0.8
        refreshButton.layer.cornerRadius = 4.0
        refreshButton.layer.masksToBounds = true
        refreshButton.addTarget(self, action: #selector(ViewController._refreshButtonPressed(_:)),
                                for: .touchUpInside)
        self.view.addSubview(refreshButton)
        _ = installCenterXInParentConstraints(view, childView: refreshButton)
        retryButtonYConstraint = installCenterYInParentConstraints(
            self.view,
            childView: refreshButton)
        retryButtonYConstraint.constant = messageLabelYConstraint.constant + ViewController.spaceBetweenMessageLabelAndRetryButton
        var errorData = ErrorPageData.init()
        errorData.shouldShowRetryButton = false
        errorData.shouldShowMessage = false
        showMessage(errorData: errorData)
        activityIndicatorView.stopAnimating()
        activityIndicatorView.hidesWhenStopped = true
        startInternetReachability()
    }
    
    @objc internal func _refreshButtonPressed(_ sender: AnyObject) {
        
    }
    
    func showMessage(errorData: ErrorPageData) {
        messageLabel.text = errorData.errorMessage
        messageLabel.isHidden = !errorData.shouldShowMessage
        refreshButton.titleLabel?.textAlignment = NSTextAlignment.center
        refreshButton.isHidden = !errorData.shouldShowRetryButton
        networkImage.image = errorData.errorImage
        switch reachability.connection {
        case .none:
            if errorData.shouldShowRetryButton
                && errorData.shouldShowMessage {
                networkImage.isHidden = false
            } else {
                networkImage.isHidden = true
            }
        default:
            networkImage.isHidden = true
        }
    }
    
    func hideMessage() {
        messageLabel.isHidden = true
        networkImage.isHidden = true
        refreshButton.isHidden = true
    }
    
    private func startInternetReachability() {
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ViewController.reachabilityChanged(notification:)),
            name: .reachabilityChanged,
            object: reachability)
    }
    
    @objc func reachabilityChanged(notification: Notification) {
        reachability = notification.object as? Reachability
        switch reachability.connection {
        case .wifi, .cellular:
            hideNoNetworkPrompt(notification)
        case .none:
            showNoNetworkPrompt(notification)
        }
    }
    
    internal func showNoNetworkPrompt(_ notification: Notification!) {
        self.navigationItem.prompt = Constants.ErrorString.NoInternetConnection
    }
    
    internal func hideNoNetworkPrompt(_ notification: Notification!) {
        self.navigationItem.prompt = nil
    }
}
