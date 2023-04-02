//
//  ReportView.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/28.
//

import SwiftUI
import OpenAISwift

struct ReportView: View {
    @State private var isLoading: Bool = true
    @State private var reportReceived: String?
    @State private var isAnimating = false
    // pass in
    var userConversations: [String] = []
    var client = APICaller().getClient()
    @State var jumpToMain = false
    
    var body: some View {
        
            HStack {
                Button {
                    jumpToMain = true
                    print("jumpToMain:\(jumpToMain)")
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 20, weight: .bold))
                }
                Spacer()
            }.padding([.horizontal], 15)
            
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
                    }.onAppear {
                            getReport()
                            //                        simulateReport()
                        }
                } else {
                    if let reportReceived = reportReceived {
                        ScrollView {
                            VStack{
                                Text(reportReceived)
//                                    .font(.custom("HelveticaNeue", size: 18))
//                                    .fontWeight(.semibold)
//                                    .foregroundColor(.black)
                            }
                            .padding(.horizontal, 30)
                        }
                        

                        
                    } else {
                        VStack {
                            Text("Error: No report response")
                        }
                        
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fullScreenCover(isPresented: $jumpToMain) {
            TeacherListView()
        }


    }
    
    private func simulateReport() {
        // Simulate a delay to show the waiting animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // Simulate receiving a report response
            reportReceived = "Report received"
            isLoading = false
        }
    }
    
    private func convertUserMsg() -> String {
        var res = "Here is a conversation from the student:\n"
        for userMsg in userConversations {
            res += "Student" + userMsg + "\n"
        }
        return res
    }
    
    
    private func getReport() {

        let promptMsg = ChatMessage(role: .system, content: reportPrompt)
        let userMsg = ChatMessage(role: .user, content: convertUserMsg())
        print("79: \([promptMsg, userMsg])")
        getGPTChatResponse(client: client, input: [promptMsg, userMsg]) { result in
            reportReceived = result
            isLoading = false
            print("reportReceived: \(reportReceived)")
        }
    }
}




struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
