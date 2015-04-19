part of gradient_picker;

/** 
 * Manages the canvas that draws the handle bar.  This element lets the user
 * create new gradient stops and modify the transition of the colors using 
 * gradient stop handles
 */ 
class GradientPickerHandleBar {
  List<GradientPickerStopHandle> handles = new List<GradientPickerStopHandle>();
  GradientPicker parent;
  DivElement elementBase;
  CanvasElement canvas;
  ImageElement imageHandle;
  ImageElement imageHandleSelected;
  
  /** The extra canvas space on the sides for the handle on extreme edges to show correctly */
  int sideMargin = 5;
  
  /** The width of the canvas, without the extra padding on the sides */
  int barWidth;
  
  /** The handle that is being dragged. Null if no handle is being dragged */
  GradientPickerStopHandle draggedHandle = null;
  
  StreamSubscription mouseMoveHandler;
  StreamSubscription mouseUpHandler;
  
  GradientPickerHandleBar(this.parent, int width, int height) {
    this.barWidth = width;
    canvas = new CanvasElement(width: width + sideMargin * 2, height: height);
    canvas.classes.add("gradient-picker-handlebar");
    canvas.context2D.translate(sideMargin, 0);  // Fix the origin
    canvas.onMouseDown.listen(onMouseDown);
    canvas.onMouseMove.listen(_updateMousePointer);
    canvas.onContextMenu.listen((e) {
      e.preventDefault();
      e.stopPropagation();
    });

    elementBase = new DivElement();
    elementBase.nodes.add(canvas);
    
    // Build the handles based on the gradient stops
    for (var stop in parent.gradient.stops) {
      var handle = new GradientPickerStopHandle(this, stop);
      handles.add(handle);
    }
    
    // Load the images
    imageHandle = new ImageElement();
    imageHandleSelected = new ImageElement();
    imageHandle.onLoad.listen((e) => draw());
    imageHandleSelected.onLoad.listen((e) => draw());
    imageHandle.src = GradientResources.imageColorHandle;
    imageHandleSelected.src = GradientResources.imageColorHandleSelected;
  }

  void draw() {
    final context = canvas.context2D;
    context.clearRect(-sideMargin, 0, canvas.width, canvas.height);
    handles.forEach((handle) => handle.draw(context, barWidth));
  }
  
  void _sortHandles() {
    handles.sort((a, b) {
      if (a.stop.location == b.stop.location) return 0;
      return (a.stop.location < b.stop.location) ? -1 : 1;
    });
  }
  
  void onMouseMoved(MouseEvent e) {
    if (draggedHandle != null) {
      _setHandlePosition(draggedHandle, getHandlePosition(e));
      _sortHandles();
      parent.draw();
      parent._notifyGradientChanged();
    }
  }
  
  /** Sets the position of the gradient transtion stop */
  void _setHandlePosition(GradientPickerStopHandle handle, int x) {
    handle.stop.location = x / barWidth;
    parent.gradient.sortStops();
  }

  void _updateMousePointer(MouseEvent e) {
    // Update the mouse pointer
    var handle = getIntersectingHandle(e);
    canvas.style.cursor = (handle == null) ? "pointer" : "default";
  }
  
  void onMouseUp(MouseEvent e) {
    if (mouseMoveHandler != null) {
      mouseMoveHandler.cancel();
      mouseMoveHandler = null;
    }
    if (mouseUpHandler != null) {
      mouseUpHandler.cancel();
      mouseUpHandler = null;
    }

    parent.draw();
  }
  
  void onMouseDown(MouseEvent e) {
    if (mouseMoveHandler != null) mouseMoveHandler.cancel();
    if (mouseUpHandler != null) mouseUpHandler.cancel();
    
    
    var handle = getIntersectingHandle(e);
    final int MOUSE_BUTTON_LEFT = 0;
    final int MOUSE_BUTTON_RIGHT = 2;
    if (e.button == MOUSE_BUTTON_LEFT) {
      if (handle != null) {
        // An existing item was selected.
        _selectHandle(handle);
      }
      else {
        // The user selected an empty space. Check if the location is valid
        int x = getHandlePosition(e);
        num percent = x / barWidth;
        if (percent >= 0 && percent <= 1) {
          // The mouse was clicked within the range. Add a new color transition
          var stop = new GradientStop(new ColorValue.fromRGB(0, 0, 0), percent);
          parent.gradient.addStop(stop);
          parent.gradient.sortStops();
          
          // Add a new transition handle
          var handle = new GradientPickerStopHandle(this, stop);
          handles.add(handle);
          _sortHandles();
          _selectHandle(handle);
          parent._notifyGradientChanged();
        }
      }
      mouseMoveHandler = document.body.onMouseMove.listen(onMouseMoved);
      mouseUpHandler = document.body.onMouseUp.listen(onMouseUp);
    } 
    else if (e.button == MOUSE_BUTTON_RIGHT) {
      // Remove a handle if clicked on it
      if (handle != null) {
        // Make sure we move than 2 stops
        if (handles.length > 2) {
          parent.gradient.removeStop(handle.stop);
          handles.removeAt(handles.indexOf(handle));
          parent._notifyGradientChanged();
          _selectHandle(null);
        }
      }
    }

    parent.draw();
  }
  
  /** Deselects the previously selected handle and selects the specified [handle] */
  void _selectHandle(GradientPickerStopHandle handle) {
    if (draggedHandle != null) {
      draggedHandle.selected = false;
    }
    
    draggedHandle = handle;
    if (draggedHandle != null) {
      draggedHandle.selected = true;
      parent.setActiveStop(draggedHandle.stop);
    } else {
      parent.setActiveStop(null);
    }
  }
  
  
  int getHandlePosition(MouseEvent e) =>  e.offsetX - sideMargin;
  
  GradientPickerStopHandle getIntersectingHandle(MouseEvent e) {
    final x = getHandlePosition(e);
    final y = e.offsetY;
    for (var handle in handles) {
      if (handle.isInsideHandle(x, y)) {
        return handle;
      }
    }
    return null;
  }
}

/** 
 * Represents a gradient transition stop handle.  Lets the user slide the
 * handle across the gradient to specify it's position. Also displays a 
 * color picker in it's location to let the user choose a color value
 */
class GradientPickerStopHandle {
  GradientPickerHandleBar parent;
  GradientStop stop;
  GradientPickerStopHandle(this.parent, this.stop);
  
  /** The position of the handle in the canvas */
  int position = 0;
  
  bool dragging = true;
  
  bool _selected = false;
  bool get selected => _selected;
  set selected(bool value) => _selected = value;

  void draw(CanvasRenderingContext2D context, final num canvasWidth) {
    final image = parent.imageHandle;
    position = (canvasWidth * stop.location).toInt();
    context.save();
    context.fillStyle = stop.color.toString();
    final thumbOffsetX = 2;
    final thumbOffsetY = 7;
    final imageX = position - image.width / 2;
    final imageY = 0;
    context.fillRect(imageX + thumbOffsetX, imageY + thumbOffsetY, 8, 8);
    context.drawImage(selected ? parent.imageHandleSelected : parent.imageHandle, imageX, imageY);
    context.restore();
  }
  
  bool isInsideHandle(int x, int y) {
    final image = parent.imageHandle;
    final halfWidth = image.width ~/ 2;
    final sx = position - halfWidth;
    final ex = position + halfWidth;
    final sy = 0;
    final ey = image.height;
    return x >= sx && x <= ex && y >= sy && y <= ey;
  }
}

