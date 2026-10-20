enum ProfileImageKind {
  logo('logo'),
  signature('signature');

  const ProfileImageKind(this.filePrefix);

  final String filePrefix;
}
