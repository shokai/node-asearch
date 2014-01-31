var print = function(msg){
  console.log(msg);
  if(typeof msg === 'object') msg = JSON.stringify(msg);
  $("#log").append(
    $("<li>").text(msg)
  );
};


var check_match = function(asearch, str, ambig){
  var msg = '"' + asearch.source + '" matches "' + str + '"';
  if(ambig) msg += ' with ambiguity:'+ambig;
  msg += ' ? => ' + asearch.match(str, ambig);
  print(msg);
};

var a = new Asearch("cheese burger");
check_match(a, "cheese burger");
check_match(a, "chess burger");
check_match(a, "chess burger", 2);
check_match(a, "chess", 2);
