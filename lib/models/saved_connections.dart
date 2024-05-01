class Connection {
  final List savedConnections;

  const Connection({required this.savedConnections});

  factory Connection.fromJson(Map<String, dynamic> json) {
    return Connection(savedConnections: json['saved_connnections']);
  }
}
