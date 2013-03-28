(function() {
  this._.mixin({
    toPoint: function(arr) {
      return {
        x: arr[0],
        y: arr[1]
      };
    },
    product: function() {
      return _.reduce(arguments, (function(a, b) {
        return _.flatten(_.map(a, function(x) {
          return _.map(b, function(y) {
            return x.concat([y]);
          });
        }), true);
      }), [[]]);
    },
    debug: function() {
      if (_.DEBUG) {
        return console.log(arguments);
      }
    }
  });

}).call(this);
