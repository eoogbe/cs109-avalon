module GamesHelper
  def add_player_button f
    new_player = f.object.players.build
    id = new_player.object_id
    
    fields = f.simple_fields_for(:players, new_player, child_index: id, wrapper: :with_remove_btns) do |player_f|
      render("players/fields", f: player_f)
    end.gsub("\n", "")
    
    content_tag(:button, type: "button", class: "btn btn-success btn-sm", id: "add-player", data: { player_id: id, fields: fields }, "aria-label" => "Add player") do
      content_tag(:span, "", "aria-hidden" => "true", class: "glyphicon glyphicon-plus")
    end
  end
end
