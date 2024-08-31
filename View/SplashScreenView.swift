import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        if isActive {
            if hasSeenOnboarding {
                HomeView()
            } else {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
            }
        } else {
            VStack {
                Image("logo") 
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .transition(.scale)
                    .animation(.easeInOut(duration: 1.0), value: isActive)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation {
                                isActive = true
                            }
                        }
                    }
            }
        }
    }
}




