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
    
    @IBAction func clickedContactUs(_ sender: UIButton) {
    }
    
    @IBAction func clickedPrivacyPolicy(_ sender: UIButton) {
    }
    
    @IBAction func clickedRateUs(_ sender: UIButton) {
    }

    @IBAction func clickedDataReset(_ sender: UIButton) {
    }
}
