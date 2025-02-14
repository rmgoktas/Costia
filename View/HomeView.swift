import SwiftUI
import MapKit

struct HomeView: View {
    @StateObject private var locationManager = LocationManager()
    @Binding var selectedTab: Int
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            HStack {
                Text("Costia")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                Spacer()
            }
            .padding(.top, 40)
            .padding(.horizontal)
            
            Spacer()

            Button(action: {
                selectedTab = 1
            }) {
                HStack {
                    Image(systemName: "magnifyingglass")
                    Text("Ürün Tara")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .frame(width: 250, height: 60)
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10]))
                        .foregroundColor(.white)
                )
            }
            .padding(.bottom, 90)

            VStack(alignment: .leading, spacing: 10) {
                Text("En Yakın Marketler")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .padding(.leading, 20)
                    .padding(.bottom, 10)

                Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
                    .frame(height: 300)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)

            Spacer()
        }
        .background(colorScheme == .dark ? Color(UIColor.systemGray6) : Color.white)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(selectedTab: .constant(0))
            .preferredColorScheme(.dark)
    }
}
