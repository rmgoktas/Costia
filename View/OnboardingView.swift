import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var showWelcome = true
    @State private var currentStep = 0

    var body: some View {
        VStack {
            if showWelcome {
                Text("Hoş geldiniz !")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.easeInOut(duration: 1)) {
                                showWelcome = false
                            }
                        }
                    }
            } else {
                VStack {
                    Text("Costia")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    
                    Text("👋")
                        .font(.system(size: 80))
                        .padding(.top, 20)
                }
                .transition(.move(edge: .top))
                .animation(.easeInOut(duration: 1.0), value: currentStep)

                Spacer()

                if currentStep == 0 {
                    Text("Ürünü tarayın ve fiyatları karşılaştırın. 🔍")
                        .font(.title)
                        .padding(.top, 50)
                        .transition(.slide)
                        .animation(.easeInOut(duration: 1.0), value: currentStep)
                } else if currentStep == 1 {
                    Text("Öderken sürpriz yaşamayın. 🛒")
                        .font(.title)
                        .padding(.top, 50)
                        .transition(.slide)
                        .animation(.easeInOut(duration: 1.0), value: currentStep)
                } else if currentStep == 2 {
                    Text("Bütçenizi Costia ile planlayın. 🚀")
                        .font(.title)
                        .padding(.top, 50)
                        .transition(.slide)
                        .animation(.easeInOut(duration: 1.0), value: currentStep)
                }

                Spacer()

                Button(action: {
                    withAnimation {
                        if currentStep < 2 {
                            currentStep += 1
                        } else {
                            // Onboarding tamamlandı, ana ekrana geçiş
                            hasSeenOnboarding = true
                        }
                    }
                }) {
                    Text(currentStep < 2 ? "Sonraki" : "Hemen başla !")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .padding()
    }
}

#Preview {
    OnboardingView(hasSeenOnboarding: .constant(false))
}




