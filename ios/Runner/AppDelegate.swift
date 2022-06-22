import UIKit
import Flutter
import CoreMotion
import AuthenticationServices
import EventKit
import AVKit
import AVFoundation

@available(iOS 11.0, *)
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    var channelSensor: FlutterMethodChannel!
    let motion = CMMotionManager()
    var timer: Timer!
    let measureLevel = 50.0

    var appleSignResult: FlutterResult?
    var calendarResult: FlutterResult?
    var videoResult: FlutterResult?

    var navigationController: UINavigationController?
    let playerViewController = AVPlayerViewController()

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        startAccelerometers()
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

        channelSensor = FlutterMethodChannel(name: "com.kanga.measurement/sensor",  binaryMessenger: controller.binaryMessenger)

        let channelSift = FlutterMethodChannel(name: "com.kanga.measurement/apple_sign",  binaryMessenger: controller.binaryMessenger)
        channelSift.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if (call.method == "init") {
                self.appleSignResult = result
                self.handleAppleIdRequest()
            } else {
                result(FlutterMethodNotImplemented)
            }
        })

        let channelCalendar = FlutterMethodChannel(name: "com.kanga.measurement/calendar",  binaryMessenger: controller.binaryMessenger)
        channelCalendar.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if (call.method == "add") {
                self.calendarResult = result

                let params = call.arguments as! [String]
                self.initCalendar(title: params[0], desc: params[1], startDate: params[2])
            } else {
                result(FlutterMethodNotImplemented)
            }
        })

        let channelLoadVideo = FlutterMethodChannel(name: "com.kanga.measurement/loadVideo",  binaryMessenger: controller.binaryMessenger)
        channelLoadVideo.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if (call.method == "play") {
                self.videoResult = result

                let params = call.arguments as! [String]
                self.videoPlay(videoUrl: params[0])
            } else {
                result(FlutterMethodNotImplemented)
            }
        })

        GeneratedPluginRegistrant.register(with: self)

        UNUserNotificationCenter.current().delegate = self

        application.applicationIconBadgeNumber = 0

        navigationController = UINavigationController(rootViewController: controller)
        navigationController!.isNavigationBarHidden = true
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func initCalendar(title: String, desc: String, startDate: String) {
        let eventStore = EKEventStore()
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            self.insertEvent(store: eventStore, title: title, desc: desc, startDateStr: startDate)
        case .denied:
            self.calendarResult!("Access Denied")
        case .notDetermined:
            // 3
            eventStore.requestAccess(to: .event, completion:
                                        {[weak self] (granted: Bool, error: Error?) -> Void in
                                            if granted {
                                                self!.insertEvent(store: eventStore, title: title, desc: desc, startDateStr: startDate)
                                            } else {
                                                self!.calendarResult!("Access Denied")
                                            }
                                        })
        default:
            self.calendarResult!("Access Denied")
        }
    }

    func insertEvent(store: EKEventStore, title: String, desc: String, startDateStr: String) {
        let event:EKEvent = EKEvent(eventStore: store)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let startDate = dateFormatter.date(from: startDateStr)
        let endDate = startDate!.addingTimeInterval(1 * 60 * 60)

        let calendars = store.calendars(for: .event)
        let _preEvents = store.events(matching: store.predicateForEvents(withStart: startDate!, end: endDate, calendars: calendars))
        if (!_preEvents.isEmpty) {
            self.calendarResult!("Already added")
            return;
        }

        event.title = title
        event.notes = desc

        event.startDate = startDate
        event.endDate = endDate

        event.calendar = store.defaultCalendarForNewEvents

        let alarmDate = startDate!.addingTimeInterval(-30 * 60)
        event.alarms = [EKAlarm.init(absoluteDate: alarmDate)]
        do {
            try store.save(event, span: .thisEvent)
            self.calendarResult!("Success")
        } catch let error as NSError {
            print("failed to save event with error : \(error)")
            self.calendarResult!(error.description)
        }
    }

    func startAccelerometers() {
        // Make sure the accelerometer hardware is available.
        if self.motion.isAccelerometerAvailable {
            self.motion.accelerometerUpdateInterval = 1.0 / measureLevel
            self.motion.startAccelerometerUpdates()

            // Configure a timer to fetch the data.
            self.timer = Timer(fire: Date(), interval: (1.0 / measureLevel),
                               repeats: true, block: { (timer) in
                                // Get the accelerometer data.
                                if let data = self.motion.accelerometerData {
                                    let x = data.acceleration.x * 9.8
                                    let y = data.acceleration.y * 9.8
                                    let z = data.acceleration.z * 9.8

                                    // Use the accelerometer data in your app.
                                    let messageDictionary = [
                                        "accelerometer" : [x, y, z]
                                    ]
                                    let jsonData = try! JSONSerialization.data(withJSONObject: messageDictionary, options: [])
                                    let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)!

                                    self.channelSensor.invokeMethod("onChanged", arguments: jsonString)
                                }
                               })

            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer!, forMode: .default)
        }
    }

    func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }

    func videoPlay(videoUrl: String) {
        let videoURL = NSURL(string: videoUrl)
        let player = AVPlayer(url: videoURL! as URL)
        self.playerViewController.player = player
        self.playerViewController.delegate = self
        self.navigationController?.present(self.playerViewController, animated: true) {
            self.playerViewController.player!.play()
        }

        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }

    @objc func playerDidFinishPlaying(note: NSNotification){
        print("Video Finished")
        self.playerViewController.dismiss(animated: false, completion: nil)
        self.videoResult!("Finished")
    }
}

extension AppDelegate: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            appleSignResult!(appleIDCredential.identityToken)
        } else {
            appleSignResult!("Not found any auth")
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    }
}

extension AppDelegate: AVPlayerViewControllerDelegate {
    func playerViewController(_ playerViewController: AVPlayerViewController, willEndFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        print("Video Cancelled")
        self.videoResult!("Cancelled")
    }
}
