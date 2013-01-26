part of gradient_picker;

typedef void GradientChangedEvent(GradientValue value);

class GradientPicker {
  GradientValue gradient;
  int width;
  int height;
  
  DivElement elementBase;
  DivElement elementColorPicker;
  GradientPickerColorBar colorBar;
  GradientPickerHandleBar handleBar;
  ColorPicker colorPicker;
  GradientChangedEvent gradientChanged;
  
  /** The currently selected color transition */
  GradientStop selectedStop;
  
  GradientPicker({this.gradient, this.width, this.height}) {
    if (gradient == null) gradient = new GradientValue();
    if (width == null) width = 300;
    if (height == null) height = 200;
    
    elementBase = new DivElement();
    elementBase.style.width = "${width}px"; 
    elementBase.style.height = "${height}px"; 
    elementBase.classes.add("gradient-picker-base");
    
    colorBar = new GradientPickerColorBar(this, width, 30);
    elementBase.nodes.add(colorBar.elementBase);

    handleBar = new GradientPickerHandleBar(this, width, 20);
    elementBase.nodes.add(handleBar.elementBase);
    
    elementColorPicker = new DivElement();
    colorPicker = new ColorPicker(128, showInfoBox: false);
    elementColorPicker.nodes.add(colorPicker.element);
    elementColorPicker.classes.add("gradient-picker-color-picker");
    elementBase.nodes.add(elementColorPicker);
    
    colorPicker.colorChangeListener = _onColorChanged;
    
    draw();
  }

  void _onColorChanged(ColorValue color, num hue, num saturation, num brightness) {
    if (selectedStop != null) {
      selectedStop.color = color;
      draw();
      _notifyGradientChanged();
    }
  }
  
  void _notifyGradientChanged() {
    if (gradientChanged != null) {
      gradientChanged(gradient);
    }
  }
  
  void setActiveStop(GradientStop stop) {
    selectedStop = stop;
    elementColorPicker.style.display = selectedStop != null ? "block" : "none";
    if (selectedStop != null) {
      // Update the color picker's color
      colorPicker.currentColor = stop.color;
    }
    _notifyGradientChanged();
  }
  
  void draw() {
    colorBar.draw();
    handleBar.draw();
  }
}

