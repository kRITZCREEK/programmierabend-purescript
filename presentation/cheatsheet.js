var buildTeam = function(idx, idy, cb, err){
    findUser(idx, function(x){
        findUser(idy, function(y){
            cb(new Team(x,y));
        }, err);
    }, err);
};
