enum Status {
  alive,
  dead,
  unknown,
}

extension StatusExtension on Status {
  static Status fromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'alive':
        return Status.alive;
      case 'dead':
        return Status.dead;
      default:
        return Status.unknown;
    }
  }

  String toReadableString() {
    switch (this) {
      case Status.alive:
        return "Alive";
      case Status.dead:
        return "Dead";
      case Status.unknown:
      default:
        return "Unknown";
    }
  }
}