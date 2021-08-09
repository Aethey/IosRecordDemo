//
//  IosRecordDemoApp.swift
//  IosRecordDemo
//
//  Created by Y Ryu on 2021/08/06.
//

import SwiftUI

@main
struct IosRecordDemoApp: App {
    var body: some Scene {
        WindowGroup {
            RecordView(audioRecorder: AudioRecorder.shared).environmentObject(RecordViewStore())
        }
    }
}
