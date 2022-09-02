ActiveAdmin.register Soloist do
	config.sort_order = 'id_asc'
	actions :index, :show, :new, :destroy, :edit

	menu parent: 'Tables'

  filter :name
  filter :instrument

	index do
		column :name do |s|
			link_to s.name, admin_soloist_path(s.id)
		end
		column :instrument
	end

	show do |s|
		columns do
			column do 
				attributes_table do
					row :name
					row :phone_number
					row :email
          row :instrument
				end
			end
			column do
				panel ("Appearances by #{s.name}") do
					table_for s.appearances do 
						column :date do |a|
							link_to(a.date, admin_appearance_path(a.id))
						end
            column :pieces do |a|
              a.performances.flat_map(&:piece).to_a.map{ |piece| [
                link_to("#{piece.title}", admin_piece_path(piece.id)), ' | ']}.flatten[0...-1]
            end
						column :payment
					end
				end
			end
		end
	end
	
  form do |f|
    f.semantic_errors
    f.inputs 'Details' do
      f.input :name
      f.input :phone_number
      f.input :email
      f.input :instrument
    end

    f.actions
  end

  controller do
    def scoped_collection
      Soloist.all
    end

    def create
      soloist = params[:soloist]
      soloist = ActionController::Parameters.new(soloist)
      @soloist = Soloist.create(soloist.permit!) # TODO: insecure - fix!

      if @soloist.errors.any?
        flash[:error] ||= []
        flash[:error].concat(@soloist.errors.full_messages)
        redirect_to admin_soloist_path()
      else
        redirect_to admin_soloist_path(@soloist.id)
      end
    end

    def update
      soloist = params[:soloist]

      # poll = Poll.parse_poll_params(poll)
      soloist.keys.each do |key|
        if soloist[key] == ''
          soloist[key] = nil
        end
      end

      soloist = ActionController::Parameters.new(soloist)
      @soloist = Soloist.find(params[:id])
      if not @soloist.update(soloist.permit!) # returns boolean, not @poll
        flash[:error] ||= []
        flash[:error].concat(@soloist.errors.full_messages)
        redirect_to :back
      else
        keys_updated = @soloist.previous_changes.except('created_at', 'updated_at').keys.map {|x| "Soloist.#{x}"}
        flash[:notice] = "Successfully updated "+ keys_updated.join(", ")
        redirect_to admin_soloist_path(params[:id])
      end
    end
  end


end