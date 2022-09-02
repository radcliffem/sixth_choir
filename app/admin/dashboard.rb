ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    section do
        @recent_performances = Performance.order(date: :desc)

        div class: 'recent_performances' do
            panel ("Recent Performances") do
              render 'admin/abre_components/performance_table', performances: @recent_performances, count: 8
            end
          end
        end
  end 
end
