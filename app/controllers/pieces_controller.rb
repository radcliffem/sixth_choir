class PiecesController < InheritedResources::Base

	@pieces = Piece.all


  private


    def piece_params
      params.require(:piece).permit(:title, :year)
    end
end

