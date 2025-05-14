//
//  SettingsViewController.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 31.10.24.
//
import UserNotifications
import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var interfaceModeSwitch: BaseSwitch!
    @IBOutlet weak var notificationSwitch: BaseSwitch!
    @IBOutlet var settingsButton: [UIButton]!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interfaceModeSwitch.isOn = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
        notificationSwitch.isOn = NotificationManager.shared.isNotificationEnabled()
    }
    
    func setupUI() {
        titleLabels.forEach({ $0.font = .light(size: 22) })
        settingsButton.forEach({ $0.titleLabel?.font = .light(size: 20) })
        resetButton.titleLabel?.font = .light(size: 12)
        interfaceModeSwitch.layer.cornerRadius = interfaceModeSwitch.frame.height / 2
        notificationSwitch.layer.cornerRadius = interfaceModeSwitch.frame.height / 2
    }
    
    @IBAction func chooseInterfaceMode(_ sender: BaseSwitch) {
        sender.isOn = sender.isOn
        let interfaceMode = sender.isOn ? UIUserInterfaceStyle.dark : .light
        UserDefaults.standard.set(sender.isOn, forKey: "isDarkModeEnabled")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            for window in windowScene.windows {
                window.overrideUserInterfaceStyle = interfaceMode
            }
        }
    }

    @IBAction func chooseNotifications(_ sender: BaseSwitch) {
        if sender.isOn {
            NotificationManager.shared.requestNotificationPermission(completion: { granted in
                sender.isOn = granted
                sender.setOn(granted, animated: true)
                UserDefaults.standard.set(sender.isOn, forKey: "isNotificationsEnabled")
            })
        } else {
            print("Notifications disabled")
            sender.isOn = false
            UserDefaults.standard.set(sender.isOn, forKey: "isNotificationsEnabled")
        }
    }

    @IBAction func clickedDataReset(_ sender: UIButton) {
        CoreDataManager.shared.resetData { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                UserDefaults.standard.set(false, forKey: "hasLaunchedBefore")
                let rootViewController = UIStoryboard(name: "Root", bundle: .main).instantiateViewController(withIdentifier: "RootViewController")
                let navigationController = UINavigationController(rootViewController: rootViewController)
                self.changeRootViewController(to: navigationController)
            }
        }
    }
    
    @IBAction func clickedContactUs(_ sender: UIButton) {
//        if MFMailComposeViewController.canSendMail() {
//            let mailComposeVC = MFMailComposeViewController()
//            mailComposeVC.mailComposeDelegate = self
//            mailComposeVC.setToRecipients(["alina.sverlova6@icloud.com"])
//            present(mailComposeVC, animated: true, completion: nil)
//        } else {
//            let alert = UIAlertController(
//                title: "Mail Not Available",
//                message: "Please configure a Mail account in your settings.",
//                preferredStyle: .alert
//            )
//            alert.addAction(UIAlertAction(title: "OK", style: .default))
//            present(alert, animated: true)
//        }
    }
//
    @IBAction func clickedPrivacyPolicy(_ sender: UIButton) {
//        let privacyVC = PrivacyViewController()
//        privacyVC.url = URL(string: "https://docs.google.com/document/d/1p_yBtClAhyrHDqzp_F3CzFggKrz-a5PItc2JKsjXrhU/mobilebasic")
//        self.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(privacyVC, animated: true)
//        self.hidesBottomBarWhenPushed = false
    }
//
    @IBAction func clickedRateUs(_ sender: UIButton) {
//        let appID = "6742742223"
//        if let url = URL(string: "https://apps.apple.com/app/id\(appID)?action=write-review") {
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                print("Unable to open App Store URL")
//            }
//        }
    }
}

//
//extension SettingsViewController: MFMailComposeViewControllerDelegate {
//    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true, completion: nil)
//    }
//}


