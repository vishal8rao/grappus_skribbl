// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class WebSocketEvent {
  final String eventName;
  WebSocketEvent({
    required this.eventName,
  });
}

class AddMousePointerEvent extends WebSocketEvent {
  AddMousePointerEvent({
    required this.mouseX,
    required this.mouseY,
    super.eventName = name,
  });
  final num mouseX;
  final num mouseY;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mouseX': mouseX,
      'mouseY': mouseY,
    };
  }

  factory AddMousePointerEvent.fromMap(Map<String, dynamic> map) {
    return AddMousePointerEvent(
      mouseX: map['mouseX'] as num,
      mouseY: map['mouseY'] as num,
    );
  }
  static const String name = 'addMouseOffset';
}
