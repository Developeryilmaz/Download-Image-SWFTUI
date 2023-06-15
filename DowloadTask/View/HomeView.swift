//
//  HomeView.swift
//  DowloadTask
//
//  Created by YILMAZ ER on 15.06.2023.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var downloadModel = DownloadTaskModel()
    @State var urlText = ""
    private let url = "https://file-examples.com/storage/fefb234bc0648a3e7a1a47d/2017/04/file_example_MP4_1920_18MG.mp4"
    private let url2 = "https://azdlapi.markizapp.com/media/questions/showpic_bcAEyf6.jpeg"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                
                if downloadModel.imgURL != nil {
                    AsyncImage(url: downloadModel.imgURL)
                } else {
                    AsyncImage(url: URL(string: "https://azdlapi.markizapp.com/media/default/default.jpg")) { image in
                        image.image?.resizable()
                    }
                        .frame(width: 100, height: 100)
                }
                
              
                TextField("URL", text: $urlText)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(.white)
                    .cornerRadius(3.0)
                    .shadow(color: Color.black.opacity(0.06), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.06), radius: 5, x: -5, y: -5)
                
                Button(action: {downloadModel.startDownload(urlString: urlText)}, label: {
                    Text("Download URL")
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                })
                .padding(.top)
            }
            .padding()
            // NavigationTitle Bar Title
            .navigationTitle("Downloand Title")
        }
        .preferredColorScheme(.light)
        .alert(isPresented: $downloadModel.showAlert, content: {
            Alert(title: Text("Message"), message: Text(downloadModel.alertMsg), dismissButton: .destructive(Text("Ok"), action: {
                downloadModel.startDownload(urlString: urlText)
            }))
        })
        .overlay (
            ZStack {
                if downloadModel.showDownloadProgress {
                    DownloadProgressView(progress: $downloadModel.downloadProgress)
                }
            }
        )
    }
}

#Preview {
    HomeView()
}
