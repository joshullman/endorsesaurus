// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.slick
// THIS IS WHERE TURBOLINKS WAS
//= require_tree .
//= require Chart.bundle
//= require chartkick

// $('.rec_wrapper').on('submit', '.main_search', function(event) {
//   event.preventDefault();
//   $('.results_wrapper').remove();
//   var $form = $(event.target);

//   $.ajax({
//     method: $form.attr('method'),
//     url: $form.attr('action'),
//     data: $form.serialize()
//   })

//   .done(function (response) {
//     $('.search_wrapper').append(response);
//     $('.search_form')[0].reset();
//   })

//   .fail(function (response) {
//   })
// })
$(document).ready(function(){

  // Likes jquery

  $('.likes_button').click(function(){
    $('.likes_wrapper').show();
    $('.seen_wrapper').hide();
    $('.dislikes_wrapper').hide();
  });

  $('.seen_button').click(function(){
    $('.seen_wrapper').show();
    $('.likes_wrapper').hide();
    $('.dislikes_wrapper').hide();
  });

  $('.dislikes_button').click(function(){
    $('.dislikes_wrapper').show();
    $('.seen_wrapper').hide();
    $('.likes_wrapper').hide();
  });

  $('.likes_row_show').click(function() {
    console.log($(this));
    $(this).siblings().children('.likes_row_season').toggle();
    $(this).siblings().children('.likes_row_season').siblings('.likes_row_episode').hide();
  });

  $('.likes_row_season').click(function() {
    console.log($(this));
    $(this).siblings('.likes_row_episode').toggle();
  });

// Recommendations jquery

  $('.recommendation_row_show').click(function() {
    console.log($(this));
    $(this).siblings().children('.recommendation_row_season').toggle();
    $(this).siblings().children('.recommendation_row_season').siblings('.recommendation_row_episode').hide();
  });

  $('.recommendation_row_season').click(function() {
    console.log($(this));
    $(this).siblings('.recommendation_row_episode').toggle();
  });

// Expand Movie Recs jquery

  $('.recommendation_row_movie').click(function() {
    console.log($(this));
    $(this).children('.recommendation_expanded_movie').toggle();
  });

// Expand Movie Likes jquery

$('.likes_row_movie').click(function() {
    console.log($(this));
    $(this).children('.expanded_likes_movie').toggle();
  });

// Adding Slick to the movies/index page

  $('.media_index_tag_wrapper').slick({
    infinite: true,
    slidesToShow: 6,
    slidesToScroll: 6
  });

});