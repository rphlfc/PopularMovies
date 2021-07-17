//
//  DetailsView.swift
//  PopularMovies
//
//  Created by Raphael Cerqueira on 09/07/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailsView: View {
    var movie: Movie
    @ObservedObject var viewModel: MovieViewModel
    @Environment(\.presentationMode) var presentation
    @State var yOffset: CGFloat = 30
    @State var opacity: Double = 0
    @State var playTrailer: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                ZStack(alignment: .top) {
                    WebImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(movie.poster_path)"))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
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
                }
                
                Spacer()
            }
            
            VStack(spacing: 8) {
                HStack(alignment: .center, spacing: 8) {
                    Text(movie.title)
                        .font(.largeTitle)
                    
                    RatingView(rating: movie.vote_average)
                    
                    Spacer()
                }
                
                HStack(spacing: 8) {
                    ForEach(viewModel.movie?.genres ?? Array.init(repeating: Genre(id: 0, name: "Loading..."), count: 3)) { genre in
                        Text(genre.name)
                            .redacted(reason: viewModel.movie != nil ? .init() : .placeholder)
                        
                        if viewModel.movie?.genres?.last != genre {
                            Circle()
                                .frame(width: 6, height: 6)
                        }
                    }
                    
                    Spacer()
                }
                
                Text(movie.overview ?? "")
                
                if viewModel.video != nil {
                    Button(action: {
                        playTrailer.toggle()
                    }, label: {
                        HStack {
                            Image(systemName: "play.fill")
                            
                            Text("Play Trailer")
                        }
                        .foregroundColor(Color.primary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.primary, lineWidth: 1))
                        .padding(.top)
                    })
                    .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                }
                
            }
            .padding()
            .background(RoundedCorners(corners: [.topLeft, .topRight], radius: 30).fill(Color.white).shadow(radius: 5))
            .offset(y: yOffset)
            .opacity(opacity)
            .animation(.spring())
            .onAppear {
                DispatchQueue.main.async {
                    withAnimation {
                        yOffset = 0
                        opacity = 1
                    }
                }
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .ignoresSafeArea(.all, edges: .all)
        .onAppear {
            viewModel.fetchMovie(movie: movie)
            viewModel.fetchTrailer(movie: movie)
        }
        
        NavigationLink(
            destination: TrailerView(viewModel: viewModel),
            isActive: $playTrailer,
            label: {})
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(movie: Movie(id: 508943, title: "Luca", overview: "Luca and his best friend Alberto experience an unforgettable summer on the Italian Riviera. But all the fun is threatened by a deeply-held secret: they are sea monsters from another world just below the waters surface.", poster_path: "/jTswp6KyDYKtvC52GbHagrZbGvD.jpg", vote_average: 0.3, genres: nil), viewModel: MovieViewModel())
    }
}
