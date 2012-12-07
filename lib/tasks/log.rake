namespace :log do
  desc "Calculate daily log"
  task :daily => :environment do
    puts "Creating log for #{Date.today}"
    DailyLog.create
  end
end