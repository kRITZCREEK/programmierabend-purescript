//module Main

var users = [
  { name: 'John', age: 23 },
  { name: 'Carl', age: 25 },
  { name: 'Lissy', age: null }
];

var findUser = function(userId, cb, err){
  if(userId < users.length){
    cb(users[userId]);
  } else{
    err("User not found");
  }
};

module.exports.findUserJS = findUser;
module.exports.findUserPS = function(userId, cb, err){
  return function(){
    findUser(
      userId,
      function(v){cb(v)();},
      function(e){err(e)();}
    );
  }
};
