#include "raylib.h"

int main(int argc, char **argv) {

  InitWindow(800, 450, "raylib [core] example - basic window");

  while (!WindowShouldClose()) {
    BeginDrawing();
    ClearBackground(RAYWHITE);
    EndDrawing();
  }

  CloseWindow();

  return 0;
}
