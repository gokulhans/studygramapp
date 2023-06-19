class Users {
  String name, pswd;
  Users(this.name, this.pswd);
}

class UserSignUpModel {
  String name, email, pswd, phone, location, pincode;
  UserSignUpModel(this.name, this.email, this.pswd, this.phone, this.location,
      this.pincode);
}

class UserLoginModel {
  String email, pswd;
  UserLoginModel(this.email, this.pswd);
}