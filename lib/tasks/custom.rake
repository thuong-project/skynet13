# lib/tasks/custom_seed.rake
namespace :db do
  namespace :seed do
    Dir[Rails.root.join('db', 'seeds', '*.rb')].each do |filename|
      task_name = File.basename(filename, '.rb')
      desc 'Seed ' + task_name + ', based on the file with the same name in `db/seeds/*.rb`'
      task task_name.to_sym => :environment do
        load(filename) if File.exist?(filename)
      end
    end
  end
end

namespace :db do
  task rmk: :environment do
    %w[db:drop db:create db:migrate].each do |task|
      puts 'remake db'
      Rake::Task[task].invoke
    end
  end

  task rmks: :environment do
    filename = Dir[File.join(Rails.root, 'db', 'seeds', "#{ENV['seed']}.rb")][0]

    Rake::Task['db:rmk'].invoke
    puts "Seeding #{filename}..."

    load(filename) if File.exist?(filename)
  end
end
