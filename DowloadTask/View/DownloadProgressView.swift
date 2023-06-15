//
//  DownloadProgressView.swift
//  DowloadTask
//
//  Created by YILMAZ ER on 15.06.2023.
//

import SwiftUI

struct DownloadProgressView: View {
    
    @Binding var progress: CGFloat
    @EnvironmentObject var downloadModel: DownloadTaskModel
    
    var body: some View {
        ZStack {
            Color.primary
                .opacity(0.25)
                .ignoresSafeArea()
            
            VStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                    ProgressShape(progress: progress)
                        .fill(Color.gray.opacity(0.4))
                        .rotationEffect(.init(degrees: -90))
                }
                .frame(width: 70, height: 70)
                
                Button(action: downloadModel.cancelTask, label: {
                    Text("Cancel")
                        .fontWeight(.semibold)
                })
                .scenePadding(.top)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 50)
            .background(Color.white)
            .cornerRadius(8)
        }
    }
}

//#Preview {
//    DownloadProgressView(progress: .constant(0.5))
//}


struct ProgressShape: Shape {
    
    var progress: CGFloat
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: 35, startAngle: .zero, endAngle: .init(degrees: Double(progress * 360)), clockwise: false)
        }
    }
}
