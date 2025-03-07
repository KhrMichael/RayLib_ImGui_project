#include "raylib.h"
#include "imgui.h"
#include "rlImGui.h"

int main() {
	const int wid = 700;
	const int hig = 700;
	InitWindow(wid, hig, "RayLib_ImGui");
	SetTargetFPS(60);

	rlImGuiSetup(true);

	while (!WindowShouldClose()) {
		BeginDrawing();
		ClearBackground(RAYWHITE);

		rlImGuiBegin();

		ImGui::Begin("Hello", NULL);
		ImGui::Text("Hello from imgui");
		ImGui::End();

		rlImGuiEnd();

		EndDrawing();
	}
	CloseWindow();

	return 0;
}