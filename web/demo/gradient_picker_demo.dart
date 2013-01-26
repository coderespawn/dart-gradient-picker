import 'dart:html';
import 'package:gradient_picker/gradient_picker.dart';
import 'package:color_picker/color_picker.dart';

void main() {
  window.onLoad.listen(onLoad);
}


void onLoad(Event e) {
  var color = new GradientValue();
  color.clear();
  color.addStop(new GradientStop(new ColorValue.fromRGB(255, 0, 0), 0));
  color.addStop(new GradientStop(new ColorValue.fromRGB(255, 255, 0), 0.33));
  color.addStop(new GradientStop(new ColorValue.fromRGB(0, 255, 255), 0.66));
  color.addStop(new GradientStop(new ColorValue.fromRGB(0, 0, 255), 1.0));
  var gradientPicker = new GradientPicker(gradient: color, width: 180);
  query("#gradient_picker").nodes.add(gradientPicker.elementBase);
}

