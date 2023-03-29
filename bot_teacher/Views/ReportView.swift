//
//  ReportView.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/28.
//

import SwiftUI

struct ReportView: View {
    @State private var isLoading: Bool = true
    @State private var reportResponse: String?
    
    var body: some View {
        if isLoading {
            WaitingView()
                .onAppear {
                    simulateReport()
                }
        } else {
            if let reportResponse = reportResponse {
                Text(reportResponse)
            } else {
                Text("Error: No report response")
            }
        }
    }
    
    private func simulateReport() {
        // Simulate a delay to show the waiting animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Simulate receiving a report response
            reportResponse = "Report received"
            isLoading = false
        }
    }
}

struct WaitingView: View {
    @State private var isAnimating: Bool = false
    
    var body: some View {
        VStack {
            Text("Waiting for report...")
                .font(.headline)
                .foregroundColor(.gray)
            Circle()
                .stroke(lineWidth: 4)
                .scaleEffect(isAnimating ? 1.0 : 0.9)
                .animation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true))
                .onAppear {
                    isAnimating = true
                }
                .onDisappear {
                    isAnimating = false
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
