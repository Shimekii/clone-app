class UserService {
  DataBaseMock db = DataBaseMock();
  bool emailIsContains(String email){
    return db.findUserByEmail(email);
  }

  bool passwordIsValid(String email, String password){
    return db.checkPassword(email, password);
  }
}

class DataBaseMock {
  Map<String, String> users = {
    "example@example.com": "password123"
  };

  bool findUserByEmail(String email){
    return users.containsKey(email);
  }

  bool checkPassword(String email, String password){
    return users[email] == password;
  }
}