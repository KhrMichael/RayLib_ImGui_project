#include "raylib.h"
#include "imgui.h"
#include "rlImGui.h"

#include <cmath>
#include <algorithm>
#include <ranges>
#include <iterator>
#include <vector>

struct Line {
	float k;
	float b;

	static Line Create(Vector2 startingPoint, Vector2 norm) {
		return { norm.x / norm.y, (-norm.x * startingPoint.x - norm.y * startingPoint.y)/norm.y};
	}

	static Line Horizontal(float b) {
		return { 0, b };
	}

	Vector2 Intersect(Line other) {
		float x = (other.b - this->b) / (this->k - other.k);
		return {
			x,
			this->k * x + this->b
		};
	}
};

Vector2 operator+(Vector2 left, Vector2 right) {
	return { left.x + right.x, left.y + right.y };
}

Vector2 operator-(Vector2 left, Vector2 right) {
	return { left.x - right.x, left.y - right.y };
}

Vector2 operator-(Vector2 self) {
	return { -self.x, -self.y };
}

Vector2 TransVerse(Vector2 self) {
	return { -self.y, self.x};
}

Vector2 operator*(Vector2 self, float factor) {
	return { self.x * factor, self.y * factor };
}

Vector2 operator/(Vector2 self, float factor) {
	return { self.x / factor, self.y / factor };
}

float Magnitude(Vector2 self) {
	return std::sqrt(self.x * self.x + self.y * self.y);
}

void DrawCustomLine(Vector2 startingPoint, Vector2 endingPoint, float thickness, Color color) {
	startingPoint.y = -startingPoint.y;
	endingPoint.y = -endingPoint.y;

	Vector2 direction = endingPoint - startingPoint;
	float magnitude = Magnitude(direction);
	Vector2 cross = TransVerse(direction) / magnitude * (thickness / 2);

	Vector2 startingPoint1 = startingPoint + cross;
	Vector2 endingPoint1 = endingPoint + cross;

	Vector2 startingPoint2 = startingPoint - cross;
	Vector2 endingPoint2 = endingPoint - cross;

	Line line1 = Line::Create(startingPoint1, cross);
	Line line2 = Line::Create(startingPoint2, cross);

	Line line3 = Line::Create(startingPoint1, direction);
	Line line4 = Line::Create(endingPoint1, direction);

	Line lines[] = { line1, line2, line3, line4 };

	float top = std::min({ startingPoint1.y , startingPoint2.y, endingPoint1.y, endingPoint2.y });
	float down = std::max({ startingPoint1.y , startingPoint2.y, endingPoint1.y, endingPoint2.y });

	Vector2 points[std::size(lines)];

	for (float currentY = -top; currentY > -down; currentY--) {
		Line horizontal = Line::Horizontal(currentY);

		auto pointsView = lines | std::views::transform([&horizontal](Line line)
			{
				return horizontal.Intersect(line);
			});

		std::ranges::copy(pointsView, std::begin(points));

		std::ranges::sort(points, std::less(), [](Vector2 point)
			{
				return point.x;
			});

		for (float current = points[1].x; current < points[2].x; current++) {
			DrawPixel(static_cast<int>(current), static_cast<int>(horizontal.b), RED);
		}
	}
}

int main() {
	const int winWidth = 1920 * 0.8;
	const int winHeight = 1080 * 0.8;
	InitWindow(winWidth, winHeight, "game_window");
	SetTargetFPS(60);

	Vector2 startingPoint = { 10, 20 };
	Vector2 endingPoint = { 510, 520 };
	float thickness = 10.0f;

	while (!WindowShouldClose()) {
		BeginDrawing();
		ClearBackground(BLACK);

		DrawLineEx(Vector2{ 10, 10 }, Vector2{ 510, 10 }, 10, Color{ 255, 0, 0, 100 });

		DrawCustomLine(Vector2{ 10, 40 }, Vector2{ 510, 40 }, 10, Color{ 255, 0, 0, 100 });

		EndDrawing();
	}
	CloseWindow();

	return 0;
}

