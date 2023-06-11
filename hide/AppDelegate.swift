import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let desktopsURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        let screenshotsURL = desktopsURL.appendingPathComponent("Screenshots")

        let jpgFilesURLs = try! FileManager.default.contentsOfDirectory(at: screenshotsURL, includingPropertiesForKeys: [.contentModificationDateKey], options: .skipsHiddenFiles)
            .filter { $0.pathExtension == "png" }
            .sorted(by: { (url1, url2) -> Bool in
                let attributes1 = try! url1.resourceValues(forKeys: [.contentModificationDateKey])
                let attributes2 = try! url2.resourceValues(forKeys: [.contentModificationDateKey])
                return (attributes1.contentModificationDate ?? Date.distantPast) > (attributes2.contentModificationDate ?? Date.distantPast)
            })

        if let latestURL = jpgFilesURLs.first {
            let itemProvider = NSItemProvider(object: latestURL as NSItemProviderWriting)
            NSSharingService(named: .sendViaAirDrop)?.perform(withItems: [itemProvider])
        } else {
            print("No PNG files found in the 'Screenshots' folder.")
        }
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

