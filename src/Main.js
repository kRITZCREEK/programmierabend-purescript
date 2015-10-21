//module Main

var players = [
  { name: 'John', age: 23 },
  { name: 'Carl', age: 25 },
  { name: 'Lissy', age: null }
];

var Team = function(x,y) {
    return {x: x, y: y};
};

var findPlayer = function(playerId, cb, err){
  if(playerId < players.length){
    cb(players[playerId]);
  } else{
    err('User not found');
  }
};
module.exports.findPlayer = findPlayer;

var buildTeam = function(idx, idy, cb, err){
  console.log("Not implemented");
};
module.exports.buildTeam = buildTeam;
























// Wrapper für PureScript
module.exports.findPlayerPS = function(playerId, cb, err){
  return function(){
    findPlayer(
      playerId,
      function(v){cb(v)();},
      function(e){err(e)();}
    );
  };
};
