//
// ContentView.swift
// ICS4U-Unit3-06-Swift
//
// Created by Marcus A. Mosley on 2021-05-26
// Copyright (C) 2021 Marcus A. Mosley. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAlert = false
    @State private var boardFull = false
    @State private var checkWinnerX = false
    @State private var checkWinnerO = false
    @State private var board: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    @State private var space: String = ""
    @State private var text: String = ""
    @State private var goodComputerMove: Int = 0

    var body: some View {
        VStack {
            TextField("Which space would you like to place the X? ", text: $space)
                .padding()
            Button("Enter", action: {
                if boardFull == false {
                    if Int(space) == nil || Int(space)! > 9 || Int(space)! < 0 {
                        showingAlert = true
                    } else if board[Int(space)! - 1] == "X" || board[Int(space)! - 1] == "O" {
                        showingAlert = true
                    } else if isNumeric(board[Int(space)! - 1]) {
                        board[Int(space)! - 1] = "X"
                        text = ""
                        space = ""
                        printBoard()
                        checkWinnerX = winOrLost("X")
                        if checkWinnerX == true {
                            text = "X has won. \n\n"
                            gameOver()
                        }
                        // place a function call here to get the best move for O
                        if isFull() == false {
                            goodComputerMove = findMove()
                            text = ""
                            board[goodComputerMove] = "O"
                            printBoard()

                            checkWinnerO = winOrLost("O")
                            if checkWinnerO == true {
                                text = "O has won. \n\n"
                                gameOver()
                            }
                        }
                    } else {
                        text = "Error"
                        gameOver()
                    }
                    checkWinnerX = winOrLost("X")
                    checkWinnerO = winOrLost("O")
                    if checkWinnerX == true {
                        text = "X has won. \n\n"
                        gameOver()
                    } else if checkWinnerO == true {
                        text = "O has won. \n\n"
                        gameOver()
                    }

                    if isFull() == true {
                        boardFull = true
                        text = "A Tie! \n\n"
                        gameOver()
                    }
                } else {
                    gameOver()
                }
            }).padding().alert(isPresented: $showingAlert) {
                Alert(title: Text("Important Message"), message: Text("Not Valid Input"),
                      dismissButton: .default(Text("Got It!")))
            }
            Text("\(text)")
        }
    }

    // Calls Game Over
    func gameOver() {
        printBoard()
        text += "\nGame Over"
    }

    // Checks for a winner
    func winOrLost(_ playerCheck: String) -> Bool {
        if (board[0] == playerCheck && board[1] == playerCheck && board[2] == playerCheck)
            || (board[3] == playerCheck && board[4] == playerCheck && board[5] == playerCheck)
            || (board[6] == playerCheck && board[7] == playerCheck && board[8] == playerCheck)
            || (board[0] == playerCheck && board[3] == playerCheck && board[6] == playerCheck)
            || (board[1] == playerCheck && board[4] == playerCheck && board[7] == playerCheck)
            || (board[2] == playerCheck && board[5] == playerCheck && board[8] == playerCheck)
            || (board[0] == playerCheck && board[4] == playerCheck && board[8] == playerCheck)
            || (board[2] == playerCheck && board[4] == playerCheck && board[6] == playerCheck) {
          return true
        } else {
          return false
        }
    }

    // Defines the move with the highest probability of winning
    func miniMax(_ depth: Int, _ isMax: Bool) -> Int {
        var bestScore: Int
        var score: Int

        if winOrLost("O") {
          return 1
        } else if winOrLost("X") {
          return -1
        } else if isFull() {
          return 0
        }

        if isMax {
            bestScore = -1000
            for boardCounter in 0..<board.count {
                if isNumeric(board[boardCounter]) {
                    board[boardCounter] = "O"
                    score = miniMax(depth + 1, !isMax)
                    board[boardCounter] = String(boardCounter + 1)
                    bestScore = max(score, bestScore)
                }
            }
            return bestScore
        } else {
            bestScore = 1000
            for boardCounter in 0..<board.count {
                if isNumeric(board[boardCounter]) {
                    board[boardCounter] = "X"
                    score = miniMax(depth + 1, !isMax)
                    board[boardCounter] = String(boardCounter + 1)
                    bestScore = min(score, bestScore)
                }
            }
            return bestScore
        }
    }

    // Checks if the array is a magic square
    func findMove() -> Int {
        var score: Int
        var bestScore = -1000
        var bestMove = 0

        for boardCounter in 0..<board.count {
            if isNumeric(board[boardCounter]) {
                board[boardCounter] = "O"
                score = miniMax(0, false)
                board[boardCounter] = String(boardCounter + 1)
                if score > bestScore {
                  bestScore = score
                  bestMove = boardCounter
                }
            }
        }
        return bestMove
    }

    // Checks if the array is full
    func isFull() -> Bool {
        var full = true
        for boardCounter in 0..<board.count {
            if isNumeric(board[boardCounter]) {
                full = false
                break
            }
        }
        return full
    }

    // Prints the array
    func printBoard() {
        text += "--+--+--\n"
        for boardCounter in 0..<board.count {
            if boardCounter == 2 || boardCounter == 5 || boardCounter == 8 {
                text += "| \(board[boardCounter]) |\n"
                text += "--+--+--\n"
            } else {
                text += "| \(board[boardCounter]) "
            }
        }
    }

    // Checks if the element contains an integer
    func isNumeric(_ strNum: String) -> Bool {
        if Int(strNum) == nil {
            return false
        } else {
            return true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
