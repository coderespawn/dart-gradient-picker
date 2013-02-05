library gradient_value_test;

import "package:gradient_picker/gradient_picker.dart";
import "package:color_picker/color_picker.dart";
import "package:unittest/unittest.dart";

num abs(num) => num < 0 ? -num : num;
bool compareColors(ColorValue a, ColorValue b) {
  bool result = 
      abs(a.r - b.r) <= 1 &&
      abs(a.g - b.g) <= 1 &&
      abs(a.b - b.b) <= 1;
  return result;
}

void main() {
  group("Gradient Value:", () {
    test("get_color_1", () {
      final grad = new GradientValue();
      expect(compareColors(grad.getColor(0), new ColorValue.fromRGB(0, 0, 0)), isTrue);
    });
    test("get_color_2", () {
      final grad = new GradientValue();
      expect(compareColors(grad.getColor(1.0), new ColorValue.fromRGB(255, 255, 255)), isTrue);
    });
    test("get_color_3", () {
      final grad = new GradientValue();
      expect(compareColors(grad.getColor(0.5), new ColorValue.fromRGB(127, 127, 127)), isTrue);
    });
    test("get_color_4", () {
      var stops = new List<GradientStop>();
      stops.add(new GradientStop(new ColorValue.fromRGB(255, 0, 0), 0));
      stops.add(new GradientStop(new ColorValue.fromRGB(0, 255, 0), 1));
      final grad = new GradientValue.from(stops);
      expect(compareColors(grad.getColor(0.0), new ColorValue.fromRGB(255, 0, 0)), isTrue);
      expect(compareColors(grad.getColor(0.5), new ColorValue.fromRGB(127, 127, 0)), isTrue);
      expect(compareColors(grad.getColor(1.0), new ColorValue.fromRGB(0, 255, 0)), isTrue);
    });
    test("get_color_5", () {
      var stops = new List<GradientStop>();
      stops.add(new GradientStop(new ColorValue.fromRGB(255, 0, 0), 0));
      stops.add(new GradientStop(new ColorValue.fromRGB(0, 255, 0), 0.5));
      final grad = new GradientValue.from(stops);
      expect(compareColors(grad.getColor(0.0), new ColorValue.fromRGB(255, 0, 0)), isTrue);
      expect(compareColors(grad.getColor(0.25), new ColorValue.fromRGB(127, 127, 0)), isTrue);
      expect(compareColors(grad.getColor(0.75), new ColorValue.fromRGB(0, 255, 0)), isTrue);
      expect(compareColors(grad.getColor(0.5), new ColorValue.fromRGB(0, 255, 0)), isTrue);
      expect(compareColors(grad.getColor(0.45), new ColorValue.fromRGB(0, 255, 0)), isFalse);
    });
    test("get_color_out_of_range_location_1", () {
      final grad = new GradientValue();
      expect(compareColors(grad.getColor(-2), new ColorValue.fromRGB(0, 0, 0)), isTrue);
    });
    test("get_color_out_of_range_location_2", () {
      final grad = new GradientValue();
      expect(compareColors(grad.getColor(3.20), new ColorValue.fromRGB(255, 255, 255)), isTrue);
    });
  });
}

