import Text "mo:base/Text";
import Nat "mo:base/Nat";
import RBTree "mo:base/RBTree";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Int "mo:base/Int";
import Debug "mo:base/Debug";
import Hash "mo:base/Hash";
import Nat16 "mo:base/Nat16";
import Nat8 "mo:base/Nat8";
import List "mo:base/List";
import Types "types";
import Option "mo:base/Option";

actor {
  var users_id : Nat = 0;

  type User = Types.User;

  type Users = Types.Users;

  type UserView = Types.UserView;

  // let users = HashMap.HashMap<Text, User>(3, Text.equal, Text.hash);

  let users : Users = Buffer.Buffer<UserView>(0);

  public shared (msg) func createUser(user : User) : async User {
    users_id += 1;

    var userView : UserView = {
      id : Nat = users_id;
      username : Text = user.username;
      name : ?Text = user.name;
      last_name : ?Text = user.last_name;
      email : ?Text = user.email;
      avatar : ?Text = user.avatar;
    };

    users.add(userView);

    Debug.print("Se ha creado el usuario exitosamente!");

    return userView;
  };

  public query func getUsers() : async Any {
    Buffer.toArray<UserView>(users);
  };

  public query func getUserById(user_id : Nat) : async ?UserView {
    for (i in Iter.range(0, users.size() -1)) {
      let user = users.get(i);
      if (user.id == user_id) { return ?user };
    };
    null;
  };

  public query func deleteUser(user_id : Nat) : async Any {
    for (i in Iter.range(0, users.size() -1)) {
      let user = users.get(i);
      if (user.id == user_id) { let x = users.remove(i); return x };
    };
    null;
  };

  public query func updateUser(user_id : Nat, user : User) : async ?UserView {
    let userView : UserView = {
      id : Nat = users_id;
      username : Text = user.username;
      name : ?Text = user.name;
      last_name : ?Text = user.last_name;
      email : ?Text = user.email;
      avatar : ?Text = user.avatar;
    };

    for (i in Iter.range(0, users.size() -1)) {
      let userOld = users.get(i);
      if (userOld.id == user_id) {
        users.put(i, userView);
        return ?userView;
      };
    };
    null;
  };
};
