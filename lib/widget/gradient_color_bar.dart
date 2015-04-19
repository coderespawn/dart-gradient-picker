part of gradient_picker;


/** Manages the color bar canvas that displays the gradient */ 
class GradientPickerColorBar {
  DivElement elementBase;
  CanvasElement canvas;
  GradientPicker parent;
  
  GradientPickerColorBar(this.parent, int width, int height) {
    canvas = new CanvasElement(width: width, height: height);
    canvas.classes.add("gradient-picker-colorbar");
    
    elementBase = new DivElement();
    elementBase.nodes.add(canvas);
  }
  
  void draw() {
    final context = canvas.context2D;
    var canvasGradient = context.createLinearGradient(0, 0, canvas.width, 0);
    parent.gradient.stops.forEach((stop) {
      canvasGradient.addColorStop(stop.location, stop.color.toString());
    });
    
    context.save();
    context.fillStyle = canvasGradient;
    context.fillRect(0, 0, canvas.width, canvas.height);
    context.restore();
  }
}

