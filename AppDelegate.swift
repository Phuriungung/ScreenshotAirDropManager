import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let desktopsURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        let screenshotsURL = desktopsURL.appendingPathComponent("Screenshots")

        let jpgFilesURLs = try! FileManager.default.contentsOfDirectory(at: screenshotsURL, includingPropertiesForKeys: nil)
            .filter { $0.pathExtension == "png" }

        var urlArray = [URL]()
        jpgFilesURLs.forEach { url in
            urlArray.append(url)
        }

//        // Print the URLs
//        urlArray.forEach {
//            print($0.path)
//        }

        var multipleItemProvider = [NSItemProvider]()

        for u in urlArray {
            guard let pathTurnIntoImage = NSImage(contentsOf: URL(filePath: u.path)) else {
                print("Failed to turn path to image")
                return
            }
            let eachItemProvider = NSItemProvider(object: pathTurnIntoImage)
            multipleItemProvider.append(eachItemProvider)
        }

        NSSharingService(named: .sendViaAirDrop)?.perform(withItems: multipleItemProvider)
        
        let delayInSeconds = 60.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
            NSApp.terminate(nil)
        }
    }
    func applicationWillTerminate(_ aNotification: Notification) {
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    


}

