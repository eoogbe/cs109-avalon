# Adapted from http://railscasts.com/episodes/196-nested-model-form-revised?view=asciicast

$(document).on "click", "#add-player", ->
  time = new Date().getTime()
  regexp = new RegExp($(this).data('playerId'), 'g')
  $("#players-fields").append $(this).data("fields").replace(regexp, time)

$(document).on "click", ".remove-player", ->
  $fieldset = $(this).closest("fieldset")
  $fieldset.find("input[type='hidden']").val "1"
  $fieldset.hide()
