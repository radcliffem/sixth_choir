ActiveAdmin.register Appearance do
	config.sort_order = 'id_asc'
	actions :index, :show, :new, :destroy, :edit

	menu parent: 'Tables'

	index do
    column :date do |a|
      link_to a.date, admin_appearance_path(a.id)
    end
		column :name do |a|
      link_to a.name, admin_soloist_path(a.soloist.id)
    end
		column :instrument
    column :payment
	end

	show do |a|
		columns do
			column do 
				attributes_table do
					row :id
					row :name
					row :instrument
					row :payment
          row :date
				end
			end
			column do
				panel ("Pieces performed") do
					table_for a.performances do 
						column :id do |a|
							link_to(a.id, admin_performance_path(a.id))
						end
						column :title
						column :purpose
					end
				end
			end
		end
	end
	
  form do |f|
    f.semantic_errors
    f.inputs 'Details' do
      f.input :soloist, as: :select
      f.input :payment
      f.input :performances, as: :select, multiple: true, collection: Performance.all.order(date: :desc).map{|p| [p.display_performance, p.id]}
    end

    f.actions
  end

  controller do
    def scoped_collection
      Appearance.all
    end

    def create
      appearance = params[:appearance]
      appearance = ActionController::Parameters.new(appearance)
      @appearance = Appearance.create(appearance.permit!) # TODO: insecure - fix!

      if @appearance.errors.any?
        flash[:error] ||= []
        flash[:error].concat(@appearance.errors.full_messages)
        redirect_to :back
      else
        redirect_to admin_appearance_path(@appearance.id)
      end
    end

    def update
      appearance = params[:appearance]

      # poll = Poll.parse_poll_params(poll)
      appearance.keys.each do |key|
        if appearance[key] == ''
          appearance[key] = nil
        end
      end

      appearance = ActionController::Parameters.new(appearance)
      @appearance = Appearance.find(params[:id])
      if not @appearance.update(appearance.permit!) # returns boolean, not @poll
        flash[:error] ||= []
        flash[:error].concat(@appearance.errors.full_messages)
        redirect_to :back
      else
        keys_updated = @appearance.previous_changes.except('created_at', 'updated_at').keys.map {|x| "Appearance.#{x}"}
        flash[:notice] = "Successfully updated "+ keys_updated.join(", ")
        redirect_to admin_appearance_path(params[:id])
      end
    end
  end


end