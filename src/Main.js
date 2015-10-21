//module Main

var users = [
  { name: 'John', age: 23 },
  { name: 'Carl', age: 25 },
  { name: 'Lissy', age: null }
];

var Team = function(x,y) {
    return {x: x, y: y};
}

var findUser = function(userId, cb, err){
  if(userId < users.length){
    cb(users[userId]);
  } else{
    err("User not found");
  }
};
module.exports.findUser = findUser;

// var buildTeam = function(idx, idy, cb, err){
//     findUser(idx, function(x){
//         findUser(idy, function(y){
//             cb(new Team(x,y));
//         }, err)
//     }, err);
// };
// module.exports.buildTeam = buildTeam;























// Wrapper für PureScript
module.exports.findUserPS = function(userId, cb, err){
  return function(){
    findUser(
      userId,
      function(v){cb(v)();},
      function(e){err(e)();}
    );
  }
};
