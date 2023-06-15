//
//  DowloadTaskApp.swift
//  DowloadTask
//
//  Created by YILMAZ ER on 15.06.2023.
//

import SwiftUI

@main
struct DowloadTaskApp: App {
    
    @StateObject var downloadTaskVM = DownloadTaskModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(downloadTaskVM)
        }
    }
}
