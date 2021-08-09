//
//  LoadingView.swift
//  IosRecordDemo
//
//  Created by Y Ryu on 2021/08/09.
//

import Foundation
import SwiftUI

struct LoadingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {

                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    Text("Loading...")
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)

            }
        }
    }

}


struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}


struct LoadingIndicatorView: View {
    let isLoading: Bool
    @State private var isAnimating = false
    private let animation = Animation.linear(duration: 1).repeatForever(autoreverses: false)

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // ①Loading中に画面をタップできないようにするためのほぼ透明なLayer
                Color(.black)
                    .opacity(0.01)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .edgesIgnoringSafeArea(.all)
                    .disabled(self.isLoading)
                Circle()
                    .trim(from: 0, to: 0.6)
                    .stroke(AngularGradient(gradient: Gradient(colors: [.gray, .white]), center: .center),
                            style: StrokeStyle(
                                lineWidth: 8,
                                lineCap: .round,
                                dash: [0.1, 16],
                                dashPhase: 8))
                    .frame(width: 48, height: 48)
                    .rotationEffect(.degrees(self.isAnimating ? 360 : 0))
                    // ②アニメーションの実装
                    .onAppear() {
                        withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                            self.isAnimating = true
                        }
                    }
                    .onDisappear() {
                        self.isAnimating = false
                    }
            }
             // ③Loading中だけLoading画面が表示されるようにする。
            .hidden()
        }
    }
}
