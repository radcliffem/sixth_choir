ActiveAdmin.register Composer do
	config.sort_order = 'last_name_asc'
	actions :index, :show, :new, :destroy, :edit

	menu parent: 'Tables'

	filter :first_name
  filter :last_name

	filter :nationality, as: :select, multiple: true

	index do
		column :name do |c|
			link_to c.name, admin_composer_path(c.id)
		end
		column :nationality
    column :most_recent_performance do |c|
      c.most_recent_performance
    end
	end

	show :title => :name do |c|
		columns do
			column do 
				attributes_table do
					c.attributes.each {|key, | row key}
				end
			end
			column do
				panel ("Pieces by #{c.name}") do
					table_for c.pieces do 
						column :title do |p|
							link_to p.title, admin_piece_path(p.id)
						end
            column :voices do |p|
              p.voices.join(' | ')
            end
            column :special_parts do |p|
              p.special_parts.join(' | ')
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
      f.input :nationality # , as: :select, collection: Composer.all.map {|x| x.nationality}.uniq
    end

    f.inputs 'Pieces' do
      f.has_many :pieces, heading: false, allow_destroy: true, new_record: true do |p|
        p.input :title
        p.input :year
        p.input :arrangers, as: :select, multiple: true, collection: Arranger.all.map {|x| [x.name, x.id]}
        p.input :genre
        p.input :voices, as: :select, multiple: true, collection: Piece.valid_voices
        p.input :special_parts, as: :select, multiple: true, collection: Piece.all.map(&:special_parts).uniq
        p.input :acapella
        p.input :collection, as: :select, collection: Collection.all.map {|x| [x.name, x.id]}
        p.input :page_number
        p.input :publisher
        p.input :catalog_number
      end
    end
  
    f.actions
  end

  controller do
    def scoped_collection
      Composer.all
    end

    def create
      composer = params[:composer]
      # poll = Poll.parse_poll_params(poll)
      composer = ActionController::Parameters.new(composer)
      @composer = Composer.create(composer.permit!) # TODO: insecure - fix!

      if @composer.errors.any?
        flash[:error] ||= []
        flash[:error].concat(@composer.errors.full_messages)
        redirect_to admin_composer_path()
      else
        redirect_to admin_composer_path(@composer.id)
      end
    end

    def update
      composer = params[:composer]

      # poll = Poll.parse_poll_params(poll)
      composer.keys.each do |key|
        if composer[key] == ''
          composer[key] = nil
        end
      end

      composer = ActionController::Parameters.new(composer)
      @composer = Composer.find(params[:id])
      if not @composer.update(composer.permit!) # returns boolean, not @poll
        flash[:error] ||= []
        flash[:error].concat(@composer.errors.full_messages)
        redirect_to :back
      else
        keys_updated = @composer.previous_changes.except('created_at', 'updated_at').keys.map {|x| "Composer.#{x}"}
        flash[:notice] = "Successfully updated "+ keys_updated.join(", ")
        redirect_to admin_composer_path(params[:id])
      end
    end
  end


end