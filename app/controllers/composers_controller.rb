class ComposersController < InheritedResources::Base

  private

    def composer_params
      params.require(:composer).permit(:name, :nationality)
    end

    def index
    	@composers = Composer.all.by_name

    	respond_to do |format|
    		format.html
    		format.xml { render :xml => @composers }
    	end
    end
end

