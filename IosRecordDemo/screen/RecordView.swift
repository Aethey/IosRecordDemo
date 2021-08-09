//
//  RecordView.swift
//  IosRecordDemo
//
//  Created by Y Ryu on 2021/08/06.
//

import Foundation
import SwiftUI

struct RecordView: View {
    
    @EnvironmentObject var recordViewStore: RecordViewStore
    
    @ObservedObject var audioRecorder: AudioRecorder
    
    var body: some View {
        
        ZStack {
            VStack {
                
                RecordingsList(audioRecorder: audioRecorder)
                
                if audioRecorder.recording == false {
                    Button(
                        action: {
                            self.audioRecorder.startRecording()
                            print("Start recording)")
                        })
                    {
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipped()
                            .foregroundColor(.black)
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
                            .foregroundColor(.black)
                            .padding(.bottom, 40)
                    }
                }

             }
            if self.recordViewStore.showLoaidng {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.black))
            }
        }
    }
}

class RecordViewStore: ObservableObject {
    
    @Published var showLoaidng = false
    
    func updateLoading() {
        self.showLoaidng.toggle()
    }
    
    
}


struct RecordView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        
        RecordView(audioRecorder: AudioRecorder()).environmentObject(RecordViewStore())
    }
}


