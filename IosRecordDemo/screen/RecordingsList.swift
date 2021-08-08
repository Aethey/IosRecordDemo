//
//  RecordingsList.swift
//  IosRecordDemo
//
//  Created by Y Ryu on 2021/08/06.
//

import SwiftUI

struct RecordingsList: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    
    var body: some View {
        List {
            ForEach(audioRecorder.recordings, id: \.createdAt) { recording in
                RecordingRow(audioURL: recording.fileURL)
            }.buttonStyle(BorderlessButtonStyle())
        }
    }
}

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsList(audioRecorder: AudioRecorder())
    }
}

struct RecordingRow: View {
    
    var audioURL: URL
    
    @ObservedObject var audioPlayer = AudioPlayer()
    @State var alertShouldBeShown = false
    @State private var alertJson = ""
    
    @ObservedObject var model = TestApiManager()
    
    var body: some View {
        HStack {
            Text("\(audioURL.lastPathComponent)")
            Spacer()
            if audioPlayer.isPlaying == false {
                Button(action: {
                    self.audioPlayer.startPlayback(audio: self.audioURL)
                }) {
                    Image(systemName: "play.circle")
                        .imageScale(.large)
                        .foregroundColor(.black)
                }
            } else {
                Button(action: {
                    self.audioPlayer.stopPlayback()
                }) {
                    Image(systemName: "stop.fill")
                        .imageScale(.large)
                        .foregroundColor(.black)
                }
            }
            Spacer()
            Button(action: {
                model.postRequest{ data in
                    alertJson = data
                    alertShouldBeShown = true
                }
                
            })
            {
                Image(systemName: "arrow.up.square.fill")
                    .imageScale(.large)
                    .foregroundColor(.black)
            }
        }.alert(isPresented: $alertShouldBeShown, content: {
            
            Alert(title: Text("アップロード成功:"),
                  message: Text(alertJson),
                  dismissButton: Alert.Button.default(
                    Text("OK"), action: {
                        
                        
                    }
                  )
            )
        }
        )
    }
    
}
