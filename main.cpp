#include "raylib.h"
#include "imgui.h"
#include "rlImGui.h"

int main() {
	const int winWidth = 1920 * 0.8;
	const int winHeight = 1080 * 0.8;
	InitWindow(winWidth, winHeight, "game_window");
	SetTargetFPS(60);

	while (!WindowShouldClose()) {
		BeginDrawing();
		ClearBackground(BLACK);

		EndDrawing();
	}
	CloseWindow();

	return 0;
}