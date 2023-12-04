import SwiftUI

struct ContentView: View {
    @State private var showButtonStatus = false
    @State private var counter = 0
    @State private var lightState: [Bool] = [false, false, false, false, false]
    @State private var inProgressButtonState = false
    @State private var timers: [Timer?] = [nil, nil, nil, nil, nil]

    let timerInterval = 10.0
    let blinkInterval = 0.5
    let timer1 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color(.white)
            VStack {
                Spacer()

                Text("Tasks")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.blue)

                HStack(spacing: 20) {
                    VStack {
                        Text("Power")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.blue)
                        Toggle(isOn: Binding(
                            get: { self.showButtonStatus },
                            set: { newValue in
                                self.showButtonStatus = newValue
                                if newValue {
                                    self.resetLights()
                                }
                            }
                        )) {
                            EmptyView()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                    }
                    ForEach(0..<5, id: \.self) { index in
                        VStack {
                            Text("\(index + 1)")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.blue)
                            Circle()
                                .fill(lightState[index] && showButtonStatus ? Color.green : Color.gray)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .disabled(!showButtonStatus)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }

                HStack(spacing: 20) {
                    VStack {
                        Text("In Progress")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.blue)
                            .padding(.vertical, 4)

                        Circle()
                            .fill((lightState[0] || inProgressButtonState) && showButtonStatus ? Color.green : Color.gray)
                            .frame(width: 50, height: 70)
                            .disabled(!showButtonStatus)
                    }
                    .frame(maxWidth: .infinity)

                    VStack {
                        Text("Start Next Task")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.blue)
                            .padding(.top, 4)

                        Spacer()

                        Button(action: {
                            cycleLights()
                        }, label: {
                            Image("button")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        })
                        .padding(.bottom, 20)
                        .disabled(!showButtonStatus)
                    }
                    .frame(maxWidth: .infinity)
                }

                Spacer()
            }
        }
        .onReceive(timer1) { _ in
            if showButtonStatus {
                for i in 0..<lightState.count {
                    if lightState[i] {
                        if let timer = timers[i], timer.isValid {
                            // Do nothing, timer is still running
                        } else {
                            lightState[i] = false
                            timers[i] = nil
                        }
                    }
                }

                inProgressButtonState = counter > 0
            }
        }
    }

    func cycleLights() {
        counter += 1

        if counter > lightState.count {
            // Stop the cycling after button 5 blinks
            resetLights()
            return
        }

        for i in 0..<lightState.count {
            if let timer = timers[i], timer.isValid {
                // Stop the flashing for the current button
                timer.invalidate()
                timers[i] = nil
                lightState[i] = false
            }

            if counter - 1 == i {
                // Make the current button solid green
                lightState[i] = true

                // Schedule a timer to stop the flashing after 10 seconds
                timers[i] = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: false) { [self] _ in
                    lightState[i] = false
                    inProgressButtonState = counter > 0

                    // Start blinking the next light only if counter <= 5
                    if counter <= 5 {
                        let nextIndex = (i + 1) % lightState.count

                        // Check if it's the 1st button, and if so, set it to solid green immediately
                        if nextIndex != 0 {
                            startBlinking(index: nextIndex)
                        }
                    }
                }

                // If it's the 1st button, set it to solid green immediately
                if i == 0 {
                    lightState[i] = true
                }
            }
        }
    }

    // Function to start blinking for a given index
    private func startBlinking(index: Int) {
        if index == 4 {
            // Blink continuously for the 5th button until the green button is pressed
            timers[index] = Timer.scheduledTimer(withTimeInterval: blinkInterval, repeats: true) { [self] _ in
                lightState[index].toggle()
            }
        } else {
            // Blink other buttons
            timers[index] = Timer.scheduledTimer(withTimeInterval: blinkInterval, repeats: true) { [self] _ in
                lightState[index].toggle()
            }
        }
    }

    // Function to reset lights after button 5 blinks
    private func resetLights() {
        counter = 0

        for i in 0..<lightState.count {
            if let timer = timers[i], timer.isValid {
                // Stop the flashing for the current button
                timer.invalidate()
            }
            timers[i] = nil
            lightState[i] = false
        }

        inProgressButtonState = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
