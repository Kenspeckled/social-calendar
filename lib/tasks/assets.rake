require './assets'
namespace :assets do
  task :precompile do
    version = Time.now.to_i 
    Assets.sprockets['app.js'].write_to("public/assets/app-#{version}.js")
    Assets.sprockets['styles.css'].write_to("public/assets/styles-#{version}.css")
    File.open('public/assets/version', 'w') { |f| f << version }
    puts "Done... Version #{version}"
  end
end
