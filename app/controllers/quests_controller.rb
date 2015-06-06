class QuestsController < ApplicationController
  respond_to :html
  
  def new
    game = Game.find(session[:game_id])
    self.quest = game.quests.build
  end
  
  def create
    game = Game.find(session[:game_id])
    self.quest = game.quests.create(quest_params) do |q|
      q.num_fails = params[:fails].count("1")
    end
    
    respond_with(quest, location: game)
  end
  
  private
  helper_attr :quest
  
  def quest_params
    params.require(:quest).permit(player_ids: [])
  end
end
