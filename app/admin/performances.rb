ActiveAdmin.register Performance do
	config.sort_order = 'date_desc'
	actions :index, :show, :new, :destroy, :edit

	menu parent: 'Tables'

  filter :piece
  filter :date
  filter :purpose, as: :select, collection: Performance.all.map(&:purpose).uniq, multiple: true
  filter :season, collection: proc { Season.all.collect { |s| [s.to_s, s.id] } }, label: 'Season', multiple: true
  filter :voice, as: :select, collection: Piece.valid_voices, multiple: true


	index do
		column :date do |p|
			link_to p.date, admin_performance_path(p.id)
		end
		column 'Title' do |p|
			link_to p.piece.title, admin_piece_path(p.piece.id)
		end
    column :season do |p|
      p.liturgical_season
    end
		column :purpose
    column :voice
	end

	show do |p|
		columns do
			column do 
				attributes_table do
					row 'Title' do |p|
						link_to(p.piece.title, admin_piece_path(p.piece))
					end
					row :composers do
            p.piece.composers.to_a.map { |c| [
              link_to("#{c.name}", admin_composer_path(c.id)),
              ' | '] }.flatten[0...-1]
          end
          row :date
          row :acapella
          row :voice do 
            p.voice
          end
          row :season do 
            p.liturgical_season
          end
          row :purpose

          row 'Solo appearances' do |p|
            p.appearances.to_a.map{ |a| [link_to("#{a.name} | #{a.instrument}", admin_soloist_path(a.soloist.id)), ' | ']}.flatten[0...-1]
          end

				end
			end
      column do
        panel ("Music on this date") do
          performances = Performance.where(date: p.date)
          render 'admin/abre_components/performance_table', performances: performances, 
            composer: true, count: 10, title: true, season: false
        end
      
				panel ("All Performances of #{p.piece.title}") do
          performances = p.piece.performances.order(date: :desc)
          render 'admin/abre_components/performance_table', performances: performances, 
            composer: false, count: 10, title: false, season: true
				end
        
			end
		end
	end
	

  form do |f|

    f.semantic_errors
    f.inputs 'Details' do
      f.input :piece, as: :select, collection: Piece.all.order(:title)
      f.input :date
      f.input :season, as: :select, collection: Season.all.map{|s| [s.liturgical_season, s.id]}
      f.input :purpose
      f.input :voice, as: :select, collection: Piece.valid_voices
      f.input :acapella
      f.input :appearances, as: :select, collection: Appearance.all.map{|a| [a.display_appearance_date, a.id]}
    end

    f.inputs 'Appearances' do
      f.has_many :appearances, heading: false, allow_destroy: true, new_record: true do |a|
        a.input :soloist, as: :select, collection: Soloist.all.order(:name)
        a.input :payment
      end
    end
  
    f.actions
  end

  controller do
    def scoped_collection
      Performance.all.order(date: :desc)
    end

    def create
      performance = params[:performance]
      # poll = Poll.parse_poll_params(poll)
      performance = ActionController::Parameters.new(performance)
      @performance = Performance.create(performance.permit!) # TODO: insecure - fix!

      if @performance.errors.any?
        flash[:error] ||= []
        flash[:error].concat(@performance.errors.full_messages)
        redirect_to admin_performance_path()
      else
        redirect_to admin_performance_path(@performance.id)
      end
    end

    def update
      performance = params[:performance]

      # poll = Poll.parse_poll_params(poll)
      performance.keys.each do |key|
        if performance[key] == ''
          performance[key] = nil
        end
      end

      performance = ActionController::Parameters.new(performance)
      @performance = Performance.find(params[:id])
      if not @performance.update(performance.permit!) # returns boolean, not @poll
        flash[:error] ||= []
        flash[:error].concat(@performance.errors.full_messages)
        redirect_to :back
      else
        keys_updated = @performance.previous_changes.except('created_at', 'updated_at').keys.map {|x| "Performance.#{x}"}
        flash[:notice] = "Successfully updated "+ keys_updated.join(", ")
        redirect_to admin_performance_path(params[:id])
      end
    end
  end

end