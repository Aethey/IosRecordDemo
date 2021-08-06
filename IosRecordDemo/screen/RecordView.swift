//
//  RecordView.swift
//  IosRecordDemo
//
//  Created by Y Ryu on 2021/08/06.
//

import Foundation
import SwiftUI

struct RecordView: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    
    var body: some View {
        
        VStack {
            
            RecordingsList(audioRecorder: audioRecorder)
            
            if audioRecorder.recording == false {
                Button(
                    action: {
                        self.audioRecorder.startRecording()
                        print("Start recording)")
                    })
                {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
                        .foregroundColor(.red)
                        .padding(.bottom, 40)
                }
            } else {
                Button(
                    action: {
                        self.audioRecorder.stopRecording()
                        print("Stop recording)")
                        
                    })
                {
                    Image(systemName: "stop.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
                        .foregroundColor(.red)
                        .padding(.bottom, 40)
                }
            }
         }
    }
}

struct RecordView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        RecordView(audioRecorder: AudioRecorder())
    }
}
