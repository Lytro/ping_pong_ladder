$(document).ready( function(){
  $('#new_match input[type=text]').autocomplete('/matches/players');
  $('.tab-bar').tabs();
  $("a[rel=popover]").popover();
  $(".tooltip").tooltip();
  $("a[rel=tooltip]").tooltip();
});
