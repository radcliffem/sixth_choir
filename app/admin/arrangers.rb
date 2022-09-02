ActiveAdmin.register Arranger do
	config.sort_order = 'last_name_asc'
	actions :index, :show, :new, :destroy, :edit

	menu parent: 'Tables'

  filter :first_name
  filter :last_name

	index do
		column :name do |a|
			link_to a.name, admin_arranger_path(a.id)
		end
    column :most_recent_performance do |a|
      a.most_recent_performance
    end
	end

	show do |c|
		columns do
			column do 
				attributes_table do
					c.attributes.each {|key, | row key}
				end
			end
			column do
				panel ("Pieces arranged by #{c.name}") do
					table_for c.pieces do 
						column :title do |p|
							link_to p.title, admin_piece_path(p.id)
						end
            column :composer do |p|
              p.composers.to_a.map { |c| [
                link_to("#{c.name}", admin_composer_path(c.id)),' | '] }.flatten[0...-1]
            end
						column :most_recent do |p|
              p.most_recent_performance
            end
					end
				end
			end
		end
	end

  form do |f|
    f.semantic_errors
    f.inputs 'Details' do
      f.input :first_name
      f.input :middle_name
      f.input :last_name
      f.input :display_name
    end

    f.inputs 'Pieces' do
      f.has_many :pieces, heading: false, allow_destroy: true, new_record: true do |p|
        p.input :composer
        p.input :title
        p.input :year
      end
    end
  
    f.actions
  end

  controller do
    def scoped_collection
      Arranger.all
    end

    def create
      arranger = params[:arranger]
      # poll = Poll.parse_poll_params(poll)
      arranger = ActionController::Parameters.new(arranger)
      @arranger = Arranger.create(arranger.permit!) # TODO: insecure - fix!

      if @arranger.errors.any?
        flash[:error] ||= []
        flash[:error].concat(@arranger.errors.full_messages)
        redirect_to admin_arranger_path()
      else
        redirect_to admin_arranger_path(@arranger.id)
      end
    end

    def update
      arranger = params[:arranger]

      # poll = Poll.parse_poll_params(poll)
      arranger.keys.each do |key|
        if arranger[key] == ''
          arranger[key] = nil
        end
      end

      arranger = ActionController::Parameters.new(arranger)
      @arranger = Arranger.find(params[:id])
      if not @arranger.update(arranger.permit!) # returns boolean, not @poll
        flash[:error] ||= []
        flash[:error].concat(@arranger.errors.full_messages)
        redirect_to :back
      else
        keys_updated = @arranger.previous_changes.except('created_at', 'updated_at').keys.map {|x| "Arranger.#{x}"}
        flash[:notice] = "Successfully updated "+ keys_updated.join(", ")
        redirect_to admin_arranger_path(params[:id])
      end
    end
  end


end