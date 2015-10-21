//module Team

var findUser = require('./Main.js').findUserJS;

findUser(1, function(u){
  console.log(u.name)
}, console.log);

var userPair = function(idx, idy, cb, err){
  findUser(idx, function(x){
    findUser(idy, function(y){
      cb({ x: x, y: y })
    }, err);
  }, err);
};

userPair(0, 1, console.log, console.log);
