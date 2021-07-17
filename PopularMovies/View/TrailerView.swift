//
//  TrailerView.swift
//  PopularMovies
//
//  Created by Raphael Cerqueira on 17/07/21.
//

import SwiftUI
import YouTubePlayer

struct TrailerView: View {
    @ObservedObject var viewModel: MovieViewModel
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        presentation.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .padding()
                            .background(Color.white.opacity(0.7))
                            .clipShape(Circle())
                            .foregroundColor(Color.primary)
                    })
                    
                    Spacer()
                }
                .padding()
                .padding(.top)
                
                YoutubeView(videoID: viewModel.video!.key)
                
                Spacer()
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

struct YoutubeView: UIViewRepresentable {
    typealias UIViewType = YouTubePlayerView
    
    var videoID: String
    
    func makeUIView(context: Context) -> YouTubePlayerView {
        let player = YouTubePlayerView()
        player.delegate = context.coordinator
        return player
    }
    
    func updateUIView(_ uiView: YouTubePlayerView, context: Context) {
        uiView.loadVideoID(videoID)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    // auto play
    class Coordinator: YouTubePlayerDelegate {
        func playerReady(_ videoPlayer: YouTubePlayerView) {
            videoPlayer.play()
        }
    }
}

struct TrailerView_Previews: PreviewProvider {
    static var previews: some View {
        TrailerView(viewModel: MovieViewModel())
    }
}
