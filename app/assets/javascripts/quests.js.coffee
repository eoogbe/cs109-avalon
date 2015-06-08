$(document).on "change", ".quest_player_id", ->
  numChosen = $(".quest_player_id:checked").length
  numQuestors = $(".fail").length
  playersLeft = numQuestors - numChosen
  hasQuestors = playersLeft is 0
  
  $(".quest_player_id").not(":checked").prop "disabled", hasQuestors
  $("#new_quest :submit").prop "disabled", not hasQuestors
  
  if playersLeft > 1
    $(".quest_players .help-block")
      .html "Select <strong>#{playersLeft}</strong> more players"
      .removeClass "text-success"
  else if playersLeft == 1
    $(".quest_players .help-block")
      .html "Select <strong>1</strong> more player"
      .removeClass "text-success"
  else
    $(".quest_players .help-block")
      .html "Questors selected!"
      .addClass "text-success"

$(document).on "ready", ->
  $(".quest_players .help-block").html "Select <strong>#{$(".fail").length}</strong> more players"
