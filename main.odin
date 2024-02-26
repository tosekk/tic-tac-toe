package main

import "core:fmt"
import "core:math"
import la "core:math/linalg"

import rl "vendor:raylib"


// CONSTANTS
SCREEN_HEIGHT: f32 = 400
SCREEN_WIDTH: f32 = 400
SCREEN_BG_COLOR: rl.Color = { 240, 240, 240, 255 }
MAIN_COLOR: rl.Color = { 30, 30, 30, 255 }


main :: proc() {
    rl.InitWindow(i32(SCREEN_WIDTH), i32(SCREEN_HEIGHT), "Tic Tac Toe")

    collisionRecs: [9]rl.Rectangle

    for i in 0..=2 {
        for j in 0..=2 {
            collisionRecs[(i * 3) + j] = rl.Rectangle{50 + f32(j * 100), 50 + f32(i * 100), 100, 100}
        }
    }

    openPositions: [dynamic]rl.Rectangle
    playerTurns: [dynamic]la.Vector2f32
    opponentTurns: [dynamic]la.Vector2f32
    
    for i in 0..=(len(collisionRecs) - 1) {
        append(&openPositions, collisionRecs[i])
    }

    placeShape: bool = false
    opponentTurn: bool = false
    
    fmt.println(collisionRecs)

    rl.SetTargetFPS(120)

    for !rl.WindowShouldClose() {
        mousePos: la.Vector2f32 = rl.GetMousePosition()

        if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
            for i in 0..=(len(openPositions) - 1) {
                placeShape = rl.CheckCollisionPointRec(mousePos, openPositions[i])
                if placeShape {
                    append(&playerTurns, la.Vector2f32{ openPositions[i].x, openPositions[i].y })
                    if len(openPositions) > 1 {
                        ordered_remove(&openPositions, i)
                    }
                    break
                }
            }
        }

        if rl.IsMouseButtonReleased(rl.MouseButton.LEFT) {
            placeShape = false
            opponentTurn = true
        }

        if opponentTurn && len(openPositions) > 1 {
            randomPos: int = int(rl.GetRandomValue(0, i32(len(openPositions) - 1)))
            possibleTurn: la.Vector2f32 = { openPositions[randomPos].x, openPositions[randomPos].y }

            for playerPos in playerTurns {
                if possibleTurn != playerPos {
                    append(&opponentTurns, possibleTurn)
                    ordered_remove(&openPositions, randomPos)
                    break
                } else {
                    randomPos = int(rl.GetRandomValue(0, i32(len(openPositions) - 1)))
                    possibleTurn = { openPositions[randomPos].x, openPositions[randomPos].y }
                }
            }

            opponentTurn = false
        }

        rl.BeginDrawing()
            rl.ClearBackground(SCREEN_BG_COLOR)

            rl.DrawLineV({150, 50}, {150, 350}, MAIN_COLOR)
            rl.DrawLineV({250, 50}, {250, 350}, MAIN_COLOR)
            rl.DrawLineV({50, 150}, {350, 150}, MAIN_COLOR)
            rl.DrawLineV({50, 250}, {350, 250}, MAIN_COLOR)


            for playerTurn in playerTurns {
                rl.DrawCircleV(playerTurn + 50, 40, MAIN_COLOR)
                rl.DrawCircleV(playerTurn + 50, 30, SCREEN_BG_COLOR)
            }

            for opponentTurn in opponentTurns {
                rl.DrawRectangleV(opponentTurn + 10, { 80, 80 }, MAIN_COLOR)
                rl.DrawRectangleV(opponentTurn + 20, { 60, 60 }, SCREEN_BG_COLOR)
            }

        rl.EndDrawing()
    }

    rl.CloseWindow()
}