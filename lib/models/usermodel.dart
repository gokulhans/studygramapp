class Users {
  String name, pswd;
  Users(this.name, this.pswd);
}

class UserSignUpModel {
  String name, email, phone, pswd;
  UserSignUpModel(
    this.name,
    this.email,
    this.pswd,
    this.phone,
  );
}

class UserLoginModel {
  String email, pswd;
  UserLoginModel(this.email, this.pswd);
}
