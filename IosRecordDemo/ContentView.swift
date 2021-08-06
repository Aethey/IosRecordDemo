//
//  ContentView.swift
//  IosRecordDemo
//
//  Created by Y Ryu on 2021/08/06.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
            LandmarkList()
            HStack {
                Text("this is a cell").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Text("this is a cell").font(.title)
                Text("this is a cell").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            }
            Spacer()
            Button(action: {
                print("you click")
            }, label: {
                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
            }
            )
            HStack {
                Text("this is a under cell").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        //        LandmarkList()
    }
}

struct LandmarkList : View {
    var body: some View {
        //自定义显示的内容
        List(0 ..< 5) { item in
            Text("hello")
                .font(.title)
        }
    }
}

struct NewView : View {
    var body: some View {
        List(0 ..< 5){ item in
            Text("hello")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
        }
    }
}

