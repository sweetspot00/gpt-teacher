//
// LoginView.swift
// Favourites
//
// Created by Peter Friese on 08.07.2022
// Copyright © 2022 Google LLC.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
import SwiftUI
import Combine
import FirebaseAnalyticsSwift
import _AuthenticationServices_SwiftUI

private enum FocusableField: Hashable {
  case email
  case password
}

struct LoginView: View {
  @EnvironmentObject var viewModel: AuthenticationViewModel
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.dismiss) var dismiss

  @FocusState private var focus: FocusableField?

  private func signInWithEmailPassword() {
    Task {
      if await viewModel.signInWithEmailPassword() == true {
        dismiss()
      }
    }
  }

  private func signInWithGoogle() {
    Task {
      if await viewModel.signInWithGoogle() == true {
        dismiss()
      }
    }
  }

  var body: some View {
    VStack {

        ZStack{
            Image("login")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.top)
                    .scaleEffect(0.86)
                    
                    .overlay(
                        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.0), Color.white.opacity(0.9)]),
                                       startPoint: .top,
                                       endPoint: .bottom)
                    )
                    .edgesIgnoringSafeArea(.top)
                    .offset(x: -10, y: -80)
                    
            

                 VStack(alignment: .leading) {
                     // push to bottom
                     Spacer()
                     VStack {
                         Text("Chat with the AI doubles of your fav characters. Examples :")
                             .font(.title2)
                             .bold()
                             .multilineTextAlignment(.leading)

    //                     Spacer()
                     }

                     VStack(alignment: .leading) {
                         HStack {
                             Image("yes")
                                 .resizable()
                                 .frame(width: 28, height: 28)
                                 .padding(.horizontal, 5)
                             Text("Practice your language speaking skill")
                                 .font(.custom("Inter-Regular", size: 18))
                                 .foregroundColor(Color.black)
                                 .multilineTextAlignment(.leading)
                                 .background(Color.white)
                         }
                         HStack {
                             Image("yes")
                                 .resizable()
                                 .frame(width: 28, height: 28)
                                 .padding(.horizontal, 5)
                             Text("Ask for insights and ideas")
                                 .font(.custom("Inter-Regular", size: 18))
                                 .foregroundColor(Color.black)
                                 .multilineTextAlignment(.leading)
                                 .background(Color.white)
//                             Spacer()
                             
                         }
                         HStack {
                             Image("yes")
                                 .resizable()
                                 .frame(width: 28, height: 28)
                                 .padding(.horizontal, 5)
                             Text("Chat about your life to relieve stress")
                                 .font(.custom("Inter-Regular", size: 18))
                                 .foregroundColor(Color.black)
                                 .multilineTextAlignment(.leading)
                                 .background(Color.white)
//                             Spacer()
                         }
                     }
                 }
        }.padding()
    



        VStack {
            SignInWithAppleButton { request in
                viewModel.handleSignInWithAppleRequest(request)
            } onCompletion: { result in
                viewModel.handleSignInWithAppleCompletion(result)
            }
            .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .cornerRadius(8)
            .padding(.horizontal)
            
          Button(action: signInWithGoogle) {
              HStack(spacing: 5) {
                  Image("Google")
                        .resizable().scaledToFit()
                    .frame(width: 20, height: 20)
                  
                  Text("Sign in with Google")
                      .foregroundColor(.white)
                      .bold()
                      .font(.system(size: 16))
                      .font(.subheadline)
              }
              .frame(width: UIScreen.main.bounds.size.width - 30 , height: 44)
              .background(colorScheme == .light ? .black : .white)
              .cornerRadius(8)
              .foregroundColor(colorScheme == .dark ? .white : .black)
          }


        }

    }
    .listStyle(.plain)
//    .padding()
    .analyticsScreen(name: "\(Self.self)")
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      LoginView()
      LoginView()
        .preferredColorScheme(.dark)
    }
    .environmentObject(AuthenticationViewModel())
  }
}
