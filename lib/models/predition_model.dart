class PreditionModel {
  late String id;
  late String titulo;
  late String descripcion;

  PreditionModel({
    required this.id,
    required this.descripcion,
    required this.titulo,
  });

  PreditionModel.fromJson(Map<String, dynamic> json) {
    id = json['place_id'];
    titulo = json['structured_formatting']['main_text'];
    descripcion = (json['structured_formatting']['secondary_text'] != null)
        ? json['structured_formatting']['secondary_text']
        : "";
  }
}
