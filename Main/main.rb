require_relative '../UI/textUI'
require_relative '../Irrgarten/Game'
require_relative '../Controller/controller'

module Main
  class Main
    def main
      vista = UI::TextUI.new
      game = Irrgarten::Game.new(1)
      controlador = Control::Controller.new(game, vista)
      controlador.play

    end
  end
end

programa = Main::Main.new
programa.main
