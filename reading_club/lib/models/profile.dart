class Profile{
  final String name;
  final String group;

  const Profile({required this.name, required this.group});

  Profile copyWith({String? name, String? group}){
    return Profile(name: name ?? this.name, group: group ?? this.group,);
  }

  factory Profile.empty() {
    return Profile(
      name: '',
      group: '',
    );
  }
}