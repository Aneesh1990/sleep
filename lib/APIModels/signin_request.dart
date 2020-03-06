class SignInRequest   {

  final String email;
  final String password;


  SignInRequest({ this.email,this.password,});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}