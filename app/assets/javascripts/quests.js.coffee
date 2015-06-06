$(document).on "change", ".quest_player_id", ->
  hasQuestors = $(".quest_player_id:checked").length is $(".fail").length
  $(".quest_player_id").not(":checked").prop "disabled", hasQuestors
  $("#new_quest :submit").prop "disabled", not hasQuestors
