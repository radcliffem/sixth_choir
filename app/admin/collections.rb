ActiveAdmin.register Collection do
	config.sort_order = 'id_asc'
	actions :index, :show, :new, :destroy, :edit

	menu parent: 'Tables'

	filter :name

	index do
		column :name do |c|
			link_to c.name, admin_collection_path(c.id)
		end
		
    # column :most_recent_performance do |c|
    #   c.performances.pluck(:date).max
    # end
	end

	show do |c|
		columns do
			column do 
				attributes_table do
					c.attributes.each {|key, | row key}
				end
			end
			column do
				panel ("Pieces in #{c.name}") do
					table_for c.pieces.order(page_number: :asc) do 
						column :title do |p|
							link_to p.title, admin_piece_path(p.id)
						end
						column :most_recent do |p|
              p.most_recent_performance
            end
            column :page_number do |p|
              p.page_number
            end

					end
				end
			end
		end
	end

  form do |f|
    f.semantic_errors
    f.inputs 'Details' do
      f.input :name
    end

    f.inputs 'Pieces' do
      f.has_many :pieces, heading: false, allow_destroy: true, new_record: true do |p|
        p.input :title
        p.input :year
      end
    end
  
    f.actions
  end

  controller do
    def scoped_collection
      Collection.all
    end

    def create
      collection = params[:collection]
      # poll = Poll.parse_poll_params(poll)
      collection = ActionController::Parameters.new(collection)
      @collection = Collection.create(collection.permit!) # TODO: insecure - fix!

      if @collection.errors.any?
        flash[:error] ||= []
        flash[:error].concat(@collection.errors.full_messages)
        redirect_to :back
      else
        redirect_to admin_collection_path(@collection.id)
      end
    end

    def update
      collection = params[:collection]

      # poll = Poll.parse_poll_params(poll)
      collection.keys.each do |key|
        if collection[key] == ''
          collection[key] = nil
        end
      end

      collection = ActionController::Parameters.new(collection)
      @collection = Collection.find(params[:id])
      if not @collection.update(collection.permit!) # returns boolean, not @poll
        flash[:error] ||= []
        flash[:error].concat(@collection.errors.full_messages)
        redirect_to :back
      else
        keys_updated = @collection.previous_changes.except('created_at', 'updated_at').keys.map {|x| "Collection.#{x}"}
        flash[:notice] = "Successfully updated "+ keys_updated.join(", ")
        redirect_to admin_collection_path(params[:id])
      end
    end
  end


end