//
//  ReportView.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/28.
//

import SwiftUI

struct ReportView: View {
    @State private var isLoading: Bool = true
    @State private var reportReceived: String?
    // pass in
    var userConversations: [String] = []
    var client = APICaller().getClient()
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("ailinPink"))
                    .frame(height: 80)
                    .padding(.horizontal, 30)
                
                    
                Text("Ailin Assessment")
                    .font(.largeTitle)
                    .foregroundColor(.white)// Increase the top padding to make sure the view is visible
            }.padding(.top, 30)
            
            if isLoading {
                WaitingView()
                    .onAppear {
                        simulateReport()
                    }
            } else {
                if let reportReceived = reportReceived {
                    
                    VStack{
                        Text(reportReceived)
                    }
                    
                    
                } else {
                    VStack {
                        Text("Error: No report response")
                    }
                    
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func simulateReport() {
        // Simulate a delay to show the waiting animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // Simulate receiving a report response
            reportReceived = "Report received"
            isLoading = false
        }
    }
    
    private func getReport() {

//        getGPTChatResponse(client: client, input: <#T##[ChatMessage]#>) { result in
//            <#code#>
//        }
    }
}


struct WaitingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
//            ZStack {
//                RoundedRectangle(cornerRadius: 10)
//                    .fill(Color("ailinPink"))
//                    .frame(height: 80)
//                    .padding(.horizontal, 30)
//
//
//                Text("Ailin Assessment")
//                    .font(.largeTitle)
//                    .foregroundColor(.white)// Increase the top padding to make sure the view is visible
//            }
//            .padding(.top, 40)

            VStack {
                Text("Waiting for report...")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Circle()
                    .trim(from: 0.0, to: 0.7)
                    .stroke(Color.blue, lineWidth: 5)
                    .frame(width: 50, height: 50)
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                    .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false))
                    .onAppear {
                        isAnimating = true
                    }
            }
            

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.9)) // Use a lower opacity to make the background more transparent
    }
}


struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
