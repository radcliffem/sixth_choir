namespace :db do
	
	task backup: :environment do 
		system("pg_dump --no-owner --schema=public -a choir_production > choir.psql")
	end

	task refresh: :environment do
		Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke

    system("psql -d choir_development < choir.psql")
	end

end