$(function() {
  Pong.setPopupListener();
});

Pong = {};

Pong.setPopupListener = function() {
  $("a[target=popup]").click(function(event) {
    event.preventDefault();

    var width = $(this).attr("data-width");
    var height = $(this).attr("data-height");

    var left = ($(window).width() / 2) - (width / 2);
    var top = ($(window).height() / 2) - (height / 2);

    var options = "menubar=no,toolbar=no,status=no,width=" + width + ",height=" + height + ",toolbar=no,left=" + left + ",top=" + top;
    window.open($(this).attr("href"), "", options);
  });
};
