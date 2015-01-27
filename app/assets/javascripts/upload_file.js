

$(document).on('change', '.btn-file :file', function() {
  var input = $(this),
      label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
  input.trigger('fileselect', label);
});

$(document).ready( function() {
    $('.btn-file :file').on('fileselect', function(event, label) {
        var input = $(this).parents('.input-group').find(':text')
        input.val(label);
    });
});
