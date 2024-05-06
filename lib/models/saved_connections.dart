class Connection {
  late final String ssid;
  late final String keymgmt;
  late final String psk;
  late final String localip;

  Connection({
    required this.ssid,
    required this.keymgmt,
    required this.psk,
    required this.localip,
  });
}
