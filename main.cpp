#include "raylib.h"
#include "imgui.h"
#include "rlImGui.h"

#include <filesystem>

int main() {
	const int winWidth = 1920 * 0.8;
	const int winHeight = 1080 * 0.8;
	InitWindow(winWidth, winHeight, "game_window");
	SetTargetFPS(60);

	std::filesystem::path path{ "assets" };
	path /= "spaceship.png";

	auto spaceShipTexture = LoadTexture(path.string().c_str());

	while (!WindowShouldClose()) {
		BeginDrawing();
		ClearBackground(BLACK);

		DrawTexture(spaceShipTexture, 0, 0, WHITE);

		EndDrawing();
	}
	CloseWindow();

	return 0;
}