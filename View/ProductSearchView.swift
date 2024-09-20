import SwiftUI
import WebKit

struct ProductSearchView: View {
    
    @State private var searchText: String
    @Environment(\.presentationMode) var presentationMode
    @State private var isLoading: Bool = true
    @State private var loadError: Bool = false
    @State private var showLoadingScreen: Bool = true
    @State private var showAlternateText: Bool = false
    
    init(searchText: String) {
        self._searchText = State(initialValue: searchText)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if showLoadingScreen {
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(2)
                        if !showAlternateText {
                            Text("Sizin için en uygun fiyatları buluyoruz...")
                                .font(.headline)
                                .padding(.top, 40)
                                .transition(.opacity)
                                .animation(.easeInOut(duration: 2.0), value: showAlternateText)
                        }
                        if showAlternateText {
                            Text("En iyi fırsatları yakalayın!")
                                .font(.headline)
                                .padding(.top, 40)
                                .transition(.opacity)
                                .animation(.easeInOut(duration: 2.0), value: showAlternateText)
                        }
                        Text("Lütfen bekleyin.")
                            .font(.subheadline)
                            .padding(.top, 10)
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 2.0).delay(1.0), value: showLoadingScreen)
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation {
                                showAlternateText = true
                            }
                        }
                        // 5 saniye delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                            withAnimation {
                                showLoadingScreen = false
                            }
                        }
                    }
                } else {
                    VStack {
                        Spacer()
                            .frame(height: 100)
                        
                        if isLoading {
                            ProgressView("Sonuçlar yükleniyor...")
                                .padding()
                                .scaleEffect(1.2)
                        } else if loadError {
                            Text("Bir hata oluştu. Lütfen tekrar deneyin.")
                                .foregroundColor(.red)
                                .transition(.opacity)
                        } else {
                            WebView(url: URL(string: "https://www.google.com/search?tbm=shop&q=\(searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")!)
                                .frame(height: 750)
                                .transition(.slide)
                                .animation(.spring(), value: isLoading)
                        }
                        
                        Spacer()
                    }
                    .navigationTitle("En İyi Eşleşmeler")
                    .navigationBarItems(leading: Button(action: {
                        withAnimation {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Geri")
                        }
                        .foregroundColor(.blue)
                        .padding(.leading, 10)
                        .cornerRadius(8)
                        .shadow(radius: 5)
                    })
                    .onAppear {
                        if URL(string: "https://www.google.com/search?tbm=shop&q=\(searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") == nil {
                            loadError = true
                        }
                        isLoading = false
                    }
                }
            }
            .transition(.move(edge: .bottom))
            .animation(.spring(), value: isLoading)
        }
    }
}

struct ProductSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ProductSearchView(searchText: "beypazarı maden suyu")
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.light) //dark mod için
    }
}
