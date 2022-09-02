class PerformancesController < InheritedResources::Base

  private

    def performance_params
      params.require(:performance).permit(:date, :type)
    end
end

