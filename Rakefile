require 'nanoc3/tasks'

task :deploy => :optimize do
  system 'cap deploy'
end                                                                  

task :optimize => [
  'optimize:html',
  # 'optimize:css',
  'optimize:js',
  'optimize:jpeg',
  'optimize:png'
]

namespace :optimize do
  desc 'Optimise JPEG images in output/images directory using jpegoptim'
  task :jpeg do
    puts `find output/images -name '*.jpg' -exec jpegoptim {} \\;`
  end

  desc 'Optimise PNG images in output/images directory using optipng'
  task :png do
    puts `find output/images -name '*.png' -exec optipng {} \\;`
  end

  desc 'Compress CSS files in output/style directory using YUI Compressor'
  task :css do
    puts `find output/stylesheets -name '*.css' -exec yuicompressor --type css '{}' -o '{}' \\;`
  end

  desc 'Compress JavaScript files in output/script directory using YUI Compressor'
  task :js do
    puts `find output/javascripts -name '*.js' -exec yuicompressor --type js '{}' -o '{}' \\;`
  end

  desc 'Compress HTML files in output directory using Google HTML Compressor'
  task :html do
    puts `find output -name '*.html' -exec htmlcompressor --type html '{}' -o '{}' \\;`
  end
  
  desc 'Compress XML files in output directory using Google HTML Compressor'
  task :xml do
    puts `find output -name '*.xml' -exec htmlcompressor --type xml '{}' -o '{}' \\;`
  end
end