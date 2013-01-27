# Dart Gradient Picker

The gradient picker provides a widget to create / modify a gradient.  A gradient consists of color stops, 
where each stop consists of a color an it's location.   The color stop handle can be moved to modify the color
transitions on the gradient

## Gradient Picker Widget

![Gradient Picker](https://raw.github.com/coderespawn/dart-gradient-picker/master/doc/images/gradient_preview.png)

Import the gradient picker into your project as defined in pub.  Instantiate the gradient widget:

	var gradientPicker = new GradientPicker(gradient: color, width: 180);
	query("#gradient_picker").nodes.add(gradientPicker.elementBase);  

The `GradientPicker` takes in an optional the starting gradient `color`.  The `width` of the widget is also configurable

## Gradient Value Data Structure

The `GradientValue` data structure represents the gradient.   `GradientValue` contains a list of `GradientStop`.  
Each `GradientStop` specifies a color and it's location in the gradient.  A custom gradient can be built as follows:

	var color = new GradientValue();
	color.clear();
	color.addStop(new GradientStop(new ColorValue.fromRGB(255, 0, 0), 0));
	color.addStop(new GradientStop(new ColorValue.fromRGB(255, 255, 0), 0.33));
	color.addStop(new GradientStop(new ColorValue.fromRGB(0, 255, 255), 0.66));
	color.addStop(new GradientStop(new ColorValue.fromRGB(0, 0, 255), 1.0)); 

This creates a gradient with a red color on the left extreme end.  Then a color stop of yellow is placed on 33%, 
cyan on 66% and green on the extreme right

## Demo
Check out the live demo [here](http://dart-app-samples.appspot.com/demos/dart-gradient-picker/gradient_picker_demo.html)
