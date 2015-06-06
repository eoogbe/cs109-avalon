class GamesController < ApplicationController
  def new
    session.delete(:game_id)
    self.game = Game.new
    Game::MIN_PLAYERS.times { game.players.build }
  end
  
  def create
    self.game = Game.new(game_params)
    
    if game.save
      session[:game_id] = game.id
      redirect_to new_quest_path
    else
      render :new
    end
  end
  
  def show
    self.game = Game.find(session[:game_id])
  end
  
  private
  helper_attr :game
  
  def game_params
    params.require(:game).permit(players_attributes: [:name, :_destroy])
  end
end
