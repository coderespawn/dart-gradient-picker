import 'dart:html';
import 'package:color_picker/color_picker.dart';
import 'package:gradient_picker/gradient_picker.dart';

void main() {
  var color = new GradientValue();
  color.clear();
  color.addStop(new GradientStop(new ColorValue.fromRGB(255, 0, 0), 0));
  color.addStop(new GradientStop(new ColorValue.fromRGB(255, 255, 0), 0.33));
  color.addStop(new GradientStop(new ColorValue.fromRGB(0, 255, 255), 0.66));
  color.addStop(new GradientStop(new ColorValue.fromRGB(0, 0, 255), 1.0));
  var gradientPicker = new GradientPicker(gradient: color, width: 180);
  querySelector("#gradient_picker").nodes.add(gradientPicker.elementBase);
}

