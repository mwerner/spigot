(function(){
  function toggleHeader(position){
    var logo = $('header .logo');
    if (position > 223 && !logo.is(":visible")){
      logo.css('display', 'block');
      $('header').css('background', '#000');
    } else if (position < 223 && logo.is(":visible")){
      logo.css('display', 'none');
      $('header').css('background', 'rgba(0,0,0,0.4)');
    }
  }

  $(document).ready(function(){
    $('body').scrollspy({ target: '.navigation', offset: 145 });
    $('body').on('mousewheel', function(event) {
      toggleHeader($(document).scrollTop());
    });
  });

}());

