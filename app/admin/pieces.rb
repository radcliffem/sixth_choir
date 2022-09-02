ActiveAdmin.register Piece do
	config.sort_order = 'id_asc'
	actions :index, :show, :new, :destroy, :edit

	menu parent: 'Tables'

  filter :composers, collection: proc { Composer.all.order(:last_name).collect{|c| ["#{c.name}", c.id]} }, multiple: true
  filter :performances, collection: proc { Performance.all.order(date: :desc).collect{|p| ["#{p.date}: #{p.purpose}", p.id]} }, multiple: true
  filter :title
  filter :year

  @@valid_voices = %w(2\ equal\ voices 2\ part SATB SSAA)


	index do
		column :title do |p|
			link_to p.title, admin_piece_path(p.id)
		end
		column 'Composer' do |p| 
      p.composers.to_a.map { |c| [
        link_to("#{c.name}", admin_composer_path(c.id)),' | '] }.flatten[0...-1]
      end
    column :voicing do |p|
      p.voices
    end
    column :most_recent_performance do |p|
      p.performances.pluck(:date).max
    end

	end

	show do |p|
		columns do
			column do 
				attributes_table do
					row :title
					row :year
					row :composers do
            p.composers.to_a.map { |c| [
              link_to("#{c.name}", admin_composer_path(c.id)),
              ' | '] }.flatten[0...-1]
          end
          row :arrangers do
            p.arrangers.to_a.map { |c| [
              link_to("#{c.name}", admin_arranger_path(c.id)),
              ' | '] }.flatten[0...-1]
          end
          row :genre
          row :acapella
          row :voices do 
            p.voices.join(' | ')
          end
          row :special_parts do 
            p.special_parts.join(' | ')
          end
          if p.collection.present?
            row :collection do 
              link_to p.collection.name, admin_collection_path(p.collection_id)
            end
            row :page_number
          end
          row :publisher
          row :catalog_number
          if p.notes.present?
            row :notes
          end
				end
			end
			column do
				panel ("Performances of #{p.title}") do
					table_for p.performances.order(date: :desc) do 
						column :date do |perf|
							link_to(perf.date, admin_performance_path(perf.id))
						end
            column :season do |perf|
              perf.liturgical_season
            end
						column :purpose
            column :voice
					end
				end
			end
		end
	end
	
  form do |f|
    f.semantic_errors
    f.inputs 'Details' do
      f.input :title
      f.input :year
      f.input :composers, as: :select, multiple: true, collection: Composer.all.map {|x| [x.name, x.id]}
      f.input :arrangers, as: :select, multiple: true, collection: Arranger.all.map {|x| [x.name, x.id]}
      f.input :genre
      f.input :voices, as: :select, multiple: true, collection: Piece.valid_voices
      f.input :acapella
      f.input :special_parts, as: :select, multiple: true, collection: Piece.all.map(&:special_parts).flatten.uniq
      f.input :collection, as: :select, collection: Collection.all.map {|x| [x.name, x.id]}
      f.input :page_number
      f.input :publisher
      f.input :catalog_number
    end

    f.inputs 'Performances' do
      f.has_many :performances, heading: false, allow_destroy: true, new_record: true do |p|
        p.input :date
        p.input :season, as: :select, collection: Season.all.map{|x| [x.liturgical_season, x.id]}
        p.input :purpose
        p.input :voice
      end
    end
  
    f.actions
  end

  controller do
    def scoped_collection
      Piece.all
    end

    def create
      piece = params[:piece]
      piece = ActionController::Parameters.new(piece)
      @piece = Piece.create(piece.permit!) # TODO: insecure - fix!

      if @piece.errors.any?
        flash[:error] ||= []
        flash[:error].concat(@piece.errors.full_messages)
        redirect_to admin_piece_path()
      else
        redirect_to admin_piece_path(@piece.id)
      end
    end

    def update
      piece = params[:piece]

      # poll = Poll.parse_poll_params(poll)
      piece.keys.each do |key|
        if piece[key] == ''
          piece[key] = nil
        end
        if piece[key].class == Array
          piece[key] = piece[key].reject{|v| v.empty?}
        end
      end

      piece = ActionController::Parameters.new(piece)
      @piece = Piece.find(params[:id])
      if not @piece.update(piece.permit!) # returns boolean, not @poll
        flash[:error] ||= []
        flash[:error].concat(@piece.errors.full_messages)
        redirect_to :back
      else
        keys_updated = @piece.previous_changes.except('created_at', 'updated_at').keys.map {|x| "Piece.#{x}"}
        flash[:notice] = "Successfully updated "+ keys_updated.join(", ")
        redirect_to admin_piece_path(params[:id])
      end
    end
  end


end