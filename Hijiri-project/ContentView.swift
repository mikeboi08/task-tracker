//
//  ContentView.swift
//  Hijiri-project
//
//  Created by Micah Howard on 11/13/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showButtonStatus  = false
   
    
    let lightOn = Circle().fill(.red) //Image("diodeFlashing")
    let lightOff = Circle().fill(.gray) //Image("diode")
    @State private var lightIsON = true
    
    @State var counter = 0
    @State var lightbool1 = false
   
   // let timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true)
    
    let timer1 = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    //let timer2 = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    // i love coding
    var body: some View {
        
        ZStack{
            Color(.white)
            VStack{
                Spacer()
                Text("Tasks").bold()
                HStack {
                    Toggle(isOn: $showButtonStatus){
//                        Text("Toggle")
                    }
                    .padding()
                    // if lightIsOn, show lightOn, else show lightOff
                    
                    
                    if showButtonStatus == true && lightbool1 == true && counter > 1 {
                        lightOn
                            //.resizable()
                            .aspectRatio(contentMode: .fit)
                    }else {lightOff
                        //.resizable()
                        .aspectRatio(contentMode: .fit)}
                    
                    
                    if showButtonStatus == true && lightbool1 == true && counter > 2 {
                        lightOn
                           // .resizable()
                            .aspectRatio(contentMode: .fit)
                    }else {lightOff
                        //.resizable()
                        .aspectRatio(contentMode: .fit)}
                    if showButtonStatus == true && lightbool1 == true && counter > 3{
                        lightOn
                           // .resizable()
                            .aspectRatio(contentMode: .fit)
                    }else {lightOff
                        //.resizable()
                        .aspectRatio(contentMode: .fit)}
                    
                    if showButtonStatus == true && lightbool1 == true && counter > 4{
                        lightOn
                           // .resizable()
                            .aspectRatio(contentMode: .fit)
                    }else {lightOff
                        //.resizable()
                        .aspectRatio(contentMode: .fit)}
                    if showButtonStatus == true && lightbool1 == true && counter > 5{
                        lightOn
                            //.resizable()
                            .aspectRatio(contentMode: .fit)
                    }else {lightOff
                        //.resizable()
                        .aspectRatio(contentMode: .fit)}
                    
                   
                   
                }
                
                Button(action: {
                    if counter < 6 {
                        counter+=1
                    } else{counter = 0}
                }, label: {
                    Image("button")
                })
                if showButtonStatus == true && lightbool1 == true && counter > 0{
                    lightOn
                        //.resizable()
                        .frame(width: 50, height: 70, alignment:.center)
                }else {lightOff
                    //.resizable()
                    .frame(width: 50, height: 70, alignment:.center)}
                   
                Spacer()
            }
            .onReceive(timer1, perform: { index in
                lightbool1.toggle()
            })
            
//            .onReceive(timer2, perform: { _ in
//                showButtonStatus2.toggle()
//            })
            
            
        }
    }
}
    #Preview {
        ContentView()
    }

