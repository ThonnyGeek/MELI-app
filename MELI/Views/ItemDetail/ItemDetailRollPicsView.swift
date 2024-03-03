//
//  ItemDetailRollPicsView.swift
//  MELI
//
//  Created by Thony Gonzalez on 2/03/24.
//

import SwiftUI

struct ItemDetailRollPicsView: View {
    
    let pictures: [Picture]
    @State var selectedPhoto: String = ""
    
    var backButtonAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.8)
                .ignoresSafeArea()
            
            VStack (spacing: 0) {
                Rectangle()
                    .fill(.clear)
                    .frame(width: 30, height: 30)
                
                TabView {
                    ForEach(pictures, id: \.self) { photo in
                        DownloadingImageView(url: photo.secureURL ?? "", key: photo.id ?? "")
                            .scaledToFit()
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            }
            
            Button {
                withAnimation {
                    backButtonAction()
                }
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                
                    .shadow(color: .black, radius: 3)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
    
    private var errorPic: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
            .overlay {
                Image(systemName: "line.diagonal")
                    .resizable()
                    .padding(5)
                    .scaledToFit()

            }
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity)
    }
}

struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview {
    ItemDetailRollPicsView(pictures: [
        Picture(id: "2", url: "", secureURL: "https://http2.mlstatic.com/D_631993-MLA46153270440_052021-O.jpg", size: "", maxSize: "", quality: ""),
        Picture(id: "1", url: "", secureURL: "https://http2.mlstatic.com/D_904849-MLA46153369025_052021-O.jpg", size: "", maxSize: "", quality: ""),
        Picture(id: "3", url: "", secureURL: "https://http2.mlstatic.com/D_851350-MLA46153270441_052021-O.jpg", size: "", maxSize: "", quality: "")
    ]) {
        //
    }
}
