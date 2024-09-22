import SwiftUI

struct AddProductView: View {
    @Binding var cartItems: [CartItem]
    @State private var showingImagePicker = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var viewModel = AddProductViewModel()

    var body: some View {
        VStack {
            Spacer()

            VStack {
                Spacer(minLength: 100)
                
                VStack {
                    HStack {
                        if let inputImage = viewModel.inputImage {
                            Image(uiImage: inputImage)
                                .resizable()
                                .frame(width: 150, height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            Text("Fotoğraf çekin")
                                .foregroundColor(.gray)
                                .frame(width: 150, height: 150)
                                .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }

                        Button(action: {
                            showingImagePicker = true
                        }) {
                            Text("Fotoğraf Çek")
                                .padding()
                                .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.blue)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .cornerRadius(8)
                        }
                        .sheet(isPresented: $showingImagePicker) {
                            ImagePicker(image: $viewModel.inputImage, sourceType: .camera)
                        }
                    }
                    .padding(.bottom, 20)

                    HStack {
                        Button(action: {
                            if viewModel.quantity > 1 {
                                viewModel.quantity -= 1
                            }
                        }) {
                            Image(systemName: "minus.circle")
                                .font(.largeTitle)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }

                        Text("\(viewModel.quantity)")
                            .font(.title)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .padding(.horizontal)

                        Button(action: {
                            viewModel.quantity += 1
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.largeTitle)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                    }
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity, alignment: .center)

                    VStack(alignment: .leading) {
                        Text("Birim Fiyatı Giriniz:")
                            .font(.headline)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .padding(.bottom, 5)

                        TextField("", text: $viewModel.unitPrice)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.1))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)

                    Button("Ekle") {
                        viewModel.addItem(to: &cartItems) 
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
                    .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.green)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .cornerRadius(8)
                }
                .padding()
                .background(colorScheme == .dark ? Color.black : Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .frame(maxWidth: 400)
                .animation(.easeInOut)
                
                Spacer()
            }
            .frame(maxHeight: .infinity)
            .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
        }
    }
}

struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView(cartItems: .constant([]))
            .preferredColorScheme(.dark)
    }
}
